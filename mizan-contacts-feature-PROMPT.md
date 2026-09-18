# PROMPT — Implement the **Contacts** Feature (Mizan Mobile App)

> Copy everything below the line and send it to the agent, together with the
> `mizan-flutter-expert` skill file and your Figma link(s).

---

## ROLE

You are working inside **`mizan_Mobile_App`** (Flutter). You must follow the
**`mizan-flutter-expert`** skill **literally** — it is the project's law.
Read it fully **before** writing a single line. If anything in this prompt
conflicts with the skill, the skill wins. If something is missing from both,
**stop and ask** — do not invent.

## OBJECTIVE

Implement **Feature: Contacts & VIP Contacts** end-to-end (data → domain →
presentation), wired to the real Mizan API, with the UI built from the Figma
design I provide.

## GROUND RULES (repeat back to me before you start)

1. Layer-first architecture: `app/ · data/ · domain/ · presentation/`. **No** `features/` folder.
2. Flow: `View → Cubit → UseCase → Repository → RemoteDataSource → AppServiceClient`.
3. All endpoints go into `lib/data/network/app_api.dart` as retrofit methods.
4. Repositories return `Future<Either<Failure, T>>` via the `_guard()` pattern; check `success != true` → `throw Exception(r.message)`.
5. States are **Freezed** with `flowState` + `data`; Cubits are `@injectable`; `if (isClosed) return;` before every emit.
6. Zero hardcoded colors/sizes/strings/assets — `ColorManager`, `AppSize/AppPadding`, `AppStrings`, `IconAssets`.
7. All UI text is **Arabic**; layout is RTL.
8. `401` and token refresh are already handled globally by `AuthInterceptor` — do not touch them.
9. Field names below are **exact and case-sensitive**. Do not rename, do not add fields.
10. When done, run `flutter pub run build_runner build --delete-conflicting-outputs` then `flutter analyze` and report the output.

---

## 1. THE DOMAIN MODEL

`lib/domain/model/contact_model.dart` — plain Dart, non-nullable:

```
Contact {
  String  id;
  String  name;
  String  phoneNumber;
  String  notes;
  bool    isVip;
  String  contactEmail;   // "" when null
  String  createdAt;
  String  updatedAt;
}

ContactsPage {              // paged wrapper
  List<Contact> items;
  int totalCount;
  int page;
  int pageSize;
  int totalPages;
}

ContactProfile {            // the /transactions endpoint payload
  String contactId;
  String contactName;
  String phoneNumber;
  String contactEmail;
  bool   isVip;
  int    totalTransactions;
  num    totalAmount;
  List<ContactTransaction> transactions;
}

ContactTransaction {
  String id;
  String partyName;
  String type;             // "Sale" | "Purchase"
  num    amount;
  String paymentMethod;    // "Cash" | ...
  String transactionDate;  // ISO-8601 UTC
}
```

Responses (`@JsonSerializable`, nullable) mirror these as `ContactData`,
`ContactsPageData`, `ContactProfileData`, `ContactTransactionData`, each wrapped
in a `*Response extends BaseResponse`. Mapping to domain uses
`orEmpty() / orZero() / orFalse()` from `app/extensions.dart`.

---

## 2. THE ENDPOINTS — one by one

**Base URL:** `https://mizanapi.duckdns.org` (already in `Constants.baseUrl`)
**Header:** `Authorization: Bearer {{access_token}}` — attached automatically by `AuthInterceptor`. Do **not** add it manually.
**Envelope:** `{ "success": bool, "message": string|null, "data": … }`
**Error:** `{ "statusCode": int, "message": "رسالة عربية" }`

---

### 2.1 — Create Contact · `POST /api/contacts`

**Request body**

| Field | Type | Required | Rules |
|---|---|---|---|
| `name` | String | ✅ | letters only (Arabic/English). Digits or symbols → `400` |
| `phoneNumber` | String | ✅ | Egyptian mobile, e.g. `01012345678` |
| `notes` | String | ❌ | free text |

```json
{ "name": "محمود حسن إبراهيم", "phoneNumber": "01012345678", "notes": "عميل موثوق ومستمر" }
```

