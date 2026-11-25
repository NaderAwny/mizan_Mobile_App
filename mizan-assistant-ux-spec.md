# مواصفات تحسين تجربة "يا ميزان" — الباقة 1، 2، 3، 5، 6، 9

> **الهدف:** مساعد حي وممتع وأنيق، **من غير ما يتقل على الموبايل** ولا يبطّأ الرد.
> **النطاق:** Flutter فقط. **مفيش أي تعديل في الـ backend.** **مفيش أي package جديد.**
> **الكود في الملف ده مرجعي:** ما اتعملّوش compile ولا اتجرّب. كل جزء لازم يتكيّف مع كود التطبيق الفعلي، ويعدّي `flutter analyze` والاختبارات.

---

## 0. تعليمات للمنفّذ (IDE أو مطوّر)

1. **اقرأ الكود الحالي الأول.** شاشة المساعد (الكرة والحلقات والـ chips وشريط الإدخال وبطاقة التأكيد) موجودة. **عدّلها ما تعيدش بناءها.**
2. **ما تضيفش أي لون أو خط أو أيقونة من عندك.** كل القيم من الـ theme الموجود (القسم 2).
3. **ما تضيفش packages.** كله بـ Flutter الأساسي + `intl` + `shared_preferences` (لو موجودين أصلاً).
4. نفّذ **ميزة ميزة** بالترتيب في القسم 12. بعد كل ميزة: `flutter analyze` ثم الاختبارات ثم قياس الأداء (القسم 3).
5. **ما تلمسش** منطق الإرسال والجلسات والتأكيد في الـ API، غير ما هو مذكور صراحةً.
6. لو شيء في المواصفات بيتعارض مع الكود الفعلي، **اكتب الاختلاف** في تقرير بدل ما تخمّن.

---

## 1. فكرة التصميم

المساعد بيحس إنه "حي" لما **يتفاعل في كل لحظة**، مش لما يبقى فيه زخارف كتير. فالقواعد:

- **حركة بغرض:** كل حركة بتقول حاجة (بسمعك، بفكر، تمّ، رقم اتحسب).
- **قصيرة:** مفيش حركة بتاخد أكتر من 1.2 ثانية، ومفيش حاجة تمنع التاجر من الشغل.
- **ثابتة الشكل:** مفيش عناصر بتقفز أو بتغيّر حجمها فجأة (layout shift).
- **تقدر توقفها:** وضع "هادي" وإعداد "تقليل الحركة" في النظام.

---

## 2. الالتزام بالتصميم الحالي

من الصور: خلفية كريمية فاتحة، chips بيضاء على شكل أقراص بحد رفيع، زر رئيسي بلون نحاسي، كرة بنصفين (نحاسي وأخضر غامق) محاطة بحلقات ذهبية رفيعة وصغير نقاط بتدور، وورقة سفلية بحواف دائرية.

**اقرأ القيم الفعلية من الـ theme ولا تكتب hex جديد.** المطلوب تحديد المقابل لكل دور:

| الدور | يُستخدم في |
|---|---|
| لون الخلفية | خلفية الشاشة |
| لون السطح (أبيض الـ chips) | chips الاقتراحات، شريحة المقارنة |
| لون الحد الرفيع | حد الـ chips والشريط |
| اللون الرئيسي النحاسي | زر السحب، الأرقام الكبيرة |
| الأخضر | نجاح، ختم "تمّ" |
| الذهبي (الحلقات) | حلقات الكرة، قوس العدّاد |
| لون تحذير/كهرماني | خطأ هادئ، انخفاض المبيعات |
| ألوان النص (أساسي/ثانوي) | كل النصوص |

**القياسات:** استخدم نفس نصف قطر الحواف ونفس الخط ونفس المسافات الموجودة. لو مفيش token للحاجة، اقرأ القيمة من widget مشابه موجود.

**RTL:** كل ميزة لازم تشتغل صح في RTL (اتجاه السحب، ترتيب الـ chips، محاذاة الأرقام).

---

## 3. ميزانية الأداء (قاعدة ملزمة)

