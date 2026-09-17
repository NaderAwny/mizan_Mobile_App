# عقد الـ API الحقيقي — Mizan / Authentication & Accounts

> مستخرج حرفيًا من الـ Postman collection اللي رفعها المستخدم (مش تخمين). أي اختلاف بين
> الملف ده وبين أي كود قديم موجود عندك في المشروع، الأولوية للملف ده لأنه هو العقد الحقيقي.
>
> Base wrapper شكله: `{ "success": bool, "message": string, "data": T }` — **مش** `status`.

## 1. `POST /api/auth/register`
Request:
```json
{ "email": "owner@mizan.app", "firstName": "نادر", "lastName": "عوني" }
```
Response 200:
```json
{
  "success": true,
  "message": "تم إرسال كود التحقق بنجاح",
  "data": { "email": "owner@mizan.app", "otpSent": true, "expiresInSeconds": 120 }
}
```
أخطاء شائعة: 400 (بريد غير صالح / دومين وهمي).

## 2. `POST /api/auth/send-otp`
Request:
```json
{ "email": "owner@mizan.app" }
```
Response 200: نفس شكل `register` بالظبط (`email`, `otpSent`, `expiresInSeconds`).
أخطاء شائعة: 404 (البريد مش مسجل).

> `register` و`send-otp` بيرجعوا نفس الـ Data shape بالظبط → نفس موديل الاستجابة (`OtpResponse`).

## 3. `POST /api/auth/verify-otp`
Request:
```json
{ "email": "owner@mizan.app", "code": "123456" }
```
Response 200:
```json
{
  "success": true,
  "message": "تم تسجيل الدخول بنجاح",
  "data": {
    "token": "eyJ...",
    "refreshToken": "c+Od...",
    "expiresInSeconds": 604800,
    "isNewUser": false,
    "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
    "firstName": "نادر",
    "lastName": "عوني",
    "email": "owner@mizan.app",
    "userType": "shop_owner",
    "shopName": "محل ميزان"
  }
}
```
أخطاء شائعة: 400 (كود غلط أو منتهي).

## 4. `POST /api/auth/select-user-type`
Request:
```json
{ "userType": "shop_owner", "shopName": "محل ميزان التجاري", "address": "القاهرة، مصر" }
```
Response 200: **نفس شكل `verify-otp` بالظبط** (نفس الحقول التسعة). فـ `verify-otp` و`select-user-type`
و`refresh-token` التلاتة بيرجعوا نفس الـ Data shape → موديل استجابة واحد (`AuthSessionResponse`).

> ملاحظة: `userType` القيم المعروفة لحد دلوقتي: `"customer"` و`"shop_owner"` (حسب وصف الـ collection).

## 5. `POST /api/auth/refresh-token`
Request:
```json
{ "refreshToken": "{{refresh_token}}" }
```
Response 200: نفس شكل `AuthSessionResponse` (نفس حقول `verify-otp`).

## 6. `POST /api/auth/logout`
Request:
```json
{ "refreshToken": "{{refresh_token}}" }
```
Response 200:
```json
{ "success": true, "message": "تم تسجيل الخروج بنجاح", "data": null }
```
→ `data` دايمًا `null`، فبيتلف بـ `BaseResponse` العادي (زي اللي في Glowy) من غير subclass.

---

## خلاصة الموديلات المطلوبة (2 بس + BaseResponse)

| الموديل | يُستخدم في | الحقول |
|---|---|---|
| `OtpResponse extends BaseResponse` | register, send-otp | `email`, `otpSent`, `expiresInSeconds` |
| `AuthSessionResponse extends BaseResponse` | verify-otp, select-user-type, refresh-token | `token`, `refreshToken`, `expiresInSeconds`, `isNewUser`, `userId`, `firstName`, `lastName`, `email`, `userType`, `shopName` |
| `BaseResponse` (نفس اللي في Glowy) | logout | — (`data` مالهاش لازمة) |