**Response `201`**
```json
{
  "success": true,
  "message": "تم إضافة الطرف بنجاح",
  "data": {
    "id": "7b0a7cb5-8d9e-4a1b-bc3d-1e2f3a4b5c6d",
    "name": "محمود حسن إبراهيم",
    "phoneNumber": "01012345678",
    "notes": "عميل موثوق ومستمر",
    "isVip": false,
    "contactEmail": null,
    "createdAt": "2026-08-19T10:00:00Z",
    "updatedAt": "2026-08-19T10:00:00Z"
  }
}
```

**Error `400`** → `{ "statusCode": 400, "message": "اسم الطرف يجب أن يحتوي على أحرف فقط" }`

**Notes** — the same endpoint creates both **customers** and **suppliers**; there is no `type` field. Retrofit:
```dart
@POST("/api/contacts")
Future<ContactResponse> createContact(@Body() Map<String, dynamic> body);
```
UseCase: `CreateContactUseCase(CreateContactInput{name, phoneNumber, notes?}) → Contact`

---

### 2.2 — List Contacts · `GET /api/contacts`

**Query:** `page` (default 1) · `pageSize` (1–50, default 20) · `search` (optional, by name or phone)

**Response `200`**
```json
{
  "success": true, "message": null,
  "data": {
    "items": [ { "id": "...", "name": "...", "phoneNumber": "...", "notes": "...",
                 "isVip": true, "contactEmail": "mahmoud@example.com",
                 "createdAt": "...", "updatedAt": "..." } ],
    "totalCount": 1, "page": 1, "pageSize": 20, "totalPages": 1
  }
}
```
```dart
@GET("/api/contacts")
Future<ContactsPageResponse> getContacts(
  @Query("page") int page,
  @Query("pageSize") int pageSize,
  @Query("search") String? search,
);
```
UseCase: `GetContactsUseCase(GetContactsInput{page, pageSize, search?}) → ContactsPage`
Cubit: `getContacts()` (page 1, full-screen loading) + `loadMoreContacts()` (merge, `isLoadingMore`) + `searchContacts(query)` with a **400 ms debounce**, resetting to page 1.

---

### 2.3 — Get Contact by ID · `GET /api/contacts/{id}`

`@Path("id") String id` → same `data` shape as 2.1.
**Error `404`** → `{ "statusCode": 404, "message": "الطرف بالمعرف ... غير موجود" }`
UseCase: `GetContactByIdUseCase(String id) → Contact`

---

### 2.4 — Toggle VIP · `PATCH /api/contacts/{id}/toggle-vip`

No body. Returns the **full updated contact** with the flipped `isVip` and a fresh `updatedAt`.
```json
{ "success": true, "message": "تم تحديث حالة تمييز العميل بنجاح", "data": { ...contact, "isVip": true } }
```
```dart
@PATCH("/api/contacts/{id}/toggle-vip")
Future<ContactResponse> toggleVip(@Path("id") String id);
```
UseCase: `ToggleVipContactUseCase(String id) → Contact`
UI: **optimistic update** — flip the star immediately, replace the item with the server's contact on success, revert + show an error popup on failure.

---

### 2.5 — Contact Profile & Transactions · `GET /api/contacts/{id}/transactions`

**Response `200`**
```json
{
  "success": true, "message": null,
  "data": {
    "contactId": "7b0a7cb5-...", "contactName": "محمود حسن إبراهيم",
    "phoneNumber": "01012345678", "contactEmail": "mahmoud@example.com",
    "isVip": true, "totalTransactions": 2, "totalAmount": 750,
    "transactions": [
      { "id": "c1356f91-...", "partyName": "محمود حسن إبراهيم", "type": "Sale",
        "amount": 500, "paymentMethod": "Cash", "transactionDate": "2026-08-19T14:30:00Z" }
    ]
  }
}
```
Not paginated. `type` is a **string** (`"Sale"` / `"Purchase"`) — map it to a color: Sale → `ColorManager.success`, Purchase → `ColorManager.error`.
UseCase: `GetContactProfileUseCase(String id) → ContactProfile`