| القاعدة | التفصيل |
|---|---|
| لا `setState` على الشاشة كلها لأي حركة | الحركة المستمرة بـ `ValueNotifier` و`ValueListenableBuilder` أو `AnimatedBuilder` على أصغر widget |
| `RepaintBoundary` | حول الكرة، وحول الرقم المتحرك |
| الحركات بـ `Transform` و`Opacity` | بتتنفذ على الـ GPU من غير إعادة رسم. **ممنوع** `BackdropFilter` وblur وظلال ثقيلة جديدة |
| ticker واحد للكرة | بيقف لما مفيش حاجة بتتحرك، وبيقف لما التطبيق يروح الخلفية |
| حدّ تحديث الصوت | ≤ 30 مرة في الثانية (حوالي 33ms) |
| الحركات تحصل مرة واحدة | كل حركة (عدّ، كتابة، ظهور chips) بتشتغل **مرة واحدة** للرسالة، مش كل ما القائمة تتعاد بناؤها |
| القائمة | `ListView.builder` ولا حركة على عناصر خارج الشاشة |
| تقليل الحركة | لو `MediaQuery.disableAnimations` شغال: كل حاجة تظهر كاملة فوراً |
| الذاكرة | كل controller وnotifier ليه `dispose()`. بعد 50 رسالة الذاكرة لا تزيد بشكل مستمر |

**قياس القبول (على أضعف موبايل متاح):**
1. شغّل `flutter run --profile`، وافتح DevTools ← Performance.
2. سيناريو: افتح المساعد، دوس المايك، اتكلم 20 ثانية، ابعت 10 أسئلة، اسحب تأكيد.
3. **المطلوب:** نسبة الفريمات البطيئة (jank) **أقل من 1%** خلال سيناريو الصوت. ولا فريم يتجاوز 32ms في السحب.
4. سجّل النتيجة قبل وبعد كل ميزة. **أي ميزة بتزيد الـ jank عن 1% تتعدّل أو تتشال.**

---

## 4. عقد الإشارات بين طبقة الصوت والواجهة

طبقة الصوت (استماع، تحويل نص، رد صوتي) بتتبني منفصلة. الواجهة بتقرا منها **3 إشارات بس**، عشان نقدر نبدّل طريقة الصوت من غير ما نلمس الشاشة:

```dart
// lib/features/assistant/ux/assistant_ui_signals.dart
import 'package:flutter/foundation.dart';

enum VoiceUiState { idle, listening, silenceCountdown, thinking, speaking, error }

class AssistantUiSignals {
  final ValueNotifier<VoiceUiState> voiceState = ValueNotifier(VoiceUiState.idle);

  /// علو الصوت بعد التطبيع 0..1. التحديث بحدّ أقصى 30 مرة/ث.
  final ValueNotifier<double> soundLevel = ValueNotifier(0);

  /// تقدّم عدّاد الإرسال التلقائي بعد السكوت، 0..1.
  final ValueNotifier<double> countdown = ValueNotifier(0);

  void dispose() {
    voiceState.dispose();
    soundLevel.dispose();
    countdown.dispose();
  }
}
```

**كلمات الحالات في الواجهة** (نفس أسلوب النص الموجود):

| الحالة | النص |
|---|---|
| listening | بسمعك… اتكلم |
| silenceCountdown | لسه سامعك… كمّل أو اسكت وهبعت |
| thinking | بفكر… |
| speaking | بتكلم… (لمسة توقفه) |
| error | حصلت مشكلة، جرّب تاني |

---

## 5. عقد الـ API (اللي الواجهة بتعتمد عليه، من غير أي تعديل)

كل ردود المساعد: `{ success, data: { sessionId, sessionReset, type, message, data, options, pendingAction } }` (الـ `data` الداخلي هو `AssistantResponse.Data`).

**أنواع الرد (`type`):** `answer` / `question` / `confirmation` / `clarification` / `success` / `cancelled` / `error`.