---

### 2.6 — List VIP Contacts · `GET /api/contacts/vip`

**Query:** `page`, `pageSize`. Same paged shape as 2.2, VIP only.
⚠️ Declare this retrofit method **before** `GET /api/contacts/{id}` so `vip` is never captured as an `{id}`.
UseCase: `GetVipContactsUseCase(GetVipContactsInput{page, pageSize}) → ContactsPage`

---

### 2.7 — Update Contact · `PUT /api/contacts/{id}`

**Request body (full object — send every field)**

| Field | Type | Notes |
|---|---|---|
| `name` | String | letters only |
| `phoneNumber` | String | |
| `notes` | String | |
| `isVip` | bool | |
| `contactEmail` | String | used by the reminder emails (Feature 3) |

```json
{ "name": "محمود حسن إبراهيم المعدل", "phoneNumber": "01099998888",
  "notes": "عميل VIP مميز", "isVip": true, "contactEmail": "mahmoud@example.com" }
```
**Response `200`** → `message: "تم تعديل الطرف بنجاح"` + the updated contact.
UseCase: `UpdateContactUseCase(UpdateContactInput{id, name, phoneNumber, notes, isVip, contactEmail}) → Contact`
UI: the edit form is pre-filled from the existing contact; don't send partial bodies.

---

### 2.8 — Soft Delete · `DELETE /api/contacts/{id}`

**Response `204 No Content` — empty body.**
```dart
@DELETE("/api/contacts/{id}")
Future<void> deleteContact(@Path("id") String id);
```
Repository: no `success` check possible (no body) — just `_guard(() async { await _remote.deleteContact(id); })` returning `Right(null)`.
UseCase: `DeleteContactUseCase(String id) → void`
UI: confirmation dialog first, then remove from the list and show a success popup `"تم حذف الطرف بنجاح"`.

---

## 3. FILES TO CREATE (exact paths)

```
lib/data/response/contact_responses/contact_responses.dart
lib/domain/model/contact_model.dart
lib/data/mapper/contact_mapper.dart
lib/data/network/app_api.dart                       (edit — add 8 methods)
lib/data/data_source/contact_remote_data_source.dart
lib/domain/repository/contact_repository.dart
lib/data/repository_impl/contact_repository_impl.dart
lib/domain/use_case/create_contact_use_case.dart
lib/domain/use_case/get_contacts_use_case.dart
lib/domain/use_case/get_contact_by_id_use_case.dart
lib/domain/use_case/toggle_vip_contact_use_case.dart
lib/domain/use_case/get_contact_profile_use_case.dart
lib/domain/use_case/get_vip_contacts_use_case.dart
lib/domain/use_case/update_contact_use_case.dart
lib/domain/use_case/delete_contact_use_case.dart
lib/presentation/customers/contacts_cubit/contacts_cubit.dart
lib/presentation/customers/contacts_cubit/contacts_state.dart
lib/presentation/customers/contact_form_cubit/contact_form_cubit.dart
lib/presentation/customers/contact_form_cubit/contact_form_state.dart
lib/presentation/customers/contact_profile_cubit/contact_profile_cubit.dart
lib/presentation/customers/contact_profile_cubit/contact_profile_state.dart
lib/presentation/customers/customers_view.dart            (replace placeholder)
lib/presentation/customers/contact_form_view.dart
lib/presentation/customers/contact_profile_view.dart
lib/presentation/customers/widgets/contact_card.dart
lib/presentation/customers/widgets/contacts_search_field.dart
lib/presentation/customers/widgets/vip_filter_tabs.dart
lib/presentation/customers/widgets/contact_transaction_tile.dart
lib/presentation/resources/strings_manager.dart           (edit — add strings)
lib/presentation/resources/routes_manager.dart            (edit — add routes)
```

New routes: `contactFormRoute = "/contactForm"` (args: `Contact?` → create vs edit) and `contactProfileRoute = "/contactProfile"` (args: `String contactId`). Register both in `RouteGenerator`.

---

## 4. SCREENS

**A. `CustomersView`** — replaces the current placeholder. Keeps the existing AppBar
(`ColorManager.surface`, `elevation: 0`, `centerTitle`, `Icons.arrow_forward_ios_rounded`, `AppStrings.contacts`).
- Search field (`IconAssets.search`, 400 ms debounce → `searchContacts`)
- Tabs: **الكل** / **العملاء المميزون** → `getContacts()` vs `getVipContacts()`
- Paged `ListView` of `ContactCard` + infinite scroll (`ScrollController` at 80 % → `loadMoreContacts()`); bottom `CircularProgressIndicator` while `isLoadingMore`
- Pull-to-refresh → page 1
- First load → `fullScreenLoadingState` (or `skeletonizer`); empty → `EmptyState("لا يوجد عملاء حتى الآن")`; failure → `fullScreenErrorState` with retry
- FAB → `contactFormRoute` (create)

**B. `ContactCard`** — avatar with initials, `name` (`getSemiBoldStyle`), `phoneNumber` (`getRegularStyle`, `textSecondary`), VIP star (`ColorManager.secondary` when `isVip`), tap → profile, star tap → toggle VIP, long-press / trailing menu → edit + delete.

**C. `ContactFormView`** — one screen for create **and** edit (`Contact?` argument).
Fields: `name`, `phoneNumber`, `notes`, and in edit mode also `contactEmail` + an `isVip` switch.
Client-side validation mirroring the server: name letters-only, phone required.
Loading/error via **popup** states; on success → pop + refresh the list.

**D. `ContactProfileView`** — header (name, phone, email, VIP badge), two summary cards
(`totalTransactions`, `totalAmount` formatted with `AppConstants.defaultCurrency`),
then the `transactions` list via `ContactTransactionTile` (Sale green / Purchase red).
Actions: toggle VIP, edit, delete.

---

## 5. DESIGN

Figma: **`<PASTE FIGMA LINK HERE>`** (node-id included in the URL).

Use the Figma MCP server before coding the UI: read the node's code/layout,
pull `get_variable_defs` for tokens, and fetch the image to verify your result.
Map every value to the existing managers (`ColorManager`, `AppSize`, `FontSize`);
only add a new token when it genuinely doesn't exist, and add it **to the manager**,
never inline. Convert px against the **402 × 874** canvas using `.w/.h/.r`.
Put a Figma-node comment header at the top of each screen file.
If you cannot read the design → ask me, don't improvise.

---

## 6. ARABIC STRINGS TO ADD (`AppStrings`)

```
addContact        = "إضافة طرف"
editContact       = "تعديل بيانات الطرف"
contactName       = "اسم الطرف"
phoneNumber       = "رقم الهاتف"
notes             = "ملاحظات"
contactEmail      = "البريد الإلكتروني"
markAsVip         = "عميل مميز"
allContacts       = "الكل"
vipContacts       = "العملاء المميزون"
noContactsYet     = "لا يوجد عملاء حتى الآن"
searchContacts    = "ابحث بالاسم أو رقم الهاتف"
totalTransactions = "عدد العمليات"
totalAmount       = "إجمالي التعاملات"
deleteContactConfirm = "هل أنت متأكد من حذف هذا الطرف؟"
contactDeleted    = "تم حذف الطرف بنجاح"
nameLettersOnly   = "اسم الطرف يجب أن يحتوي على أحرف فقط"
```

---

## 7. EXECUTION ORDER

1. Confirm the ground rules back to me in 5 lines, and list anything unclear.
2. Data layer: responses → model → mapper → `app_api.dart` → data source.
3. Domain layer: repository contract → repository impl → the 8 use cases.
4. `flutter pub run build_runner build --delete-conflicting-outputs`.
5. Presentation: states → cubits → widgets → the 3 screens → strings & routes.
6. `build_runner` again, then `flutter analyze`; paste the result.
7. Summarise: files created, endpoints covered, and anything you deliberately left out.

**Never** invent an endpoint, a field, a package, a color or a string.
If you hit a gap — stop and ask.