**شكل `data` الداخلي لأسئلة الإحصائيات** (`type=answer`):
```json
{ "metric": "sales|purchases|both", "period": "today|yesterday|this_week|last_week|this_month|last_month|specific_date|specific_month",
  "label": "...", "totalSales": 0, "totalPurchases": 0, "operationsCount": 0, "transactions": [] }
```
**قوائم الأقساط:** `{ totalCount, items: [...] }`. **عميل:** `{ contactId, contactName, remainingDebt, totalOperations }` أو `{ balance: {...}, recentTransactions: [...] }`. **ديون:** `{ totalDebt, totalPaid, totalRemaining, plansCount }`. **إشعارات:** `{ totalCount, unreadOnly }`. **أكتر من أداة في رد واحد:** `data` بيكون **قائمة**.

**بطاقة التأكيد:** `pendingAction: { actionId, intent, summary, contactName, amount, installmentNumber, dueDate, expiresAt }`.

**Endpoints المستخدمة:**
- التأكيد: `POST /api/assistant/sessions/{sessionId}/actions/{actionId}/confirm`
- الإلغاء: `POST /api/assistant/sessions/{sessionId}/actions/{actionId}/cancel`
- إحصائيات يوم: `GET /api/statistics/daily?date=YYYY-MM-DD`
- إحصائيات شهر: `GET /api/statistics/monthly?year=&month=`
- تراجع (حذف ناعم): `DELETE /api/transactions/{id}`

> **الحقول اللي ما اتأكدتش منها** (اقرأها من نماذج التطبيق الفعلية): اسم قائمة التوزيع اليومي في رد `/monthly`، وشكل رد التأكيد لما العملية بيع جديد (المفروض `data.data.id` هو معرّف العملية). **لو الحقل غير موجود، الميزة المعتمدة عليه تتخفّى بهدوء، ولا تفترض قيمة.**

---

## 6. الميزة 1: الكرة بتتفاعل مع صوتك

### السلوك

الكرة الحالية (النصفين + الحلقات الذهبية + النقاط الدوّارة) **تفضل بشكلها**. بنضيف عليها **حركة بحسب الحالة** بس:

| الحالة | الكرة | الحلقات |
|---|---|---|
| idle | "تنفّس" خفيف جداً (±1.5%) لمدة 10 ثواني بعد آخر تفاعل، وبعدها **تثبت** (توفير بطارية) | ثابتة |
| listening | تكبر وتصغّر مع علو صوتك (حتى +14%) | موجات بتتوسّع وتبهت، وسرعتها وقوتها بعلو الصوت |
| silenceCountdown | ثابتة تقريباً (+2%) | **قوس ذهبي رفيع** حولها بيتناقص مع عدّاد الإرسال |
| thinking | **بتلف** لفّة كل 2.4 ثانية ونبضة خفيفة | ثابتة |
| speaking | نبضة ناعمة بإيقاع ثابت (حوالي 2 نبضة/ث) | موجات هادية |
| error | هزّة أفقية قصيرة (±4px، 0.4 ثانية) | ثابتة |

**قواعد مهمة:**
- عند الخروج من thinking الكرة **تكمّل اللفّة** لحد ما ترجع لوضعها بدل ما تقفز (النصفين لهم لونين، القفزة بتبان).
- لو `disableAnimations`: مفيش حركة. اللون والنص بس.
- لما التطبيق يروح الخلفية: وقّف الـ ticker.

### تطبيع علو الصوت (مهم)
قيم `onSoundLevelChange` بتختلف بين الأجهزة، فالمقارنة بقيمة ثابتة مش هتنفع. بنطبّع على آخر 3 ثواني:

```dart
// lib/features/assistant/ux/sound_level_normalizer.dart
import 'dart:collection';
import 'dart:math' as math;

class SoundLevelNormalizer {
  SoundLevelNormalizer({this.window = const Duration(seconds: 3), this.minRange = 3.0});
  final Duration window;
  final double minRange; // أقل مدى نعتبره "صوت فعلي" حتى الصمت ما يتضخمش
  final Queue<(DateTime, double)> _samples = Queue();

  double normalize(double raw, DateTime now) {
    _samples.addLast((now, raw));
    while (_samples.isNotEmpty && now.difference(_samples.first.$1) > window) {
      _samples.removeFirst();
    }
    var lo = raw, hi = raw;
    for (final s in _samples) {
      if (s.$2 < lo) lo = s.$2;
      if (s.$2 > hi) hi = s.$2;
    }
    final range = math.max(hi - lo, minRange);
    return ((raw - lo) / range).clamp(0.0, 1.0);
  }
}
```
**التغذية** (في طبقة الصوت، مع تخفيف التحديث):
```dart
DateTime _lastLevelAt = DateTime.fromMillisecondsSinceEpoch(0);
void onSoundLevel(double raw) {
  final now = DateTime.now();
  if (now.difference(_lastLevelAt).inMilliseconds < 33) return;
  _lastLevelAt = now;
  signals.soundLevel.value = _normalizer.normalize(raw, now);
}
```

### الـ widget

```dart
// lib/features/assistant/ux/orb_reactive.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'assistant_ui_signals.dart';

class _Frame {
  const _Frame(this.scale, this.angle, this.dx, this.level, this.phase);
  final double scale, angle, dx, level, phase;
}

/// يلف الكرة الحالية [orb] ويحرّكها. الكرة نفسها بتتبني مرة واحدة (child) والحركة Transform بس.
class OrbReactive extends StatefulWidget {
  const OrbReactive({super.key, required this.signals, required this.orb, required this.ringColor, this.size = 200});
  final AssistantUiSignals signals;
  final Widget orb;
  final Color ringColor; // الذهبي من الـ theme
  final double size;

  @override
  State<OrbReactive> createState() => _OrbReactiveState();
}

class _OrbReactiveState extends State<OrbReactive> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  static const _twoPi = 2 * math.pi;
  late final AnimationController _ticker;
  final Stopwatch _sw = Stopwatch()..start();
  final ValueNotifier<_Frame> _frame = ValueNotifier(const _Frame(1, 0, 0, 0, 0));
  double _level = 0, _angle = 0, _lastT = 0, _errorStart = -10;
  DateTime _lastInteraction = DateTime.now();
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = AnimationController(vsync: this, duration: const Duration(seconds: 1))..addListener(_onTick);
    widget.signals.voiceState.addListener(_onState);
    _wake();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.of(context).disableAnimations;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) {
      _wake();
    } else {
      _ticker.stop();
    }
  }

  void _onState() {
    _lastInteraction = DateTime.now();
    if (widget.signals.voiceState.value == VoiceUiState.error) {
      _errorStart = _sw.elapsedMilliseconds / 1000.0;
    }
    _wake();
  }

  void _wake() {
    if (!_ticker.isAnimating) _ticker.repeat();
  }

  void _onTick() {
    final t = _sw.elapsedMilliseconds / 1000.0;
    final dt = (t - _lastT).clamp(0.0, 0.05);
    _lastT = t;
    final st = widget.signals.voiceState.value;

    final target = st == VoiceUiState.listening ? widget.signals.soundLevel.value : 0.0;
    _level += (target - _level) * (target > _level ? 0.35 : 0.08); // صعود سريع، هبوط ناعم

    final breathing = DateTime.now().difference(_lastInteraction).inSeconds < 10;
    var scale = switch (st) {
      VoiceUiState.listening => 1 + 0.14 * _level,
      VoiceUiState.speaking => 1.04 + 0.03 * math.sin(_twoPi * 2.2 * t),
      VoiceUiState.thinking => 1 + 0.02 * math.sin(_twoPi * 1.2 * t),
      VoiceUiState.silenceCountdown => 1.02,
      _ => breathing ? 1 + 0.015 * math.sin(_twoPi * t / 3.5) : 1.0,
    };
    if (_reduceMotion) scale = 1;

    // دوران: يكمّل لفّة كاملة عند الخروج بدل القفز
    if (st == VoiceUiState.thinking && !_reduceMotion) {
      _angle = (_angle + _twoPi * dt / 2.4) % _twoPi;
    } else if (_angle != 0) {
      _angle += (_twoPi - _angle) * 0.12;
      if (_twoPi - _angle < 0.01) _angle = 0;
    }

    var dx = 0.0;
    if (st == VoiceUiState.error && !_reduceMotion) {
      final e = t - _errorStart;
      if (e >= 0 && e < 0.4) dx = math.sin(e * 50) * 4 * (1 - e / 0.4);
    }

    _frame.value = _Frame(scale, _angle, dx, _level, (t * 0.8) % 1.0);

    // وقّف الـ ticker لو مفيش حاجة بتتحرك (توفير بطارية)
    final idle = st == VoiceUiState.idle || st == VoiceUiState.error;
    final settled = _level < 0.01 && _angle == 0 && (t - _errorStart) > 0.5;
    if (idle && settled && !breathing) _ticker.stop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.signals.voiceState.removeListener(_onState);
    _ticker.dispose();
    _frame.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: widget.size,
      child: RepaintBoundary(
        child: Stack(alignment: Alignment.center, children: [
          Positioned.fill(
            child: CustomPaint(painter: _RingsPainter(_frame, widget.signals.voiceState, widget.ringColor)),
          ),
          ValueListenableBuilder<_Frame>(
            valueListenable: _frame,
            child: widget.orb,
            builder: (_, f, child) => Transform.translate(
              offset: Offset(f.dx, 0),
              child: Transform.scale(scale: f.scale, child: Transform.rotate(angle: f.angle, child: child)),
            ),
          ),
        ]),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter(this.frame, this.state, this.color) : super(repaint: frame);
  final ValueNotifier<_Frame> frame;
  final ValueListenable<VoiceUiState> state;
  final Color color;
  final Paint _p = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.2;

  @override
  void paint(Canvas canvas, Size size) {
    final s = state.value;
    final active = s == VoiceUiState.listening || s == VoiceUiState.speaking;
    final f = frame.value;
    if (!active && f.level < 0.02) return;
    final center = size.center(Offset.zero);
    final base = size.width * 0.34;
    final strength = s == VoiceUiState.speaking ? 0.35 : f.level;
    for (var i = 0; i < 3; i++) {
      final p = (f.phase + i / 3) % 1.0;
      final r = base * (1 + 0.55 * p * (0.4 + strength));
      final a = ((1 - p) * (0.10 + 0.35 * strength)).clamp(0.0, 1.0);
      _p.color = color.withAlpha((a * 255).round());
      canvas.drawCircle(center, r, _p);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter old) => old.color != color;
}
```
> **ملحوظة:** لو الحلقات الحالية بتترسم بالفعل، **ما ترسمهاش تاني.** اربط الحلقات الحالية بـ `frame.level` و`frame.phase` بدل ما تضيف painter جديد. ونقاط الحلقات الدوّارة تفضل زي ما هي.

### معيار القبول
- الكرة بتكبر وتصغر مع صوتك بشكل ملحوظ ومن غير تقطيع.
- بعد 10 ثواني من آخر تفاعل والشاشة ساكنة: **مفيش frames بتتولد** (راجع Performance overlay).
- بعد الخروج من thinking: مفيش قفزة في النصفين.

---

## 7. الميزة 2: الأرقام بتعدّ + شريحة المقارنة

### الشكل
في رد الإحصائيات (`data.metric` موجود) بنضيف **سطر رقم كبير** فوق نص الرد، بالـ typography الأساسية بلون النحاسي، مع **شريحة صغيرة** تحته على شكل قرص (نفس شكل chips الاقتراح لكن أصغر):

```
مبيعات النهارده
6,270 جنيه            ← الرقم بيعدّ من صفر لحد القيمة (0.4–0.9 ثانية)
[ امبارح كان 5,200 ]  ← شريحة المقارنة (بتظهر لما الرقم يوصل)
```
النص العادي (الـ `message`) تحتها زي ما هو.

### قواعد الصدق (مهمة)
الأرقام غلط بثقة بتخرّب الثقة، فالقواعد:

1. **الرقم الكبير = `data.totalSales` أو `data.totalPurchases`** نفس اللي في الرد، ما نحسبوش من عندنا. لو `metric=both` اعرض الاتنين بسطرين.
2. **المقارنة بتتحسب من إحصائيات الـ API**، وبتتجاب بعد ظهور الرد (طلب واحد، يتخزن 60 ثانية). **لو الطلب فشل أو اتأخر، ما نعرضش شريحة.** الرد ما بيستناش.
3. **ما بنقارنش يوم ناقص بيوم كامل بنسبة مئوية.** اليوم الحالي لسه ما خلصش، فالنسبة بتبان انخفاض مضلّل الصبح:

| الفترة | بنقارن بـ | الشكل |
|---|---|---|
| today | امبارح | **محايد**: "امبارح كان X" (من غير نسبة) |
| yesterday | اليوم اللي قبله | نسبة: "▲ 18% عن اليوم اللي قبله" |
| last_month | الشهر اللي قبله | نسبة |
| this_month | نفس عدد الأيام من الشهر السابق (لو توزيع الأيام موجود في رد `/monthly`) | نسبة. **وإلا:** "الشهر اللي فات كامل: X" محايد |
| this_week / last_week / specific_* | — | **مفيش شريحة** في النسخة دي |

4. **اللون:** للمبيعات: ارتفاع أخضر، انخفاض كهرماني (مش أحمر). للمشتريات: **لون محايد في الحالتين** (انخفاض المشتريات مش بالضرورة سيئ).
5. لو القيمة السابقة 0 والحالية > 0: "جديد". لو الاتنين 0: مفيش شريحة. لو الفرق أقل من 1%: "ثابت تقريباً".
6. **افترض إن جهاز المستخدم على توقيت مصر.** لو `DateTime.now().timeZoneOffset` مش ساعتين ولا تلاتة: **ما نعرضش مقارنات** (التواريخ ممكن تتزحزح).

### الكود

```dart
// lib/features/assistant/ux/comparison.dart
enum ComparisonTone { up, down, neutral }

class ComparisonChipData {
  const ComparisonChipData(this.text, this.tone);
  final String text;
  final ComparisonTone tone;
}

/// ماذا نجيب للمقارنة؟ null = لا مقارنة.
class ComparisonSource {
  const ComparisonSource.daily(this.date) : year = null, month = null;
  const ComparisonSource.monthly(this.year, this.month) : date = null;
  final DateTime? date;
  final int? year, month;
}

ComparisonSource? comparisonSourceFor(String period, DateTime egyptToday) {
  switch (period) {
    case 'today':
      return ComparisonSource.daily(egyptToday.subtract(const Duration(days: 1)));
    case 'yesterday':
      return ComparisonSource.daily(egyptToday.subtract(const Duration(days: 2)));
    case 'last_month':
      final d = DateTime(egyptToday.year, egyptToday.month - 2, 1);
      return ComparisonSource.monthly(d.year, d.month);
    case 'this_month':
      final d = DateTime(egyptToday.year, egyptToday.month - 1, 1);
      return ComparisonSource.monthly(d.year, d.month);
    default:
      return null;
  }
}

/// [format] نفس تنسيق الأرقام في باقي التطبيق.
ComparisonChipData? buildComparison({
  required String period,
  required bool isPurchases,
  required double current,
  required double? previous,       // null = فشل الجلب
  required String Function(double) format,
}) {
  if (previous == null) return null;
  if (period == 'today') {
    return ComparisonChipData('امبارح كان ${format(previous)}', ComparisonTone.neutral);
  }
  if (previous == 0) {
    return current == 0 ? null : const ComparisonChipData('جديد', ComparisonTone.neutral);
  }
  final pct = (current - previous) / previous * 100;
  if (pct.abs() < 1) return const ComparisonChipData('ثابت تقريباً', ComparisonTone.neutral);
  final up = pct > 0;
  final tone = isPurchases ? ComparisonTone.neutral : (up ? ComparisonTone.up : ComparisonTone.down);
  final label = period == 'yesterday' ? 'عن اليوم اللي قبله' : 'عن الفترة اللي قبلها';
  return ComparisonChipData('${up ? '▲' : '▼'} ${pct.abs().round()}% $label', tone);
}
```

**رقم متحرك** (مرة واحدة للرسالة):
```dart
// lib/features/assistant/ux/count_up_number.dart
import 'dart:math' as math;
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CountUpNumber extends StatelessWidget {
  const CountUpNumber({
    super.key,
    required this.value,
    required this.animate,   // false لو الرسالة اتعرضت قبل كده (scroll أو إعادة بناء)
    required this.onDone,    // علّم الرسالة إنها اتحركت (animated = true)
    required this.style,
    this.suffix = ' جنيه',
  });
  final num value;
  final bool animate;
  final VoidCallback onDone;
  final TextStyle style;
  final String suffix;

  // استخدم نفس تنسيق الأرقام (أرقام لاتينية أو هندية) المستخدم في باقي التطبيق
  static final NumberFormat _fmt = NumberFormat.decimalPattern('en');

  static Duration _duration(num v) {
    final digits = v.abs() < 10 ? 1.0 : math.log(v.abs()) / math.ln10;
    return Duration(milliseconds: (400 + 120 * digits).clamp(400.0, 900.0).round());
  }

  @override
  Widget build(BuildContext context) {
    final s = style.copyWith(fontFeatures: const [FontFeature.tabularFigures()]); // أرقام بعرض ثابت
    final reduce = MediaQuery.of(context).disableAnimations;
    if (!animate || reduce) {
      return RepaintBoundary(child: Text('${_fmt.format(value.round())}$suffix', style: s));
    }
    return RepaintBoundary(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.toDouble()),
        duration: _duration(value),
        curve: Curves.easeOutCubic,
        onEnd: onDone,
        builder: (_, v, __) => Text('${_fmt.format(v.round())}$suffix', style: s),
      ),
    );
  }
}
```
**الشريحة** تظهر بـ fade + انزلاق 6px خلال 200ms بعد `onDone` (مرة واحدة).

### معيار القبول
- نفس الرقم بيظهر في الرقم الكبير والنص.
- المقارنة بتظهر بعد الرقم، ولو الإنترنت وقع: الرد يظهر عادي بدون شريحة.
- لما تعمل scroll والرسالة ترجع للشاشة: **مفيش عدّ تاني**.
- سؤال "النهارده" الصبح: **مفيش نسبة مئوية**.

---

## 8. الميزة 3: أزرار الاقتراح بعد كل رد

### الشكل
تحت آخر رد من المساعد (وبس، **الردود القديمة تفقد أزرارها**): صف أفقي من **حتى 3 chips** بنفس شكل chips الصفحة الرئيسية ("مين عليه فلوس متأخرة؟" وغيرها). تظهر بالتتابع (120ms بين كل واحد، fade + انزلاق 8px). والضغط عليها بيبعتها كرسالة مستخدم عادية (فقاعة المستخدم تظهر).

### قواعد
1. **بتتحدد في التطبيق** من `type` وشكل `data` (القسم 5). مفيش backend.
2. الجمل المقترحة **من الجمل اللي اتجرّبت ونجحت** (مبيعات النهارده كام؟ إلخ)، عشان المساعد يفهمها.
3. **ما بتظهرش** بعد: `question` و`confirmation` و`clarification` و`error` (المستخدم لازم يجاوب أو يؤكد). بعد `clarification` الخيارات هي الأزرار.
4. تتشال أي chip جملتها = آخر رسالة المستخدم.
5. لو الرد قائمة نتائج (`data` قائمة) مفيش اقتراحات.
6. كل ضغطة = نداء واحد للمساعد (يحسب في حد 20 طلب/دقيقة).

### الجدول والكود

```dart
// lib/features/assistant/ux/suggestions.dart
class Suggestion {
  Suggestion.send(this.label, [String? text]) : sendText = text ?? label, route = null;
  Suggestion.go(this.label, this.route) : sendText = null;
  final String label;
  final String? sendText;  // يتبعت كرسالة
  final String? route;     // أو ينقل لشاشة (محلي، من غير مساعد)
}

/// [type] و[data] و[hasItems] من رد المساعد.
List<Suggestion> suggestionsFor({
  required String type,
  required Object? data,
  String? lastUserText,
}) {
  if (const {'question', 'confirmation', 'clarification', 'error', 'cancelled'}.contains(type)) return const [];
  if (data is List) return const []; // أكتر من أداة في رد واحد

  final m = data is Map ? Map<String, dynamic>.from(data) : null;
  List<Suggestion> out;

  if (type == 'success') {
    out = [Suggestion.send('مبيعات النهارده كام؟'), Suggestion.send('مين متأخر عليا؟')];
  } else if (m != null && m.containsKey('metric')) {
    final period = m['period'] as String?;
    final metric = m['metric'] as String?;
    out = switch (period) {
      'today' => [
          Suggestion.send('امبارح حصل إيه؟'),
          if (metric == 'sales') Suggestion.send('المشتريات النهارده كام؟') else Suggestion.send('مبيعات النهارده كام؟'),
          Suggestion.send('مين متأخر عليا؟'),
        ],
      'yesterday' => [Suggestion.send('مبيعات النهارده كام؟'), Suggestion.send('اشتريت بكام الشهر ده؟')],
      'this_month' => [Suggestion.send('مبيعات الشهر اللي فات؟'), Suggestion.send('مين متأخر عليا؟'), Suggestion.send('الديون كام؟')],
      'last_month' => [Suggestion.send('اشتريت بكام الشهر ده؟'), Suggestion.send('الديون كام؟')],
      'this_week' => [Suggestion.send('امبارح حصل إيه؟'), Suggestion.send('مين متأخر عليا؟')],
      _ => const [],
    };
  } else if (m != null && m.containsKey('items') && m.containsKey('totalCount')) {
    final n = (m['totalCount'] as num?)?.toInt() ?? 0;
    out = n > 0
        ? [Suggestion.send('ذكّرهم كلهم'), Suggestion.send('الديون كام؟')]
        : [Suggestion.send('إيه الأقساط الجاية؟')];
  } else if (m != null && (m.containsKey('remainingDebt') || m.containsKey('balance'))) {
    final bal = m['balance'] is Map ? Map<String, dynamic>.from(m['balance'] as Map) : m;
    final name = bal['contactName'] as String?;
    final debt = (bal['remainingDebt'] as num?)?.toDouble() ?? 0;
    out = (name != null && debt > 0) ? [Suggestion.send('ذكّر $name'), Suggestion.send('مين متأخر عليا؟')] : const [];
  } else if (m != null && m.containsKey('totalRemaining')) {
    out = [Suggestion.send('مين متأخر عليا؟'), Suggestion.send('إيه الأقساط الجاية؟')];
  } else if (m != null && m.containsKey('unreadOnly')) {
    out = [Suggestion.go('افتح الإشعارات', '/notifications')]; // عدّل المسار حسب الـ router
  } else {
    out = const [];
  }

  final last = lastUserText?.trim();
  return out.where((s) => s.label != last).take(3).toList();
}
```
> **تحقق مطلوب:** "ذكّرهم كلهم" و"ذكّر <اسم>" يعتمدوا على فهم المساعد للمتابعة. جرّبهم في Apidog قبل ما تعتمد عليهم، ولو فشلوا شيلهم.

**ظهور تدريجي بـ controller واحد للمجموعة:**
```dart
class SuggestionRow extends StatefulWidget {
  const SuggestionRow({super.key, required this.items, required this.onTap, required this.chipBuilder});
  final List<Suggestion> items;
  final void Function(Suggestion) onTap;
  final Widget Function(String label, VoidCallback onTap) chipBuilder; // chip التصميم الحالي
  @override
  State<SuggestionRow> createState() => _SuggestionRowState();
}

class _SuggestionRowState extends State<SuggestionRow> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.of(context).disableAnimations) { _c.value = 1; } else { _c.forward(); }
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final n = widget.items.length;
    return RepaintBoundary(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (var i = 0; i < n; i++)
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 8),
              child: _Staggered(
                animation: CurvedAnimation(parent: _c, curve: Interval(i * 0.2, 0.6 + i * 0.2, curve: Curves.easeOutCubic)),
                child: widget.chipBuilder(widget.items[i].label, () => widget.onTap(widget.items[i])),
              ),
            ),
        ]),
      ),
    );
  }
}

class _Staggered extends AnimatedWidget {
  const _Staggered({required Animation<double> animation, required this.child}) : super(listenable: animation);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final v = (listenable as Animation<double>).value;
    return Opacity(opacity: v, child: Transform.translate(offset: Offset(0, 8 * (1 - v)), child: child));
  }
}
```

### معيار القبول
- بعد "مبيعات النهارده كام؟" بتظهر 3 اقتراحات مناسبة، وضغطة على واحدة بتبعتها.
- ردود المساعد القديمة ما فيهاش اقتراحات.
- مفيش اقتراح بيتكرر زي سؤالك السابق.

---
