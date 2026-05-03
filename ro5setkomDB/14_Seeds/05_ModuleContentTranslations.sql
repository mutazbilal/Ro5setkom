INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Introduction to Driving Responsibilities

## Legal and Personal Responsibilities
- No person may drive any vehicle in Jordan without a valid, lawful driving license authorizing them to drive that specific vehicle category.
- Drivers must always carry their driving license, vehicle license, and insurance documents.
- You must present these documents to any traffic officer upon request.

## Basic Safety Principles
- Driving is a skill that requires full attention, respect for laws, and consideration for other road users.
- The general rule of right-of-way: **priority is given, not taken**.
- Always drive in a way that avoids endangering yourself or others.

## Fitness to Drive
- You must be physically and mentally fit to drive.
- Medical fitness is determined through an official medical examination (vision, limb health, and general health).
- Minimum vision requirement for most licenses: 6/9 in the better eye.

## Required Attitude
- Do not drive if you are tired, emotional, or under the influence of any substance.
- Good driving is a combination of technical skill, knowledge of laws, and ethical behavior.

## Consequences of Violations
- Violations lead to fines, imprisonment, license suspension, or impoundment of the vehicle.
- Repeated violations result in a points system that can revoke your license.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# مقدمة لمسؤوليات القيادة

## المسؤوليات القانونية والشخصية
- لا يجوز لأي شخص قيادة أي مركبة في الأردن دون الحصول على رخصة قيادة قانونية سارية المفعول تخوله قيادة تلك الفئة المحددة من المركبات.
- يجب على السائقين دائمًا حمل رخصة القيادة ورخصة السيارة ووثائق التأمين.
- يجب عليك تقديم هذه المستندات إلى أي ضابط مرور عند الطلب.

## مبادئ السلامة الأساسية
- القيادة مهارة تتطلب الاهتمام الكامل واحترام القوانين ومراعاة مستخدمي الطريق الآخرين.
- القاعدة العامة لحق الأولوية: **الأولوية تعطى ولا تؤخذ**.
- قم دائمًا بالقيادة بطريقة تتجنب تعريض نفسك أو الآخرين للخطر.

## اللياقة للقيادة
- يجب أن تكون لائقًا بدنيًا وعقليًا للقيادة.
- يتم تحديد اللياقة الطبية من خلال فحص طبي رسمي (الرؤية، صحة الأطراف، الصحة العامة).
- الحد الأدنى لمتطلبات الرؤية لمعظم التراخيص: 6/9 في العين الأفضل.

## الموقف المطلوب
- لا تقود السيارة إذا كنت متعباً أو عاطفياً أو تحت تأثير أي مادة.
- القيادة الجيدة هي مزيج من المهارات الفنية ومعرفة القوانين والسلوك الأخلاقي.

##عواقب المخالفات
- المخالفات تؤدي إلى غرامات أو حبس أو إيقاف الترخيص أو حجز المركبة.
- تؤدي الانتهاكات المتكررة إلى نظام النقاط الذي يمكنه إلغاء الترخيص الخاص بك.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Jordanian License Categories and Requirements

## License Categories (Feras)

| Category | Vehicle Type |
|----------|---------------|
| 1 | Motorcycle / Scooter |
| 2 | Agricultural vehicle |
| 3 | Private car (manual or automatic), up to 5 tons |
| 4 | Public passenger car / vehicle up to 7.5 tons |
| 5 | Medium bus / vehicle over 7.5 tons |
| 6 | Tractor + trailer / heavy bus |
| 7 | Vehicles for people with disabilities |

## Age Requirements
- Categories 1, 2, 3, 7: Minimum 18 years
- Category 4: Minimum 21 years
- Category 4 requires at least 1 year holding Category 3 (manual)
- Categories 5 or 6: Minimum of 2 years after obtaining the previous category

## Required Documents for New License
1. Official application form
2. Three recent color photos (6×4 cm)
3. Civil ID card or passport (with national number)
4. Proof of age (birth certificate or ID)
5. Training completion certificate (practical + theoretical except categories 1 & 2)

## Renewal and Replacement
- Renewal requires the same documents plus the expired license.
- Replacement for lost/damaged requires a special form, photos, ID, and damaged license (if any).'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# فئات ومتطلبات الترخيص الأردني

## فئات الترخيص (فراس)

| الفئة | نوع المركبة |
|----------|--------------|
| 1 | دراجة نارية / سكوتر |
| 2 | مركبة زراعية |
| 3 | سيارة خاصة (يدوية أو أوتوماتيكية) حتى 5 طن |
| 4 | سيارة / مركبة ركاب عامة تصل إلى 7.5 طن |
| 5 | حافلة / مركبة متوسطة تزيد عن 7.5 طن |
| 6 | تراكتور + مقطورة / باص ثقيل |
| 7 | مركبات للأشخاص ذوي الإعاقة |

## متطلبات العمر
- الفئات 1، 2، 3، 7: الحد الأدنى 18 سنة
- الفئة الرابعة: الحد الأدنى 21 سنة
- تتطلب الفئة 4 امتلاك الفئة 3 (يدوية) لمدة عام على الأقل.
- الفئات 5 أو 6: سنتين على الأقل بعد الحصول على الفئة السابقة

## المستندات المطلوبة للترخيص الجديد
1. استمارة الطلب الرسمية
2. ثلاث صور شخصية حديثة مقاس 6×4 سم.
3. البطاقة المدنية أو جواز السفر (بالرقم الوطني)
4. إثبات السن (شهادة الميلاد أو الهوية)
5. شهادة إتمام التدريب (عملي + نظري باستثناء الفئتين 1 و 2)

## التجديد والاستبدال
- التجديد يتطلب نفس المستندات بالإضافة إلى الرخصة المنتهية.
- استبدال المفقود أو التالف يتطلب تقديم نموذج خاص وصور وبطاقة هوية ورخصة تالف (إن وجدت).'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Medical and Theoretical Examination Process

## Step 1: Medical Examination
- Tests vision, limb health, and general conditions affecting driving.
- For one-eyed applicants: Healthy eye must have vision of at least 6/9.
- Certain medical conditions may disqualify you or require special approval.

## Step 2: Theoretical Examination
- Tests knowledge of traffic rules, priorities, etiquette, vehicle maintenance, first aid, and traffic signs.
- If you fail, you may retake after one week.

## Step 3: Practical Examination
- Scheduled within one week after passing theoretical test.
- Tests include:
  - Preparation, startup, moving off
  - Interaction with traffic
  - Obeying signs and road markings
  - Priority rules and intersections
  - Overtaking and meeting
  - Reversing (various types)
  - Turning
  - Gear use (manual/automatic)
  - Curves, normal and emergency stop
  - Control, attention, reaction

## If You Fail the Practical Test
- You receive a notice of errors.
- You must wait at least two weeks before retaking.
- You may practice at a training center in the meantime.

## If Your Driving Poses a Danger
- The examiner may stop the test immediately.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'#عملية الفحص الطبي والنظري

## الخطوة الأولى: الفحص الطبي
- اختبارات الرؤية وصحة الأطراف والحالات العامة المؤثرة على القيادة.
- للمتقدمين أعور: يجب أن تتمتع العين السليمة برؤية لا تقل عن 6/9.
- قد تؤدي بعض الحالات الطبية إلى استبعادك أو تتطلب موافقة خاصة.

## الخطوة الثانية: الفحص النظري
- اختبارات المعرفة بقواعد المرور والأولويات والآداب وصيانة المركبات والإسعافات الأولية وإشارات المرور.
- في حالة الفشل، يمكنك إعادة الاختبار بعد أسبوع واحد.

## الخطوة 3: الامتحان العملي
- يحدد موعده خلال أسبوع واحد بعد اجتياز الاختبار النظري.
- الاختبارات تشمل:
  - الإعداد، البدء، الانطلاق
  - التفاعل مع حركة المرور
  - الالتزام باللافتات وعلامات الطريق
  - قواعد الأولوية والتقاطعات
  - التجاوز والاجتماع
  - عكس (أنواع مختلفة)
  - تحول
  - استخدام الجير (يدوي/أوتوماتيكي)
  - المنحنيات والتوقف العادي والطارئ
  - السيطرة والانتباه ورد الفعل

##إذا فشلت في الاختبار العملي
- تتلقى إشعارا بالأخطاء.
- يجب الانتظار لمدة أسبوعين على الأقل قبل إعادة تناوله.
- يمكنك التدرب في أحد مراكز التدريب في هذه الأثناء.

## إذا كانت قيادتك تشكل خطرًا
- يجوز للفاحص إيقاف الاختبار فوراً.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Road Lines and Markings – Part 1 (Mandatory Lines)

Road markings are painted lines, buttons, or reflective markers on the road surface to guide, warn, or inform drivers.

## Materials Used
- Paint (ordinary, thermal, or strip – often reflective)
- Plastic or metal buttons (reflective for night visibility)

## Colors and Their Meaning
- **White lines**: Separate traffic going in the same direction or indicate mandatory markings.
- **Yellow lines**: Indicate road edges or separate opposing traffic.

## Mandatory Lines (Compulsory Markings)

### Solid Longitudinal Lines (Continuous)
- **Cannot be crossed** for overtaking or lane change.
- Used in:
  - Separating opposing traffic directions
  - No-overtaking zones
  - Approaches to obstacles or intersections
  - Road edges (yellow lines on major roads)

### Stop Line
- Thick solid white line across the road (30–50 cm wide).
- You must stop completely before this line.
- Often accompanied by a STOP sign or the word "STOP" on the road.

### Yield Line
- Broken line made of small triangles.
- You must give priority to traffic on the main road.
- If necessary, stop before this line.

## Obstacle Lines
- Painted hatched areas or slanted lines before an obstacle.
- Surrounded by solid mandatory lines – do not enter.

## Important Rule
If the solid line is on your side of the center, you **cannot** overtake.
If the broken line is on your side, you may overtake with caution.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# خطوط الطرق وعلاماتها – الجزء الأول (الخطوط الإلزامية)

علامات الطريق هي خطوط مرسومة أو أزرار أو علامات عاكسة على سطح الطريق لتوجيه السائقين أو تحذيرهم أو إعلامهم.

## المواد المستخدمة
- الطلاء (العادي، الحراري، أو الشريطي - غالبًا ما يكون عاكسًا)
- أزرار بلاستيكية أو معدنية (عاكسة للرؤية الليلية)

## الألوان ومعناها
- **الخطوط البيضاء**: حركة مرور منفصلة تسير في نفس الاتجاه أو تشير إلى علامات إلزامية.
- **الخطوط الصفراء**: تشير إلى حواف الطريق أو حركة المرور المقابلة المنفصلة.

## الخطوط الإلزامية (العلامات الإجبارية)

### الخطوط الطولية الصلبة (مستمرة)
- **لا يجوز التجاوز** للتجاوز أو تغيير المسار.
- يستخدم في:
  - فصل اتجاهات المرور المتعارضة
  - مناطق منع التجاوز
  - الاقتراب من العقبات أو التقاطعات
  - حواف الطريق (الخطوط الصفراء على الطرق الرئيسية)

### خط التوقف
- خط أبيض متين وسميك عبر الطريق (عرضه 30-50 سم).
- يجب عليك التوقف تماماً قبل هذا الخط.
- غالبًا ما تكون مصحوبة بعلامة STOP أو كلمة "STOP" على الطريق.

### خط العائد
- خط متقطع مكون من مثلثات صغيرة.
- يجب إعطاء الأولوية لحركة المرور على الطريق الرئيسي.
- إذا لزم الأمر، توقف قبل هذا الخط.

## خطوط العوائق
- رسم المناطق المظللة أو الخطوط المائلة قبل العائق.
- محاط بخطوط إلزامية متواصلة – لا تدخل.

## قاعدة مهمة
إذا كان الخط المتصل على جانبك من المركز، فلا يمكنك **التجاوز**.
إذا كان الخط المتقطع من جانبك، فيمكنك التجاوز بحذر.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Road Lines and Markings – Part 2 (Warning Lines and Symbols)

## Warning Lines (Broken Longitudinal Lines)

### On Two-Way Roads
- **Outside cities:** Broken line ratio = 3:1 (longer gaps)
- **Inside cities:** Broken line ratio = 1:1 (shorter gaps)
- Meaning: Overtaking is **allowed with extreme caution**, not prohibited.
- Yellow broken lines warn of road edges (mostly on secondary roads).

## Pedestrian Crosswalk Lines (Zebra Crossing)
- White parallel stripes across the road.
- Drivers must slow to 30 km/h and stop if pedestrians are crossing.
- Zigzag lines before the crossing warn drivers of the approaching crosswalk.

## Bicycle Lane Markings
- Two solid lines with a bicycle symbol painted between them.
- Cyclists have priority at intersections.

## Words and Numbers on the Road
- **STOP** – painted before stop line for emphasis.
- **BUS LANE** – reserved for public transport.
- **Speed numbers** – indicate maximum speed limit.

## Arrows (Mandatory Direction Markings)
- Show the required direction for each lane:
  - Straight
  - Right turn
  - Left turn
  - Straight + right
  - Straight + left

## Example
At an intersection, arrows on the road tell you which lane to choose for your intended direction. Using the wrong lane is a violation.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# خطوط وعلامات الطريق – الجزء الثاني (الخطوط والرموز التحذيرية)

## الخطوط التحذيرية (الخطوط الطولية المتكسرة)

### على الطرق ذات الاتجاهين
- **خارج المدن:** نسبة الخطوط المتقطعة = 3:1 (فجوات أطول)
- **داخل المدن:** نسبة الخطوط المتقطعة = 1:1 (فجوات أقصر)
- المعنى: التجاوز مسموح ** مع الحذر الشديد ** وليس ممنوعا.
- خطوط صفراء متقطعة تحذر من حواف الطريق (أغلبها على الطرق الثانوية).

## خطوط معبر المشاة (معبر الحمار الوحشي)
- خطوط بيضاء متوازية على طول الطريق.
- يجب على السائقين إبطاء السرعة إلى 30 كم/ساعة والتوقف في حالة عبور المشاة.
- الخطوط المتعرجة قبل المعبر تحذر السائقين من اقتراب الممر.

## علامات ممرات الدراجات
- خطان متصلان بينهما رمز الدراجة.
- لراكبي الدراجات الأولوية عند التقاطعات.

## الكلمات والأرقام على الطريق
- **STOP** – تم رسمه قبل خط التوقف للتأكيد.
- **خط الحافلات** – مخصص لوسائل النقل العام.
- **أرقام السرعة** - تشير إلى الحد الأقصى للسرعة.

## الأسهم (علامات الاتجاه الإلزامية)
- إظهار الاتجاه المطلوب لكل حارة:
  - مستقيم
  - انعطف يمينًا
  - انعطف يسارًا
  - مستقيم + يمين
  - مستقيم + يسار

## مثال
عند التقاطع، تخبرك الأسهم الموجودة على الطريق بالمسار الذي يجب عليك اختياره للاتجاه المقصود. استخدام المسار الخطأ يعد انتهاكًا.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Traffic Signs – Warning Signs (Part 1)

## General Shape and Colors
- **Shape:** Equilateral triangle (point up)
- **Base color:** White
- **Border:** Red
- **Symbol/writing:** Black

## Common Warning Signs

| Sign | Meaning |
|------|---------|
| Right curve | Reduce speed, no overtaking, limited visibility |
| Left curve | Same as right curve |
| Double curve (right then left) | Multiple curves ahead |
| Double curve (left then right) | Multiple curves ahead |
| Steep downhill | Adjust speed, use lower gears |
| Steep uphill | Adjust speed, keep right |
| Road narrows from both sides | Slow down, keep right, no overtaking |
| Road narrows from right | Slow down, keep right |
| Road narrows from left | Slow down, keep right |
| Bridge narrows | Slow down, no overtaking |
| Road ends at quay/river | Slow down, be ready to stop |
| Uneven road | Slow down, drive carefully |
| Speed bump | Slow down to cross safely |
| Dip | Slow down to cross safely |

## Work Zone Signs
- Men working on road ahead.
- Reduce speed, choose correct lane, give priority if required.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# إشارات المرور – العلامات التحذيرية (الجزء الأول)

## الشكل والألوان العامة
- **الشكل:** مثلث متساوي الأضلاع (نقطة للأعلى)
- **اللون الأساسي:** أبيض
- **الحدود:** أحمر
- **الرمز/الكتابة:** أسود

## علامات التحذير الشائعة

| التوقيع | معنى |
|------|---------|
| المنحنى الأيمن | تخفيف السرعة، عدم التجاوز، الرؤية المحدودة |
| المنحنى الأيسر | نفس المنحنى الأيمن |
| منحنى مزدوج (يمين ثم يسار) | منحنيات متعددة أمامنا |
| منحنى مزدوج (يسار ثم يمين) | منحنيات متعددة أمامنا |
| منحدر حاد | اضبط السرعة، استخدم تروسًا أقل |
| شاقة شديدة الانحدار | ضبط السرعة، والحفاظ على الحق |
| الطريق يضيق من الجانبين | تمهل، حافظ على الحق، لا تجاوز |
| الطريق يضيق من اليمين | تمهل، حافظ على حقك |
| الطريق يضيق من اليسار | تمهل، حافظ على حقك |
| جسر يضيق | تمهل، ممنوع التجاوز |
| ينتهي الطريق عند الرصيف/النهر | أبطئ السرعة، وكن مستعدًا للتوقف |
| طريق غير مستوي | تمهل، قم بالقيادة بحذر |
| مطب السرعة | تمهل لتعبر بسلام |
| تراجع | تمهل لتعبر بسلام |

## لافتات منطقة العمل
- رجال يعملون على الطريق أمامهم.
- خفف السرعة، اختر المسار الصحيح، أعط الأولوية إذا لزم الأمر.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Traffic Signs – Warning Signs (Part 2)

| Sign | Meaning |
|------|---------|
| Slippery road | Reduce speed, keep lane, no overtaking |
| Falling rocks (right) | Drive carefully, watch for rocks |
| Falling rocks (left) | Drive carefully |
| Loose stones | Reduce speed, increase following distance, no overtaking |
| Pedestrian crossing | Reduce to 30 km/h, stop if pedestrians are crossing |
| Two-way traffic | Keep right, be alert for oncoming vehicles |
| Divided highway begins | Keep right, follow lane |
| Divided highway ends | Keep right, be alert |
| Tunnel | Reduce to 50 km/h, keep lane, no overtaking, check vehicle height/width |
| Railway crossing with gate | Stop, give priority to trains |
| Railway crossing without gate | Reduce speed, be ready to stop, give priority to trains |
| Railway crossing distance marker | Shows distance to crossing (prepare to stop) |
| Roundabout ahead | Reduce speed, give priority to vehicles inside roundabout |
| Stop sign ahead | Prepare to stop completely |
| Yield sign ahead | Prepare to give priority |

These signs always require **reducing speed** and **increasing attention**.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# إشارات المرور – العلامات التحذيرية (الجزء الثاني)

| التوقيع | معنى |
|------|---------|
| طريق زلق | خفف السرعة، حافظ على المسار، ممنوع التجاوز |
| الصخور المتساقطة (يمين) | قد بحذر، وانتبه للصخور |
| الصخور المتساقطة (يسار) | القيادة بعناية |
| حجارة سائبة | تقليل السرعة، زيادة مسافة التتبع، عدم التجاوز |
| معبر مشاة | خفف السرعة إلى 30 كم/ساعة، وتوقف في حالة عبور المشاة |
| حركة المرور في اتجاهين | حافظ على اليمين، وكن متيقظًا للمركبات القادمة |
| يبدأ الطريق السريع المقسم | حافظ على اليمين، اتبع المسار |
| ينتهي الطريق السريع المقسم | إبقى على حق، كن يقظاً |
| النفق | قلل السرعة إلى 50 كم/ساعة، وحافظ على المسار، وعدم التجاوز، وتحقق من ارتفاع/عرض السيارة |
| معبر السكة الحديد مع بوابة | توقف، أعط الأولوية للقطارات |
| معبر السكة الحديد بدون بوابة | خفف السرعة، واستعد للتوقف، وأعطي الأولوية للقطارات |
| علامة مسافة عبور السكة الحديد | يظهر المسافة إلى العبور (الاستعداد للتوقف) |
| الدوار امام | خفف السرعة، وأعطي الأولوية للمركبات داخل الدوار |
| علامة التوقف للأمام | الاستعداد للتوقف تماما |
| علامة العائد قدما | الاستعداد لإعطاء الأولوية |

تتطلب هذه العلامات دائمًا **تقليل السرعة** و **زيادة الانتباه**.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Traffic Signs – Priority Signs

## Shape and Colors
- Part of regulatory signs (priority section)
- Shapes vary (triangle, octagon, rectangle)

## Yield (Give Way)
- Red-bordered inverted triangle.
- Reduce speed before intersection.
- Give priority to vehicles on the intersecting road.

## Stop
- Red octagon with white letters.
- Come to a **complete stop** before the stop line or before entering intersection.
- Do not proceed until safe and clear.
- Also required at railway crossings without gates.

## Main Road
- Yellow diamond with white border.
- You have priority over entering traffic.
- Remain cautious at intersections.

## End of Main Road
- Same shape but with black diagonal lines.
- Your priority ends.
- Reduce speed and give way as required by signs or general rules.

## Priority for Oncoming Traffic (Narrow Road)
- Red-bordered circle with two arrows (one red, one black).
- Red arrow means **they** have priority.
- You must stop and let oncoming vehicles pass when road is too narrow.

## Priority Over Oncoming Traffic
- Blue square with two arrows (white arrow pointing down, red arrow up).
- **You** have priority.
- Oncoming vehicles must stop for you.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# إشارات المرور – علامات الأولوية

## الشكل والألوان
- جزء من العلامات التنظيمية (قسم الأولوية)
- تختلف الأشكال (مثلث، مثمن، مستطيل)

## العائد (افساح المجال)
- مثلث مقلوب ذو حدود حمراء.
- تخفيف السرعة قبل التقاطع.
- إعطاء الأولوية للمركبات الموجودة على الطريق المتقاطع.

## توقف
- مثمن أحمر بأحرف بيضاء.
- توقف **توقفًا تامًا** قبل خط التوقف أو قبل الدخول إلى التقاطع.
- لا تتقدم حتى تصبح آمنًا وواضحًا.
- مطلوب أيضًا عند معابر السكك الحديدية بدون بوابات.

##الطريق الرئيسي
- ألماسة صفراء ذات حدود بيضاء.
- لديك الأولوية على دخول حركة المرور.
- التزام الحذر عند التقاطعات.

## نهاية الطريق الرئيسي
- نفس الشكل ولكن بخطوط قطرية سوداء.
- تنتهي أولويتك.
- تخفيف السرعة وإفساح المجال حسب ما تقتضيه الإشارات أو القواعد العامة.

## الأولوية لحركة المرور القادمة (الطريق الضيق)
- دائرة ذات حدود حمراء بها سهمان (أحدهما أحمر والآخر أسود).
- السهم الأحمر يعني **هم** لديهم الأولوية.
- يجب عليك التوقف والسماح للمركبات القادمة بالمرور عندما يكون الطريق ضيقًا جدًا.

## الأولوية على حركة المرور القادمة
- مربع أزرق به سهمان (سهم أبيض يشير إلى الأسفل، وسهم أحمر إلى الأعلى).
- **أنت** لديك الأولوية.
- يجب أن تتوقف المركبات القادمة لك.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Traffic Signs – Prohibition Signs

## Shape and Colors
- Shape: Round
- Base: White
- Border: Red
- Symbol: Black

## Common Prohibition Signs

| Sign | Meaning |
|------|---------|
| No entry both directions | Road closed to all vehicles (pedestrians only) |
| No entry | One-way street from opposite direction |
| No motor vehicles | No engine-powered vehicles allowed |
| No motorcycles | Motorcycles prohibited |
| No bicycles | Bicycles prohibited |
| No mopeds | Small motorized bikes prohibited |
| No trucks or goods vehicles | Trucks over a certain weight prohibited |
| No width over (number) | Vehicles wider than (e.g., 2.2 m) prohibited |
| No height over (number) | Vehicles taller than (e.g., 3.5 m) prohibited |
| No weight over (number) | Vehicles heavier than (e.g., 12 tons) prohibited |
| No axle weight over (number) | Heavy axles prohibited |
| No length over (number) | Long vehicles prohibited |
| No left turn | Left turn prohibited at that intersection |
| No right turn | Right turn prohibited |
| No U-turn | U-turn prohibited |
| No overtaking | Overtaking prohibited for all or for heavy vehicles |
| Speed limit (max) | Do not exceed shown speed |
| No horn | Horn prohibited (hospitals, schools, religious places) |
| No stopping | Stopping prohibited |
| No parking | Parking prohibited |
| Customs stop | Must stop at customs checkpoint |'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# إشارات المرور – علامات المنع

## الشكل والألوان
- الشكل: دائري
- القاعدة: أبيض
- الحدود: أحمر
- الرمز: أسود

## علامات الحظر المشتركة

| التوقيع | معنى |
|------|---------|
| ممنوع الدخول في الاتجاهين | الطريق مغلق أمام جميع المركبات (المشاة فقط) |
| ممنوع الدخول | شارع ذو اتجاه واحد من الاتجاه المعاكس |
| لا يوجد سيارات | غير مسموح بالمركبات التي تعمل بمحرك |
| لا دراجات نارية | الدراجات النارية محظورة |
| لا دراجات | الدراجات المحظورة |
| لا الدراجات النارية | الدراجات الآلية الصغيرة محظورة |
| لا توجد شاحنات أو مركبات بضائع | ممنوع الشاحنات التي يزيد وزنها عن حد معين |
| لا يوجد عرض فوق (الرقم) | المركبات الأعرض من (على سبيل المثال، 2.2 م) محظورة |
| لا يوجد ارتفاع فوق (الرقم) | المركبات التي يزيد طولها عن (3.5 م مثلاً) محظورة |
| لا وزن يزيد على (العدد) | المركبات الأثقل من (مثلا 12 طن) محظورة |
| لا يزيد وزن المحور عن (العدد) | المحاور الثقيلة محظورة |
| لا يوجد طول يزيد على (الرقم) | المركبات الطويلة محظورة |
| لا يوجد انعطاف لليسار | الانعطاف يسارًا محظور عند هذا التقاطع |
| لا يوجد انعطاف يمين | الانعطاف لليمين محظور |
| لا يوجد منعطف على شكل حرف U | ممنوع الدوران على شكل حرف U |
| ممنوع التجاوز | ممنوع التجاوز للجميع أو للمركبات الثقيلة |
| الحد الأقصى للسرعة (الحد الأقصى) | لا تتجاوز السرعة المبينة |
| لا قرن | القرن محظور (المستشفيات والمدارس والأماكن الدينية) |
| لا توقف | الوقف محظور |
| لا يوجد موقف سيارات | وقوف السيارات محظور |
| توقف الجمارك | يجب التوقف عند نقطة التفتيش الجمركي |'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Traffic Signs – Mandatory and Informational Signs

## Mandatory (Command) Signs
- Shape: Round or blue circle with white symbol.
- Meaning: You **must** do what the sign says.

Examples:
- **Straight ahead only**
- **Turn left only**
- **Turn right only**
- **Straight or left**
- **Straight or right**
- **Keep left**
- **Keep right**
- **Minimum speed limit** (blue circle with white number)

## Informational Signs
- Shape: Rectangle or square (various sizes)
- Base color: Blue
- Writing/symbols: White

### Types of Informational Signs

| Purpose | Example |
|---------|---------|
| Lane assignment | Multiple lanes with arrows for each destination |
| Advance direction | Intersection ahead at 1 km to Syrian/Iraqi borders |
| Route numbers | Primary route number (e.g., 25), secondary route (e.g., 122) |
| Motorway begins/ends | Freeway ahead or freeway ends |
| Additional lane | New lane joining from right |
| Lane reduction | Two lanes merge into one |
| Service signs | Petrol station, hospital, restaurant, hotel, rest area |
| Tourist attraction | Historical or cultural site |

## Informational Signs Help You
- Find your destination
- Choose correct lane in advance
- Locate services safely without distraction'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# العلامات المرورية – العلامات الإلزامية والإعلامية

## علامات (الأمر) الإلزامية
- الشكل: دائرة مستديرة أو زرقاء ورمزها أبيض.
- المعنى: **يجب عليك** أن تفعل ما تقوله العلامة.

أمثلة:
- **إلى الأمام مباشرة**
- ** انعطف يسارًا فقط **
- ** انعطف يمينًا فقط **
- **مستقيم أو يسار**
- **مستقيم أو يمين**
- **البقاء على اليسار**
- **الحفاظ على الحق**
- **الحد الأدنى للسرعة** (دائرة زرقاء برقم أبيض)

## لافتات إعلامية
- الشكل: مستطيل أو مربع (أحجام مختلفة)
- اللون الأساسي: أزرق
- الكتابة/الرموز: أبيض

### أنواع العلامات المعلوماتية

| الغرض | مثال |
|---------|--------|
| تخصيص حارة | مسارات متعددة مع أسهم لكل وجهة |
| الاتجاه المتقدم | التقاطع أمامك على مسافة كيلومتر واحد إلى الحدود السورية/العراقية |
| أرقام الطرق | رقم المسار الأساسي (على سبيل المثال، 25)، والمسار الثانوي (على سبيل المثال، 122) |
| يبدأ/ينتهي الطريق السريع | الطريق السريع أمامك أو ينتهي الطريق السريع |
| حارة إضافية | حارة جديدة تنضم من اليمين |
| تخفيض المسار | دمج مسارين في واحد |
| علامات الخدمة | محطة بنزين، مستشفى، مطعم، فندق، منطقة استراحة |
| جذب سياحي | موقع تاريخي أو ثقافي |

## لافتات إعلامية تساعدك
- ابحث عن وجهتك
- اختر المسار الصحيح مقدما
- تحديد موقع الخدمات بشكل آمن دون تشتيت الانتباه'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Right-of-Way Rules at Intersections

## General Approach
- Reduce speed when approaching any intersection.
- Choose correct lane well in advance.
- Signal your intention using turn signals.
- Do not enter intersection if already congested.

## Rule 1 – Right-Hand Rule (Equal priority roads)
- If roads are equal (no signs, no main road), the vehicle coming from your **right** has priority.
- You must yield to that vehicle.

## Rule 2 – Opposite Direction (Left-turn priority)
- If you face an oncoming vehicle and you both want to turn left, or one goes straight:
  - The vehicle going straight or turning right has priority over a vehicle turning left.
  - Oncoming left-turning vehicle must wait.

## Rule 3 – Main Road vs. Secondary Road
- Vehicles on the main road have priority.
- Vehicles entering from a secondary road must yield.

## Rule 4 – Roundabout
- Vehicles **inside** the roundabout have priority.
- Vehicles entering must wait for a safe gap.

## Rule 5 – Railway Crossing
- Trains always have priority.

## Rule 6 – T-Junction
- The road that continues straight has priority over the road that ends.
- Vehicles entering from the ending road must yield.

## Rule 7 – Emergency and Official Vehicles
- Police, ambulance, civil defense, and official convoys using lights/sirens have priority.
- Pull right and stop if necessary.

## Rule 8 – Exiting Private Property
- Vehicles exiting private areas (garages, fuel stations, farms) must stop and check for traffic before entering the road.

## Rule 9 – Organized Processions
- Pedestrian groups (students, scouts, military, funeral, organized marches) have priority.

## Golden Rule
**Priority is given, not taken.**'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# قواعد حق الطريق عند التقاطعات

## النهج العام
- تخفيف السرعة عند الاقتراب من أي تقاطع.
- اختر المسار الصحيح مسبقًا.
- قم بالإشارة إلى نيتك باستخدام إشارات الانعطاف.
- لا تدخل التقاطع إذا كان مزدحمًا بالفعل.

## القاعدة 1 – قاعدة اليد اليمنى (الطرق ذات الأولوية المتساوية)
- إذا كانت الطرق متساوية (لا توجد إشارات، لا يوجد طريق رئيسي)، فالمركبة القادمة من **يمينك** هي الأولوية.
- يجب أن تستسلم لتلك السيارة.

## القاعدة 2 – الاتجاه المعاكس (أولوية الانعطاف إلى اليسار)
- إذا كنت تواجه مركبة قادمة في الاتجاه المعاكس وترغبان في الانعطاف إلى اليسار، أو أن تسير إحداهما بشكل مستقيم:
  - للمركبة التي تسير بشكل مستقيم أو تنعطف يميناً الأولوية على السيارة التي تنعطف يساراً.
  - يجب على السيارة القادمة التي تنعطف إلى اليسار الانتظار.

## القاعدة 3 – الطريق الرئيسي مقابل الطريق الثانوي
- المركبات على الطريق الرئيسي لها الأولوية.
- يجب على المركبات التي تدخل من طريق فرعي أن تلتزم بقواعد المرور.

## القاعدة 4 – الدوار
- المركبات **داخل** الدوار لها الأولوية.
- يجب على المركبات الداخلة الانتظار حتى تصل إلى فجوة آمنة.

## القاعدة 5 – عبور السكك الحديدية
- القطارات لها الأولوية دائمًا.

## القاعدة 6 – تقاطع T
- الطريق الذي يستمر بشكل مستقيم له الأولوية على الطريق الذي ينتهي.
- يجب على المركبات التي تدخل من الطريق المنتهي أن تلتزم بالخضوع.

## القاعدة 7 – مركبات الطوارئ والمركبات الرسمية
- الشرطة والإسعاف والدفاع المدني والمواكب الرسمية التي تستخدم الأضواء وصفارات الإنذار لها الأولوية.
- اسحب لليمين وتوقف إذا لزم الأمر.

## القاعدة 8 – الخروج من الملكية الخاصة
- يجب على المركبات الخارجة من المناطق الخاصة (الكراجات، محطات الوقود، المزارع) التوقف والتحقق من حركة المرور قبل الدخول إلى الطريق.

## القاعدة 9 – المواكب المنظمة
- مجموعات المشاة (الطلبة، الكشافة، العسكريين، الجنائز، المسيرات المنظمة) لها الأولوية.

## القاعدة الذهبية
**الأولوية تعطى ولا تؤخذ**'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Lane Discipline and Turning Rules

## Keep Right Rule
- Always keep to the right side of the road.
- On multi-lane roads, slower vehicles use the rightmost lane.
- Move right when:
  - You want to turn right.
  - You are allowing vehicles behind to overtake.
  - Approaching curves or hill crests.

## Turning Right
- Must be in the rightmost lane.
- Check right mirror and blind spot.
- Signal right well in advance.

## Turning Left
- On two-way roads with one lane each direction: Move to right side, then turn left only when safe.
- On divided roads or multiple lanes: Use the leftmost lane for left turn.
- On one-way streets: Turn left from the leftmost lane.

## U-Turn (Turning to opposite direction)
- Prohibited if:
  - There is a No U-turn sign.
  - The road is one-way.
  - It blocks traffic or creates danger.
  - Near curves, hills, or railroad crossings.
- You lose right-of-way when making a U-turn.

## Roundabout Lane Selection
- **Right turn:** Enter from right lane, exit from right lane.
- **Straight ahead:** Any appropriate lane, stay in lane through roundabout.
- **Left turn:** Enter from left lane, stay in left lane until exit.

## Lane Changing
- Signal before changing lanes.
- Check mirrors and blind spot.
- Do not change lanes suddenly.
- Do not cross solid lines.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# انضباط المسار وقواعد الانعطاف

## حافظ على القاعدة الصحيحة
- التزم دائمًا بالجانب الأيمن من الطريق.
- في الطرق متعددة المسارات، تستخدم المركبات الأبطأ المسار الموجود في أقصى اليمين.
- تحرك لليمين عندما:
  - تريد أن تستدير لليمين.
  - أنت تسمح للمركبات التي خلفك بالتجاوز.
  - الاقتراب من المنحنيات أو قمم التلال.

## الانعطاف إلى اليمين
- يجب أن تكون في أقصى المسار الأيمن.
- التحقق من المرآة اليمنى والنقطة العمياء.
- قم بالإشارة إلى اليمين مسبقًا.

## اتجه نحو اليسار
- على الطرق ذات الاتجاهين بحارة واحدة في كل اتجاه: انتقل إلى الجانب الأيمن، ثم انعطف يسارًا فقط عندما يكون ذلك آمنًا.
- على الطرق المقسمة أو الممرات المتعددة: استخدم المسار الموجود في أقصى اليسار للانعطاف إلى اليسار.
- في الشوارع ذات الاتجاه الواحد: انعطف يسارًا من أقصى اليسار.

## المنعطف على شكل حرف U (الاستدارة في الاتجاه المعاكس)
- محظور إذا:
  - توجد إشارة ممنوع الدوران.
  - الطريق ذو اتجاه واحد.
  - يمنع حركة المرور أو يخلق خطرا.
  - بالقرب من المنحنيات أو التلال أو معابر السكك الحديدية.
- تفقد حق الأولوية عند القيام بالانعطاف على شكل حرف U.

## اختيار حارة الدوار
- **الانعطاف لليمين:** الدخول من المسار الأيمن، والخروج من المسار الأيمن.
- **للأمام مباشرة:** في أي حارة مناسبة، ابقَ في الحارة التي تمر عبر الدوار.
- **الانعطاف يسارًا:** ادخل من المسار الأيسر، وابق في المسار الأيسر حتى الخروج.

## تغيير المسار
- الإشارة قبل تغيير المسار.
- فحص المرايا والنقطة العمياء.
- لا تغير المسار فجأة.
- عدم تجاوز الخطوط الصلبة.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Overtaking Rules and Prohibitions

## General
Overtaking is passing a moving or stationary obstacle on the road.

## Where to Overtake
- Always overtake on the **left side** of the vehicle ahead.
- Exceptions:
  - The vehicle ahead signals to turn left.
  - Multi-lane roads where changing lanes is safe and signaled.

## Safe Overtaking Procedure
1. Check road is clear ahead for enough distance.
2. Check interior mirror, side mirror, and blind spot.
3. Signal your intention (light or hand signal).
4. Maintain a safe side distance from the vehicle being overtaken.
5. Complete overtaking quickly but safely.
6. Signal right before returning to your lane.
7. Do not cut back suddenly; wait until you see the overtaken vehicle in your interior mirror.

## Prohibited Overtaking Situations
- Curves and hill crests (limited visibility)
- Slippery roads
- Near pedestrian crosswalks
- Near intersections or railroad crossings
- On bridges or in tunnels
- Where signs or solid lines prohibit overtaking
- When a line of vehicles is stopped (traffic jam or signal)
- When the vehicle ahead is already overtaking
- When a vehicle behind has already started overtaking
- When traffic does not allow safe completion
- When the vehicle ahead signals not to overtake
- Near stopped buses or passenger vehicles loading/unloading (passengers may cross)
- Low visibility (fog, dust, heavy rain)

## Responsibilities of the Driver Being Overtaken
- Keep as far right as possible.
- Do not increase speed.
- Reduce speed if needed to allow safe overtaking.

## Heavy Vehicles
- If you drive a heavy/slow vehicle and cannot be overtaken safely, pull over to let others pass.

## Side Winds Effect
- Strong natural wind or wind from other large vehicles can push small cars.
- Keep both hands on the steering wheel and maintain direction.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'#قواعد ومحظورات التجاوز

## عام
التجاوز هو تجاوز عائق متحرك أو ثابت على الطريق.

## أين يمكن التجاوز
- قم دائمًا بالتجاوز من **الجانب الأيسر** من السيارة التي أمامك.
- الاستثناءات:
  - السيارة التي أمامك تعطي إشارة للانعطاف يسارا.
  - طرق متعددة المسارات حيث يكون تغيير المسارات آمنًا وبإشارات.

## إجراءات التجاوز الآمنة
1. تأكد من خلو الطريق أمامك لمسافة كافية.
2. فحص المرآة الداخلية، والمرآة الجانبية، والنقطة العمياء.
3. قم بالإشارة إلى نيتك (إشارة ضوئية أو يدوية).
4. الحفاظ على مسافة جانبية آمنة من المركبة التي يتم تجاوزها.
5. أكمل التجاوز بسرعة ولكن بأمان.
6. قم بالإشارة إلى اليمين قبل العودة إلى مسارك.
7. لا تقطع فجأة. انتظر حتى ترى السيارة التي تم تجاوزها في مرآتك الداخلية.

## حالات التجاوز المحظورة
- المنحنيات وقمم التلال (رؤية محدودة)
- الطرق الزلقة
- بالقرب من ممرات المشاة
- بالقرب من التقاطعات أو معابر السكك الحديدية
- على الجسور أو في الأنفاق
- في حالة وجود علامات أو خطوط متصلة تمنع التجاوز
- عند توقف خط من المركبات (ازدحام المرور أو الإشارة)
- عندما تكون السيارة التي أمامك قد تجاوزت بالفعل
- عندما تكون السيارة التي خلفك قد بدأت بالفعل في التجاوز
- عندما لا تسمح حركة المرور بالإكمال الآمن
- عندما تعطي السيارة التي أمامك إشارة بعدم التجاوز
- بالقرب من الحافلات المتوقفة أو مركبات التحميل والتفريغ (يمكن للركاب العبور)
- تدني مدى الرؤية الأفقية (ضباب، غبار، أمطار غزيرة)

## مسؤوليات السائق الذي يتم تجاوزه
- حافظ على أقصى اليمين قدر الإمكان.
- لا تزيد السرعة.
- خفض السرعة إذا لزم الأمر للسماح بالتجاوز الآمن.

## المركبات الثقيلة
- إذا كنت تقود مركبة ثقيلة/بطيئة ولا يمكن تجاوزها بأمان، توقف للسماح للآخرين بالمرور.

## تأثير الرياح الجانبية
- الرياح الطبيعية القوية أو الرياح القادمة من المركبات الكبيرة الأخرى يمكن أن تدفع السيارات الصغيرة.
- ضع كلتا يديك على عجلة القيادة وحافظ على الاتجاه.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Speed Limits in Jordan

## General Speed Limit Rules
- Do not exceed the maximum posted speed.
- Do not drive below the minimum speed if posted.
- Speed must always be appropriate for conditions: weather, traffic, road surface, vehicle load, visibility.

## When to Reduce Speed
- Residential areas
- Poor visibility (fog, rain, night)
- Near schools or pedestrian crosswalks
- Curves, hills, intersections
- Areas with animals crossing

## Urban Roads (Inside City/Town Limits)

### Multi-lane divided roads (two or more lanes each direction with median)
- Private cars and light trucks (≤ 2 tons): 90 km/h
- Medium passenger vehicles: 80 km/h
- Buses: 80 km/h
- Heavy trucks (> 2 tons): 80 km/h

### Two-way undivided roads
- All categories: 70 km/h

### Near schools and local roads
- All vehicles: 40 km/h

## Rural Roads (Outside City/Town Limits)

### Multi-lane divided highways
- Private cars and light trucks (≤ 2 tons): 110 km/h
- Medium passenger vehicles: 100 km/h
- Buses: 100 km/h
- Heavy trucks (> 2 tons): 100 km/h

### Two-way undivided roads
- Private cars and light trucks (≤ 2 tons): 110 km/h
- Others: 100 km/h

### Secondary and agricultural roads
- Lower limits as posted

## Minimum Speed
- Not specified as a number in this manual, but driving unreasonably slow without cause is a violation.

## Exceeding Speed Limits – Penalties (Summary)
- Exceeding by more than 50 km/h: Jail (2 weeks–3 months) or fine (100 JD), plus license impound.
- Exceeding by 31–50 km/h: Fine 30 JD
- Exceeding by 11–30 km/h: Fine 20 JD'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'#حدود السرعة في الأردن

## قواعد الحد الأقصى للسرعة العامة
- لا تتجاوز السرعة القصوى المعلنة.
- لا تقود السيارة بأقل من الحد الأدنى للسرعة إذا تم نشرها.
- يجب أن تكون السرعة مناسبة دائمًا للظروف: الطقس، وحركة المرور، وسطح الطريق، وحمولة السيارة، والرؤية.

## متى يجب تقليل السرعة
- المناطق السكنية
- ضعف الرؤية (ضباب، أمطار، ليل)
- بالقرب من المدارس أو ممرات المشاة
- المنحنيات والتلال والتقاطعات
- مناطق عبور الحيوانات

## الطرق الحضرية (داخل حدود المدينة/البلدة)

### طرق مقسمة متعددة المسارات (مساران أو أكثر في كل اتجاه مع متوسط)
- السيارات الخاصة والشاحنات الخفيفة (≥ 2 طن): 90 كم/ساعة
- سيارات الركاب المتوسطة: 80 كم/ساعة
- الحافلات: 80 كم/ساعة
- الشاحنات الثقيلة (> 2 طن): 80 كم/ساعة

### طرق غير مقسمة ذات اتجاهين
- جميع الفئات: 70 كم/ساعة

### بالقرب من المدارس والطرق المحلية
- جميع المركبات: 40 كم/ساعة

## الطرق الريفية (خارج حدود المدينة/البلدة)

### طرق سريعة مقسمة ومتعددة الحارات
- السيارات الخاصة والشاحنات الخفيفة (≥ 2 طن): 110 كم/ساعة
- سيارات الركاب المتوسطة: 100 كم/ساعة
- الحافلات: 100 كم/ساعة
- الشاحنات الثقيلة (> 2 طن): 100 كم/ساعة

### طرق غير مقسمة ذات اتجاهين
- السيارات الخاصة والشاحنات الخفيفة (≥ 2 طن): 110 كم/ساعة
- أخرى: 100 كم/ساعة

### الطرق الثانوية والزراعية
- الحدود الدنيا كما نشرت

## الحد الأدنى للسرعة
- لم يتم تحديده كرقم في هذا الدليل، لكن القيادة ببطء غير معقول دون سبب تعتبر انتهاكًا.

## تجاوز حدود السرعة – العقوبات (ملخص)
- تجاوز السرعة أكثر من 50 كم/ساعة: الحبس (من أسبوعين إلى 3 أشهر) أو الغرامة (100 دينار) وحجز الرخصة.
- تجاوز السرعة من 31 إلى 50 كم/ساعة غرامة 30 دينار
- التجاوز بسرعة 11-30 كم/ساعة: غرامة 20 دينار'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Stopping, Parking, and Emergency Stoppage

## Definitions
- **Stopping (Tawaqquf):** Temporarily stopping for traffic reasons, boarding/alighting, or loading/unloading.
- **Parking (Wuquf):** Leaving vehicle for any non-temporary reason.

## Where Parking and Stopping Are Prohibited
- On pedestrian crosswalks or sidewalks
- On bicycle lanes
- On railway tracks or too close to them
- On bridges, tunnels, or overpasses (unless designated)
- Within 15 meters of an intersection, curve, or hill crest
- Double parking (parallel next to another parked car)
- Within 10 meters before or after a pedestrian crossing
- In a roundabout
- On driveways of public/private parking entrances

## Parallel Parking Procedure
1. Stop beside the front vehicle, about 0.5 meters away.
2. Turn steering wheel fully right.
3. Reverse toward the rear vehicle until your front passes the rear of the front vehicle.
4. Turn steering wheel fully left and continue reversing until close to rear vehicle.
5. Turn steering wheel fully right toward curb to center between both vehicles.

## Emergency Stoppage
- If your vehicle breaks down, remove it from the road as soon as possible.
- Use hazard lights (four-way flashers).
- Place reflective triangle at least 100 meters before the vehicle on rural roads, 50 meters on urban roads.
- At night or low visibility, keep parking lights on.
- Do not stand between your vehicle and oncoming traffic.
- If disabled and cannot apply steps, stay inside, use hazard lights, and call for help.

## Reflective Triangle Specifications
- Equilateral triangle
- Minimum side length 45 cm
- Reflective material surface

## Vehicles Prohibited from Overnight Stay Inside Residential Areas
- Vehicles over 7.5 tons gross weight (trucks, heavy buses)
- Agricultural and construction vehicles on main streets'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# التوقف والوقوف والتوقف في حالات الطوارئ

## التعاريف
- **التوقف:** التوقف مؤقتاً لأسباب مرورية، أو الصعود والنزول، أو التحميل والتفريغ.
- **الوقوف:** ترك المركبة لأي سبب غير مؤقت.

## الأماكن التي يُحظر فيها وقوف السيارات والتوقف
- على ممرات المشاة أو الأرصفة
- على ممرات الدراجات
- على خطوط السكك الحديدية أو قريبة جداً منها
- على الجسور والأنفاق والجسور (ما لم تكن مخصصة لذلك)
- ضمن مسافة 15 مترًا من التقاطع أو المنحنى أو قمة التل
- مواقف مزدوجة (موازية بجوار سيارة أخرى متوقفة)
- ضمن مسافة 10 أمتار قبل أو بعد معبر المشاة
- في الدوار
- على مداخل مداخل المواقف العامة والخاصة

## إجراءات وقوف السيارات الموازية
1. توقف بجانب المركبة الأمامية على بعد حوالي 0.5 متر.
2. أدر عجلة القيادة إلى اليمين بالكامل.
3. قم بالرجوع نحو السيارة الخلفية حتى تتجاوز سيارتك الجزء الخلفي من السيارة الأمامية.
4. أدر عجلة القيادة إلى اليسار بالكامل واستمر في الرجوع للخلف حتى تقترب من السيارة الخلفية.
5. أدر عجلة القيادة بالكامل نحو اليمين باتجاه الرصيف إلى المنتصف بين المركبتين.

## توقف طارئ
- إذا تعطلت سيارتك، قم بإزالتها من الطريق في أسرع وقت ممكن.
- استخدم أضواء الخطر (الفلاشات الرباعية).
- وضع المثلث العاكس قبل المركبة بمسافة لا تقل عن 100 متر على الطرق الريفية، و50 متراً على الطرق الحضرية.
- في الليل أو عندما تكون الرؤية منخفضة، قم بإبقاء أضواء وقوف السيارات مضاءة.
- لا تقف بين سيارتك وحركة المرور القادمة.
- إذا كنت معطلاً ولا تستطيع تطبيق الخطوات، فابق بالداخل واستخدم أضواء الخطر واطلب المساعدة.

## مواصفات المثلث العاكس
- مثلث متساوي الأضلاع
- الحد الأدنى لطول الجانب 45 سم
- سطح مادة عاكسة

## المركبات المحظورة المبيت داخل المناطق السكنية
- المركبات التي يزيد وزنها الإجمالي عن 7.5 طن (الشاحنات والحافلات الثقيلة)
- مركبات زراعية وإنشائية على الشوارع الرئيسية'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Alcohol, Drugs, and Medications

## Alcohol and Driving
- Driving under the influence of alcohol is a serious crime.
- Alcohol reduces reaction time, judgment, coordination, and vision.
- If caught driving while impaired, penalties can include imprisonment, heavy fines, and license suspension.

## Drugs and Narcotics
- Any non-alcoholic narcotic substance also impairs driving.
- Effects include:
  - Increased risk-taking
  - Reduced awareness
  - Poor decision-making
  - Slower reflexes
- Driving under the influence of drugs is strictly prohibited.

## Medications That Affect Driving
Many over-the-counter and prescription medications can affect your ability to drive safely. These include:
- Some painkillers
- Certain blood pressure medications
- Antihistamines (allergy medicines)
- Anti-nausea drugs
- Sedatives, sleeping pills, anxiety medications
- Some weight-loss pills
- Cold and flu medications
- Cough syrups

## What to Do
- Read warning labels on all medications.
- If the label says "do not operate heavy machinery" or "may cause drowsiness" – **do not drive**.
- Consult your doctor or pharmacist before driving while on medication.

## Legal Note
- The law considers any driver found with alcohol in their system while driving as a serious violator.
- Refusing a breathalyzer or blood test may lead to arrest.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'#الكحول والمخدرات والأدوية

## الكحول والقيادة
- القيادة تحت تأثير الكحول جريمة خطيرة.
- الكحول يقلل من وقت رد الفعل، والحكم، والتنسيق، والرؤية.
- إذا تم القبض عليك أثناء القيادة أثناء القيادة، فقد تشمل العقوبات السجن والغرامات الباهظة وتعليق الترخيص.

## المخدرات والمخدرات
- أي مادة مخدرة غير كحولية تعيق القيادة أيضاً.
- التأثيرات تشمل:
  - زيادة المخاطرة
  - انخفاض الوعي
  - سوء اتخاذ القرار
  - ردود أفعال أبطأ
- القيادة تحت تأثير المخدرات ممنوعة منعا باتا.

## الأدوية التي تؤثر على القيادة
يمكن أن تؤثر العديد من الأدوية التي تصرف بدون وصفة طبية على قدرتك على القيادة بأمان. وتشمل هذه:
- بعض المسكنات
- بعض أدوية ضغط الدم
- مضادات الهيستامين (أدوية الحساسية)
- الأدوية المضادة للغثيان
- المهدئات، الحبوب المنومة، أدوية القلق
- بعض حبوب إنقاص الوزن
- أدوية البرد والأنفلونزا
– شراب السعال

## ماذا تفعل
- قراءة الملصقات التحذيرية على جميع الأدوية.
- إذا كانت الملصق مكتوبًا عليه "لا تقم بتشغيل الآلات الثقيلة" أو "قد يسبب النعاس" - **لا تقد السيارة**.
- استشر طبيبك أو الصيدلي قبل القيادة أثناء تناول الدواء.

## ملاحظة قانونية
- يعتبر القانون أي سائق يتم العثور عليه وفي نظامه الكحول أثناء القيادة مخالفًا خطيرًا.
- رفض اختبار الكحول أو فحص الدم قد يؤدي إلى الاعتقال.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Driver Fatigue and Concentration

## Why Fatigue Is Dangerous
- Fatigue reduces reaction time similar to alcohol.
- You may micro-sleep without realizing it.
- Accident risk increases significantly at night and on long trips.

## Signs of Fatigue
- Yawning frequently
- Heavy eyelids or blinking more than usual
- Difficulty keeping head up
- Drifting out of your lane
- Missing traffic signs or exits
- Not remembering the last few kilometers driven

## How to Prevent Fatigue
- Get enough sleep before long drives (7–8 hours recommended).
- Take a break every 2 hours or 150–200 km.
- Stop at a safe rest area, not on the shoulder.
- If very tired, take a short nap (15–20 minutes) before driving again.

## Concentration and Distractions

### Avoid These While Driving
- Using a mobile phone without hands-free (illegal).
- Eating or drinking while driving.
- Adjusting radio, GPS, or AC while in complex traffic.
- Talking loudly or arguing with passengers.
- Picking up dropped items.
- Applying makeup or grooming.

### Safe Practice
- Set up music, GPS, and mirrors before moving.
- Ask passengers to keep noise reasonable.
- Secure loose objects (bags, phones, sunglasses) so they don’t roll.

## Nighttime Concentration
- Vision is reduced by 50–70% at night.
- Glare from oncoming high beams is dangerous.
- If someone high-beams you, slow down, look right, and keep right.

## Driving Under High Sun/Heat
- Heat can cause headache, nausea, anxiety, fatigue.
- Use sunglasses and sunshades.
- Monitor engine temperature and AC.
- Reduce speed and increase following distance.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# تعب السائق والتركيز

## لماذا يعتبر الإرهاق خطيرًا؟
- التعب يقلل من زمن رد الفعل المماثل للكحول.
- قد تنام بشكل جزئي دون أن تدرك ذلك.
- تزداد مخاطر الحوادث بشكل كبير في الليل وفي الرحلات الطويلة.

##علامات التعب
- التثاؤب بشكل متكرر
- ثقل الجفون أو الرمش أكثر من المعتاد
- صعوبة في رفع الرأس
- الانجراف خارج المسار الخاص بك
- عدم وجود إشارات مرورية أو مخارج
- عدم تذكر الكيلومترات القليلة الماضية التي قطعتها

## كيفية منع التعب
- احصل على قسط كافٍ من النوم قبل القيادة لمسافات طويلة (يوصى بـ 7-8 ساعات).
- خذ قسطاً من الراحة كل ساعتين أو 150-200 كم.
- التوقف عند منطقة استراحة آمنة، وليس على الكتف.
- إذا كنت متعبًا جدًا، خذ قيلولة قصيرة (15-20 دقيقة) قبل القيادة مرة أخرى.

## التركيز والتشتت

### تجنب هذه الأشياء أثناء القيادة
- استخدام الهاتف المحمول دون استخدام اليدين (غير قانوني).
- الأكل أو الشرب أثناء القيادة.
- ضبط الراديو أو نظام تحديد المواقع العالمي (GPS) أو التيار المتردد أثناء وجود حركة المرور المعقدة.
- التحدث بصوت عالٍ أو الجدال مع الركاب.
- التقاط العناصر المسقطة.
- وضع المكياج أو الحلاقة.

### الممارسة الآمنة
- قم بإعداد الموسيقى ونظام تحديد المواقع والمرايا قبل التحرك.
- اطلب من الركاب إبقاء الضوضاء معقولة.
- قم بتأمين الأشياء السائبة (الحقائب، الهواتف، النظارات الشمسية) حتى لا تتدحرج.

## التركيز الليلي
- تقل الرؤية ليلاً بنسبة 50-70%.
- يعد الوهج الناتج عن الأضواء العالية القادمة أمرًا خطيرًا.
- إذا أضاءك شخص ما بإضاءة عالية، أبطئ السرعة، وانظر إلى اليمين، وحافظ على اليمين.

## القيادة تحت أشعة الشمس/الحرارة العالية
- الحرارة يمكن أن تسبب الصداع والغثيان والقلق والتعب.
- استخدام النظارات الشمسية والمظلات.
- مراقبة درجة حرارة المحرك وتكييف الهواء.
- تقليل السرعة وزيادة مسافة التتبع.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Difficult Driving Conditions

## Night Driving
- Accident rate doubles at night, increases 6x if speed over 110 km/h.
- Ensure all lights work.
- Keep windows and mirrors clean.
- Use low beams inside cities, high beams on rural roads – but **dim high beams** when:
  - A vehicle is close ahead.
  - A vehicle approaches from opposite direction.
- If someone high-beams you, slow down and move right.

## Fog
- Use low beam headlights (high beams reflect back and worsen visibility).
- Fog lights are permitted only in fog or low visibility.
- Reduce speed significantly.
- Increase following distance.
- If visibility is extremely poor, pull off the road in a safe place, use hazard lights.

## Rain and Wet Roads
- Stopping distance increases (ice/water reduces grip).
- Use low beams, not high beams (reflection).
- Reduce speed, avoid sudden braking or sharp turns.
- Use windshield wipers.

## Snow and Ice
- Reduce speed to minimum safe level.
- Avoid sudden acceleration, braking, or steering.
- Use lower gears.
- Especially careful on curves and shaded areas where ice remains.

## Strong Wind and Sandstorms
- Strong wind can push your vehicle sideways.
- Sand reduces visibility and road grip.
- Keep both hands on wheel.
- Close all windows.
- Use low beam or fog lights (daytime). Use low beams after sunset.
- If needed, pull over safely and wait for improvement.

## Skidding (Loss of Traction)
### Rear-wheel skid (oversteer):
- Lift foot from accelerator.
- Steer in the direction the rear is sliding.

### Front-wheel skid (understeer):
- Lift foot from accelerator.
- Shift to neutral.
- Steer toward the direction of skid.

### Four-wheel skid:
- Lift accelerator.
- Shift to neutral.
- Release brakes to allow wheels to rotate.
- Pump brakes gently (do not lock wheels).
- Steer desired direction.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# ظروف القيادة الصعبة

## القيادة الليلية
- يتضاعف معدل الحوادث ليلاً، ويزيد 6 مرات إذا كانت السرعة أكثر من 110 كم/ساعة.
- التأكد من عمل جميع الأضواء.
- حافظ على نظافة النوافذ والمرايا.
- استخدم الأضواء المنخفضة داخل المدن، والإضاءة العالية على الطرق الريفية - ولكن **الإضاءة العالية الخافتة** عندما:
  - هناك سيارة قريبة أمامك.
  - اقتراب مركبة من الاتجاه المعاكس.
- إذا أضاءك شخص ما بالضوء العالي، أبطئ السرعة وتحرك إلى اليمين.

##ضباب
- استخدم المصابيح الأمامية ذات الضوء المنخفض (الضوء العالي يعكس الخلف ويؤدي إلى سوء الرؤية).
- يسمح باستخدام مصابيح الضباب فقط في حالة الضباب أو انخفاض الرؤية.
- خفض السرعة بشكل ملحوظ.
- زيادة المسافة التالية.
- إذا كانت الرؤية سيئة للغاية، ابتعد عن الطريق في مكان آمن، واستخدم أضواء الخطر.

## المطر والطرق الرطبة
- تزيد مسافة التوقف (الثلج/الماء يقلل من القبضة).
- استخدم الضوء المنخفض وليس الضوء العالي (الانعكاس).
- خفض السرعة، وتجنب الفرملة المفاجئة أو المنعطفات الحادة.
- استخدام ماسحات الزجاج الأمامي.

## الثلج والجليد
- خفض السرعة إلى الحد الأدنى الآمن.
- تجنب التسارع المفاجئ أو الفرملة أو التوجيه.
- استخدم التروس المنخفضة.
- الحذر بشكل خاص على المنحنيات والمناطق المظللة حيث يبقى الجليد.

## الرياح القوية والعواصف الرملية
- يمكن للرياح القوية أن تدفع سيارتك إلى الجانب.
- الرمال تقلل من الرؤية وتماسك الطريق.
- إبقاء كلتا اليدين على عجلة القيادة.
- إغلاق جميع النوافذ.
- استخدم الضوء المنخفض أو مصابيح الضباب (نهارًا). استخدم عوارض منخفضة بعد غروب الشمس.
- إذا لزم الأمر، قم بالتوقف بأمان وانتظر التحسن.

## الانزلاق (فقدان الجر)
### انزلاق العجلات الخلفية (الإفراط في التوجيه):
- رفع القدم عن دواسة الوقود.
- قم بالتوجيه في الاتجاه الذي ينزلق فيه الجزء الخلفي.

### انزلاق العجلات الأمامية (انخفاض التوجيه):
- رفع القدم عن دواسة الوقود.
- التحول إلى الحياد.
- توجيه نحو اتجاه الانزلاق.

### انزلاق على العجلات الأربع:
- رفع المسرع.
- التحول إلى الحياد.
- حرر الفرامل للسماح للعجلات بالدوران.
- ضخ الفرامل برفق (لا تقفل العجلات).
- توجيه الاتجاه المطلوب.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Vehicle Safety Equipment – Seatbelts, Airbags, Headrests

## Seatbelt Rules
- Seatbelts are mandatory for the driver and all front-seat passengers.
- Using a seatbelt:
  - Keeps you in your seat when the vehicle stops suddenly.
  - Prevents you from hitting the steering wheel, dashboard, or windshield.
  - Prevents passengers from colliding with each other.
  - Helps the driver maintain control after an impact or during sudden maneuvers.

## How Seatbelts Work
- A properly worn seatbelt spreads crash forces over stronger parts of your body (chest, pelvis).
- It stops you from being ejected from the vehicle.
- Always wear it low across the hips and snug across the chest.

## Airbags
- Airbags supplement seatbelts – they do not replace them.
- They inflate in moderate to severe frontal crashes.
- Keep at least 25 cm (10 inches) between your chest and the steering wheel.
- Do not place rear-facing child seats in front of an active airbag.

## Headrests
- Adjust the headrest so the top is level with the top of your head.
- This prevents whiplash during rear-end collisions.

## Child Safety
- Children must be secured in appropriate child seats.
- Do not carry children under 10 years old in the front seat.
- When vehicle is running, do not leave children under 10 alone inside.

## Emergency Triangle
- Must be placed 100 meters before the vehicle on rural roads, 50 meters on urban roads.
- Reflective and visible from distance.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# معدات سلامة المركبات – أحزمة الأمان، الوسائد الهوائية، مساند الرأس

## قواعد حزام الأمان
- حزام الأمان إلزامي للسائق وجميع ركاب المقعد الأمامي.
- استخدام حزام الأمان:
  - يبقيك في مقعدك عند توقف المركبة فجأة.
  - يمنعك من الاصطدام بعجلة القيادة أو لوحة القيادة أو الزجاج الأمامي.
  - يمنع الركاب من الاصطدام ببعضهم البعض.
  - يساعد السائق على الحفاظ على السيطرة بعد الاصطدام أو أثناء المناورات المفاجئة.

## كيف تعمل أحزمة الأمان
- يؤدي ارتداء حزام الأمان بشكل صحيح إلى نشر قوة الاصطدام على أجزاء أقوى من الجسم (الصدر والحوض).
- يمنع طردك من السيارة.
- ارتديه دائمًا على مستوى منخفض من الوركين ودافئ على الصدر.

##وسائد هوائية
- الوسائد الهوائية مكملة لأحزمة الأمان – فهي لا تحل محلها.
- تتضخم في حالات الاصطدامات الأمامية المتوسطة إلى الشديدة.
- احتفظ بمسافة لا تقل عن 25 سم (10 بوصات) بين صدرك وعجلة القيادة.
- لا تضع مقاعد الأطفال المواجهة للخلف أمام الوسادة الهوائية النشطة.

## مساند الرأس
- اضبط مسند الرأس بحيث يكون الجزء العلوي في مستوى أعلى رأسك.
- وهذا يمنع الإصابة أثناء الاصطدامات الخلفية.

## سلامة الطفل
- يجب تأمين الأطفال في مقاعد الأطفال المناسبة.
- لا تحمل الأطفال أقل من 10 سنوات في المقعد الأمامي.
- أثناء تشغيل السيارة، لا تترك الأطفال دون سن 10 سنوات بمفردهم داخلها.

##مثلث الطوارئ
- يجب وضعه على مسافة 100 متر قبل المركبة على الطرق الريفية، و50 متراً على الطرق الحضرية.
- عاكسة ومرئية من مسافة بعيدة.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# First Aid Basics – Fractures

## Common Causes
- Car accidents, falls, sports injuries.

## Types of Fractures

### Closed Fracture
- Bone broken but skin not pierced.
- Less risk of infection.

### Open Fracture
- Bone breaks through the skin.
- High risk of infection and severe bleeding.

## Signs of a Fracture
- Person heard/felt a snap.
- Pain at the injury site.
- Unable to move the injured part.
- Swelling and discoloration of skin.

## First Aid for Closed Fracture
1. Keep the airway open. Perform artificial respiration if needed.
2. Call emergency services.
3. Immobilize the injured part (do not move it unnecessarily).
4. Apply a splint and secure it properly before moving the person.
5. Support the injured limb.

## First Aid for Open Fracture
1. Remove or cut away clothing around the wound.
2. Stop bleeding (apply sterile gauze with gentle pressure).
3. Cover wound with sterile dressing.
4. **Do not** try to push the bone back or straighten it.
5. Apply an appropriate splint.
6. Call emergency services immediately.

## Neck and Back Fractures
- **Do not** let the person move their neck or back.
- **Do not** move them.
- Call emergency services immediately.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# أساسيات الإسعافات الأولية – الكسور

## الأسباب الشائعة
- حوادث السيارات، السقوط، الإصابات الرياضية.

## أنواع الكسور

### كسر مغلق
- العظام مكسورة ولكن الجلد غير مثقوب.
- خطر أقل للإصابة بالعدوى.

### الكسر المفتوح
- تكسر العظام عبر الجلد.
- ارتفاع خطر الإصابة بالعدوى والنزيف الشديد.

## علامات الكسر
- سمع/شعر الشخص بصدمة.
- ألم في مكان الإصابة.
- عدم القدرة على تحريك الجزء المصاب.
- تورم وتغير لون الجلد.

## الإسعافات الأولية للكسور المغلقة
1. أبقِ مجرى الهواء مفتوحًا. إجراء التنفس الاصطناعي إذا لزم الأمر.
2. اتصل بخدمات الطوارئ.
3. تثبيت الجزء المصاب (لا تحركه دون داع).
4. ضع جبيرة وثبتها بشكل صحيح قبل تحريك الشخص.
5. دعم الطرف المصاب.

## الإسعافات الأولية للكسور المفتوحة
1. قم بإزالة أو قطع الملابس المحيطة بالجرح.
2. إيقاف النزيف (ضع شاشًا معقمًا مع الضغط الخفيف).
3. تغطية الجرح بضمادة معقمة.
4. **لا** تحاول دفع العظم إلى الخلف أو تقويمه.
5. ضع جبيرة مناسبة.
6. اتصل بخدمات الطوارئ على الفور.

## كسور الرقبة والظهر
- **لا** تدع الشخص يحرك رقبته أو ظهره.
- **لا** تحركهم.
- اتصل بخدمات الطوارئ على الفور.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# First Aid Basics – Burns and Bleeding

## Burn Degrees

### First Degree Burns
- Cause: Sun, hot objects, steam.
- Symptoms: Redness, pain, mild swelling.
- Heals quickly, no scars.

### Second Degree Burns
- Cause: Hot liquids (coffee, tea, oil, water), fire, mild acids/alkalis (batteries, some cleaners).
- Symptoms: Redness, blisters, significant swelling.
- Heals slowly, possible minor scars that fade.

### Third Degree Burns
- Cause: Open flame, electricity, concentrated acids/alkalis.
- Symptoms: All skin layers destroyed, muscles and nerves damaged.
- Heals very slowly with permanent disfigurement.

## First Aid for First Degree Burns
- Apply cold compresses to the burned area.
- Cover with sterile gauze.

## First Aid for Second Degree Burns
- Soak burned part in cold water for 10 minutes.
- Cover with dry sterile gauze.
- **Do not** break blisters.
- Keep burned limbs elevated.
- Seek medical help.

## First Aid for Third Degree Burns
- Cover with thick dry sterile gauze.
- Keep burned limbs elevated.
- **Do not** apply creams or ointments.
- Call emergency services immediately.

## Bleeding (Hemorrhage)
- Blood escaping from arteries, veins, or capillaries.

### First Aid for Bleeding
- Apply direct pressure with sterile gauze or clean cloth.
- If bleeding continues, add more gauze (do not remove first layer).
- Elevate the injured limb if no fracture.
- If severe, apply a tourniquet only if trained (last resort).
- Call emergency services.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# أساسيات الإسعافات الأولية – الحروق والنزيف

## درجات الحروق

###حروق من الدرجة الأولى
- السبب: الشمس، الأجسام الساخنة، البخار.
- الأعراض: احمرار، ألم، تورم خفيف.
- يشفى بسرعة، ولا يترك ندبات.

###حروق الدرجة الثانية
- السبب: السوائل الساخنة (القهوة، الشاي، الزيت، الماء)، النار، الأحماض الخفيفة/القلويات (البطاريات، بعض المنظفات).
- الأعراض: احمرار، بثور، تورم كبير.
- تشفى ببطء، ومن الممكن أن تتلاشى الندبات الطفيفة.

###حروق الدرجة الثالثة
- السبب: اللهب المكشوف، الكهرباء، الأحماض/القلويات المركزة.
- الأعراض: تدمير جميع طبقات الجلد وتلف العضلات والأعصاب.
- يشفى ببطء شديد مع تشوه دائم.

## الإسعافات الأولية لحروق الدرجة الأولى
- وضع كمادات باردة على المنطقة المحروقة.
- غطيها بشاش معقم.

## الإسعافات الأولية لحروق الدرجة الثانية
- نقع الجزء المحروق في الماء البارد لمدة 10 دقائق.
- يغطى بشاش جاف معقم.
- **لا** ** تكسر البثور.
- إبقاء الأطراف المحروقة مرتفعة.
- اطلب المساعدة الطبية.

## الإسعافات الأولية لحروق الدرجة الثالثة
- يغطى بشاش سميك جاف ومعقم.
- إبقاء الأطراف المحروقة مرتفعة.
- **لا** تضعي الكريمات أو المراهم.
- اتصل بخدمات الطوارئ على الفور.

## النزيف (النزف)
- خروج الدم من الشرايين أو الأوردة أو الشعيرات الدموية.

### الإسعافات الأولية للنزيف
- الضغط المباشر باستخدام شاش معقم أو قطعة قماش نظيفة.
- إذا استمر النزيف، أضف المزيد من الشاش (لا تقم بإزالة الطبقة الأولى).
- رفع الطرف المصاب في حالة عدم وجود كسر.
- إذا كانت الحالة شديدة، استخدم العاصبة فقط في حالة التدريب (الملاذ الأخير).
- الاتصال بخدمات الطوارئ.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Following Distance – Two-Second and Three-Second Rule

## Why Following Distance Matters
- Your vehicle needs time and space to stop safely.
- Stopping distance = Reaction distance + Braking distance.

## Two-Second Rule (Dry roads, good condition)
- Pick a fixed object (sign, tree, bridge).
- When the vehicle ahead passes it, count "one-thousand-one, one-thousand-two".
- If you reach the object before finishing, you are too close – increase distance.

## Three-Second Rule
- Apply in wet roads, poor weather, heavy load, or poor tires/brakes.
- Count "one-thousand-one, one-thousand-two, one-thousand-three".

## For Heavy Vehicles (Trucks, Buses)
- Always use Three-Second Rule even in good weather.
- Increase more in bad weather.

## Stopping Distance Increases With:
- Higher speed
- Heavier vehicle weight
- Slippery road (wet, gravel, snow, ice)
- Driver fatigue or stress
- Alcohol, drugs, certain medications
- Worn tires or brakes

## Visual Help (Manual Diagram)
- At 45 km/h, a small car needs a distance longer than six times its length to stop fully.

## Practical Tip
When stopped behind another vehicle, you should be able to see its rear tires touching the road. That leaves enough space to maneuver around if needed.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# مسافة التتبع – قاعدة الثانيتين والثلاث ثواني

## لماذا تعتبر المسافة التالية مهمة؟
- تحتاج سيارتك إلى الوقت والمساحة للتوقف بأمان.
- مسافة التوقف = مسافة رد الفعل + مسافة الفرملة.

## قاعدة الثانية (الطرق الجافة، بحالة جيدة)
- اختر كائنًا ثابتًا (علامة، شجرة، جسر).
- عندما تتجاوزها السيارة التي أمامك، قم بالعد "ألف، ألف واثنان".
- إذا وصلت إلى الجسم قبل الانتهاء، فأنت قريب جدًا - قم بزيادة المسافة.

## قاعدة الثلاثة ثواني
- يُستخدم على الطرق الرطبة، أو سوء الأحوال الجوية، أو الحمل الثقيل، أو الإطارات/الفرامل السيئة.
- عد "واحد ألف، ألف واثنان، ألف وثلاثة".

## للمركبات الثقيلة (الشاحنات، الحافلات)
- استخدم دائمًا قاعدة الثلاث ثوانٍ حتى في الطقس الجيد.
- تزداد أكثر في الأحوال الجوية السيئة.

## تزداد مسافة التوقف مع:
- سرعة أعلى
- وزن السيارة أثقل
- الطريق الزلق (الرطب والحصى والثلج والجليد)
- تعب السائق أو إجهاده
- الكحول، المخدرات، بعض الأدوية
- الإطارات أو الفرامل البالية

## مساعدة مرئية (مخطط يدوي)
- بسرعة 45 كم/ساعة، تحتاج السيارة الصغيرة إلى مسافة أطول من ستة أضعاف طولها لتتوقف بشكل كامل.

## نصيحة عملية
عند التوقف خلف مركبة أخرى، يجب أن تكون قادرًا على رؤية إطاراتها الخلفية وهي تلامس الطريق. وهذا يترك مساحة كافية للمناورة إذا لزم الأمر.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Accident Procedures and Breakdown Handling

## After an Accident
- Stop immediately (leaving the scene is a crime).
- Provide first aid to injured persons.
- Call police and ambulance.
- Do not move vehicles unless they block traffic and no serious injuries.
- Exchange information with other driver: name, car number, license number, insurance.

## Are You a Witness?
- If you pass an accident with injuries, you must stop and help until emergency services arrive.

## Failure to Report
- If you do not report an accident you were involved in within 48 hours (name, car number, license number), you are considered a "fleeing the scene" offender.

## Breakdown Handling
1. Try to move the vehicle off the road safely.
2. Choose a suitable stopping spot.
3. Turn on hazard lights (four-way flashers).
4. Place reflective triangle:
   - Outside cities: at least 100 meters before the vehicle.
   - Inside cities: at least 50 meters before the vehicle.
5. At night or low visibility, keep parking lights on.
6. Do not stand between your vehicle and oncoming traffic.
7. Call for help.

## If You Have a Disability
- Stay inside your vehicle.
- Turn on hazard lights.
- Ask others for help or place a help sign on the window.
- Use mobile phone to call for assistance.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# إجراءات الحوادث والتعامل مع الأعطال

## بعد وقوع حادث
- توقف فوراً (مغادرة المكان جريمة).
- تقديم الإسعافات الأولية للمصابين.
- استدعاء الشرطة والإسعاف.
- عدم تحريك المركبات إلا إذا كانت تعيق حركة المرور ولا توجد إصابات خطيرة.
- تبادل المعلومات مع السائق الآخر: الاسم، رقم السيارة، رقم الترخيص، التأمين.

## هل أنت شاهد؟
- في حالة مرورك بحادث به إصابات يجب عليك التوقف والمساعدة لحين وصول خدمات الطوارئ.

## الفشل في الإبلاغ
- إذا لم تقم بالإبلاغ عن حادث تعرضت له خلال 48 ساعة (الاسم، رقم السيارة، رقم الترخيص)، فسيتم اعتبارك مخالفًا "فاربًا من مكان الحادث".

## التعامل مع الأعطال
1. حاول إخراج المركبة من الطريق بشكل آمن.
2. اختر مكان التوقف المناسب.
3. قم بتشغيل أضواء الخطر (فلاشات رباعية الاتجاه).
4. ضع المثلث العاكس:
   - خارج المدن: قبل المركبة بـ 100 متر على الأقل.
   - داخل المدن: قبل المركبة بـ 50 متراً على الأقل.
5. في الليل أو انخفاض الرؤية، قم بإبقاء أضواء وقوف السيارات مضاءة.
6. لا تقف بين سيارتك وحركة المرور القادمة.
7. اطلب المساعدة.

## إذا كان لديك إعاقة
- البقاء داخل سيارتك.
- تشغيل أضواء الخطر.
- اطلب المساعدة من الآخرين أو ضع علامة مساعدة على النافذة.
- استخدم الهاتف المحمول لطلب المساعدة.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Traffic Violations and Penalties (Major Offenses)

## Causing Death or Permanent Disability
- Imprisonment: 3 months to 3 years
- Fine: 1000–2000 JD
- Or both
- License suspension: 6 months to 2 years

## Arrest Without Warrant (Driver)
- Causing death or injury
- Fleeing accident scene
- Driving without a license
- Driving during license suspension
- Using forged license or vehicle plate
- Reckless or show driving
- Driving under alcohol/drugs
- Driving a stolen or wanted vehicle

## Vehicle Impoundment (42 hours)
- Unregistered vehicle
- Unlicensed driver
- Public passenger vehicle with suspended permit
- Using vehicle for unlicensed purpose
- Public vehicle driven with category 1,2,3,7 license
- Reckless or show driving
- Illegal lights or sirens
- No front or rear plates / forged plates
- Vehicle license expired 6+ months
- Wanted vehicle
- Leaking oil or dangerous materials

## Penalties for Specific Serious Violations (examples)

### Stopping on railway crossing or intersection
- Jail min 6 months, fine 500–1000 JD

### Ignoring railway guard signals
- Jail 2–12 months, fine 500–1000 JD

### Fleeing accident with injuries
- Jail 3–6 months, fine 500–1000 JD

### Driving without license
- Jail 1–3 months, fine 250–500 JD

### Reckless driving
- Jail 1 week–1 month, fine 100–200 JD

### Running red light
- Same penalty as reckless driving

### Wrong way on divided road
- Same penalty

### Driving at night without lights
- Same penalty'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# المخالفات المرورية والعقوبات (المخالفات الكبرى)

##التسبب في الوفاة أو الإعاقة الدائمة
- السجن: من 3 أشهر إلى 3 سنوات
- الغرامة: 1000-2000 دينار
- أو كلاهما
- إيقاف الترخيص: من 6 أشهر إلى سنتين

## اعتقال بدون أمر قضائي (السائق)
- التسبب في الوفاة أو الإصابة
- الهروب من مكان الحادث
- القيادة بدون رخصة
- القيادة أثناء تعليق الترخيص
- استعمال رخصة أو لوحة مركبة مزورة
- القيادة المتهورة أو الاستعراضية
- القيادة تحت تأثير الكحول/المخدرات
- قيادة مركبة مسروقة أو مطلوبة

## حجز المركبة (42 ساعة)
- مركبة غير مسجلة
- سائق غير مرخص
- مركبة ركاب عمومية بتصريح معلق
- استعمال المركبة في غير غرض مرخص
- مركبة عمومية مدفوعة برخصة فئة 1،2،3،7
- القيادة المتهورة أو الاستعراضية
- أضواء أو صفارات الإنذار غير قانونية
- لا توجد لوحات أمامية أو خلفية / لوحات مزورة
- رخصة المركبة منتهية منذ أكثر من 6 أشهر
- مطلوب مركبة
- تسرب الزيت أو المواد الخطرة

## عقوبات المخالفات الجسيمة المحددة (أمثلة)

### التوقف عند معبر أو تقاطع السكة الحديد
- الحبس 6 أشهر كحد أدنى والغرامة من 500 إلى 1000 دينار

### تجاهل إشارات حراسة السكك الحديدية
- الحبس من 2 إلى 12 شهراً والغرامة من 500 إلى 1000 دينار

### الهروب من الحادث مع وجود إصابات
- الحبس من 3 إلى 6 أشهر والغرامة من 500 إلى 1000 دينار

### القيادة بدون رخصة
- الحبس من 1 إلى 3 أشهر والغرامة من 250 إلى 500 دينار

### القيادة المتهورة
- الحبس من أسبوع إلى شهر والغرامة من 100 إلى 200 دينار

### تشغيل الضوء الأحمر
- نفس عقوبة القيادة المتهورة

### طريق خاطئ على طريق مقسم
- نفس العقوبة

### القيادة ليلاً بدون أضواء
- نفس العقوبة'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Traffic Violations – Speeding and Points System

## Speeding Fines
- Exceeding limit by more than 50 km/h: Jail 2 weeks–3 months or fine 100 JD (plus license impound)
- Exceeding by 31–50 km/h: Fine 30 JD
- Exceeding by 11–30 km/h: Fine 20 JD

## Points System Overview
- Drivers accumulate points for violations.
- If points reach certain thresholds, license is suspended.

## Point Values for Selected Violations

| Violation | Points |
|-----------|--------|
| Wrong way on divided road | as per table |
| Running red light | as per table |
| Exceeding speed by >50 km/h | as per table |
| Reckless driving | as per table |
| Dangerous overtaking | as per table |
| Wrong direction or no-entry violation | as per table |
| Double parking inside cities | as per table |
| Motorcycle rider without helmet (driver or passenger) | as per table |
| Overweight truck | as per table |
| Driving under alcohol/drugs | as per table |

## Suspension Thresholds
- 16 points: Suspension for a period
- 20 points: Longer suspension
- 24 points: 120 days suspension
- 28+ points: 180 days suspension

## Temporary Permit
- When license is suspended, driver gets a temporary permit valid for 24 hours from time of impound.

## Points Clearance
- If no additional points for one full year, points are cleared (unless points already reached suspension limit).
- After serving actual suspension, points are cleared completely.

## Important Rules
- If multiple violations at same time, only the highest-point violation is counted.
- Points apply on violation date unless accident-related (then after final court ruling).'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# المخالفات المرورية – نظام السرعة والنقاط

## غرامات السرعة
- تجاوز الحد المسموح به بأكثر من 50 كم/ساعة: الحبس من أسبوعين إلى 3 أشهر أو غرامة 100 دينار أردني (بالإضافة إلى حجز الترخيص)
- تجاوز السرعة من 31 إلى 50 كم/ساعة غرامة 30 دينار
- التجاوز بسرعة 11-30 كم/ساعة: غرامة 20 دينار

## نظرة عامة على نظام النقاط
- يقوم السائقون بتجميع النقاط مقابل المخالفات.
- إذا وصلت النقاط إلى حدود معينة، يتم تعليق الترخيص.

## قيم النقاط للانتهاكات المحددة

| المخالفة | النقاط |
|-----------|--------|
| الطريق الخطأ على الطريق المقسم | حسب الجدول |
| تشغيل الضوء الأحمر | حسب الجدول |
| تجاوز السرعة >50 كم/ساعة | حسب الجدول |
| القيادة المتهورة | حسب الجدول |
| التجاوز الخطير | حسب الجدول |
| الاتجاه الخاطئ أو مخالفة عدم الدخول | حسب الجدول |
| مواقف مزدوجة داخل المدن | حسب الجدول |
| راكب دراجة نارية بدون خوذة (سائق أو راكب) | حسب الجدول |
| شاحنة زيادة الوزن | حسب الجدول |
| القيادة تحت تأثير الكحول/المخدرات | حسب الجدول |

## عتبات التعليق
- 16 نقطة: الإيقاف لمدة
- 20 نقطة: تعليق أطول
- 24 نقطة: إيقاف لمدة 120 يومًا
- أكثر من 28 نقطة: تعليق لمدة 180 يومًا

## تصريح مؤقت
- عند تعليق الترخيص، يحصل السائق على تصريح مؤقت صالح لمدة 24 ساعة من وقت الحجز.

## تصفية النقاط
- في حالة عدم وجود نقاط إضافية لمدة عام كامل، تتم تصفية النقاط (ما لم تصل النقاط بالفعل إلى حد التعليق).
- بعد انتهاء فترة الإيقاف الفعلي، يتم تصفية النقاط بالكامل.

## قواعد مهمة
- في حالة وجود مخالفات متعددة في نفس الوقت، يتم احتساب المخالفة ذات أعلى نقطة فقط.
- تطبق النقاط في تاريخ المخالفة ما لم تكن متعلقة بحادث (ثم بعد صدور الحكم النهائي من المحكمة).'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Practical Driving Basics (Automatic Transmission)

## Pre-Drive Checklist
- Adjust seat so you can reach pedals comfortably.
- Adjust all mirrors (interior, left, right).
- Fasten seatbelt.
- Check that gear selector is in P (Park) or N (Neutral).

## Starting the Engine
- Press brake pedal firmly.
- Turn key or push start button.
- Keep foot on brake.

## Selecting Gears
- **P (Park):** Starting/stopping engine, parked.
- **R (Reverse):** Backing up – only after full stop.
- **N (Neutral):** Engine runs but no drive to wheels.
- **D (Drive):** Normal forward driving – transmission shifts automatically.
- Some vehicles have D3, 2, 1 or L for hills/engine braking.

## Moving Off
- With foot on brake, move selector to D.
- Release parking brake (handbrake).
- Check mirrors and blind spot.
- Signal if needed (pull out from curb).
- Release brake gently, press accelerator smoothly.

## Stopping
- Remove foot from accelerator.
- Apply brake pedal smoothly.
- Keep foot on brake when stopped (especially at lights or stop lines).
- For longer stops, shift to P and apply parking brake.

## Hill Starts (Automatic)
- Hold foot on brake.
- Move to D.
- Release parking brake and brake pedal, then accelerate smoothly.
- Automatic vehicles rarely roll back, but on steep hills use handbrake assistance.

## Key Reminders
- No clutch pedal.
- Do not shift into P or R while moving.
- Use right foot for both brake and accelerator (left foot rest).'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# أساسيات القيادة العملية (ناقل الحركة الأوتوماتيكي)

## قائمة التحقق قبل القيادة
- اضبط المقعد حتى تتمكن من الوصول إلى الدواسات بشكل مريح.
- ضبط جميع المرايا (الداخلية، اليسرى، اليمنى).
- ربط حزام الأمان.
- تأكد من أن محدد التروس في وضع P (وقوف) أو N (محايد).

## تشغيل المحرك
- اضغط على دواسة الفرامل بقوة.
- تشغيل المفتاح أو الضغط على زر التشغيل.
- إبقاء القدم على الفرامل.

## اختيار التروس
- **P (وقوف):** تشغيل/إيقاف المحرك، متوقف.
- **R (عكسي):** الرجوع للخلف - فقط بعد التوقف الكامل.
- **N (محايد):** يعمل المحرك ولكن لا يوجد دفع للعجلات.
- **D (القيادة):** القيادة العادية للأمام - يقوم ناقل الحركة بالتبديل تلقائيًا.
- تحتوي بعض المركبات على D3 أو 2 أو 1 أو L لكبح التلال/المحرك.

## التحرك
- مع وضع القدم على الفرامل، حرك المحدد إلى D.
- حرر فرامل الانتظار (فرامل اليد).
- فحص المرايا والنقطة العمياء.
- إشارة إذا لزم الأمر (اسحب من الرصيف).
- حرر الفرامل بلطف، ثم اضغط على دواسة الوقود بسلاسة.

## توقف
- إزالة القدم من دواسة الوقود.
- استخدم دواسة الفرامل بسلاسة.
- إبقاء القدم على الفرامل عند التوقف (خاصة عند الأضواء أو خطوط التوقف).
- للتوقف لفترة أطول، انتقل إلى الوضع P واستخدم فرامل الانتظار.

## بداية التلال (تلقائي)
- ثبت القدم على الفرامل.
- انتقل إلى د.
- حرر فرامل الانتظار ودواسة الفرامل، ثم قم بزيادة السرعة بسلاسة.
- نادرًا ما ترجع السيارات الأوتوماتيكية إلى الخلف، ولكن على التلال شديدة الانحدار، استخدم مساعدة فرملة اليد.

## تذكيرات رئيسية
- عدم وجود دواسة القابض.
- لا تتحول إلى P أو R أثناء التحرك.
- استخدم القدم اليمنى للفرامل ودواسة الوقود (مسند القدم اليسرى).'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Practical Driving Basics (Manual Transmission)

## Pre-Drive
- Adjust seat, mirrors, seatbelt.
- Check gear lever is in neutral.
- Press clutch pedal fully before starting engine.

## Starting Engine
- Neutral gear.
- Clutch pressed.
- Turn key.

## Clutch and Gears
- Left foot operates clutch only.
- Right foot operates brake and accelerator.
- Gear pattern: Typically 1–2–3–4–5 (R) (check vehicle).

## Moving Off (Level Ground)
1. Clutch fully down.
2. Shift into 1st gear.
3. Release handbrake.
4. Slowly lift clutch until biting point (engine sound changes, vehicle vibrates slightly).
5. Add a little accelerator (about 1000–1500 rpm).
6. Continue releasing clutch smoothly while adding more gas.

## Shifting Up
- Accelerate to appropriate speed:
    - 1→2: ~10–20 km/h
    - 2→3: ~30–40 km/h
    - 3→4: ~50–60 km/h
    - 4→5: ~70+ km/h
- Procedure: Release accelerator, clutch down, shift, clutch up gradually, accelerate.

## Shifting Down
- Release accelerator, clutch down, shift to lower gear, clutch up gradually.
- Use when slowing down or climbing steep hills.

## Stopping
- Release accelerator.
- Brake gently.
- Clutch down just before vehicle fully stops (to avoid stalling).
- Shift to neutral.
- Apply handbrake.

## Hill Start (Manual)
1. Clutch down, 1st gear, handbrake on.
2. Hold handbrake button pressed.
3. Find biting point (clutch up slightly, engine drops sound).
4. Add a little accelerator.
5. Release handbrake while keeping clutch at biting point.
6. Slowly release clutch more, press accelerator more.

## Common Mistakes to Avoid
- Riding the clutch (foot resting on pedal while driving).
- Shifting without clutch fully down.
- Downshifting at too high speed (engine over-rev).
- Stalling by releasing clutch too fast without gas.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# أساسيات القيادة العملية (ناقل الحركة اليدوي)

## ما قبل القيادة
- ضبط المقعد، المرايا، حزام الأمان.
- تأكد من أن ذراع ناقل الحركة في الوضع المحايد.
- اضغط على دواسة القابض بالكامل قبل تشغيل المحرك.

## محرك البداية
- العتاد المحايد.
- تم الضغط على القابض .
- تشغيل المفتاح.

## القابض والتروس
- القدم اليسرى تعمل على تشغيل القابض فقط.
- القدم اليمنى تشغل الفرامل ودواسة الوقود.
- نمط التروس: عادةً 1–2–3–4–5 (R) (فحص السيارة).

## التحرك بعيدًا (مستوى الأرض)
1. القابض لأسفل بالكامل.
2. انتقل إلى السرعة الأولى.
3. حرر فرملة اليد.
4. ارفع القابض ببطء حتى نقطة العض (يتغير صوت المحرك، وتهتز السيارة قليلاً).
5. أضف القليل من المسرع (حوالي 1000-1500 دورة في الدقيقة).
6. استمر في تحرير القابض بسلاسة مع إضافة المزيد من الغاز.

## التحول لأعلى
- الإسراع إلى السرعة المناسبة:
    - 1→2: ~10–20 كم/ساعة
    - 2→3: ~30-40 كم/ساعة
    - 3→4: ~50-60 كم/ساعة
    - 4→5: ~70+ كم/ساعة
- الإجراء: حرر دواسة الوقود، ثم حرك القابض لأسفل، ثم قم بالتبديل، ثم حرك القابض لأعلى تدريجيًا، ثم قم بالتسريع.

## التحول للأسفل
- حرر دواسة الوقود، ثم حرك القابض لأسفل، ثم انتقل إلى ترس أقل، ثم حرك القابض لأعلى تدريجيًا.
- يُستخدم عند إبطاء السرعة أو تسلق التلال شديدة الانحدار.

## توقف
- الافراج عن مسرع.
- الفرامل بلطف.
- قم بخفض القابض قبل توقف السيارة بالكامل (لتجنب التوقف).
- التحول إلى الحياد.
- تطبيق فرملة اليد.

## بداية التلال (يدوي)
1. القابض لأسفل، الترس الأول، تشغيل فرملة اليد.
2. اضغط باستمرار على زر فرملة اليد.
3. ابحث عن نقطة العض (ارفع القابض قليلاً، سيصدر صوت المحرك).
4. أضف القليل من المسرع.
5. حرر فرملة اليد مع إبقاء القابض عند نقطة العض.
6. حرر القابض ببطء أكثر، واضغط على دواسة الوقود أكثر.

## الأخطاء الشائعة التي يجب تجنبها
- ركوب الكلتش (وضع القدم على الدواسة أثناء القيادة).
- التحول دون القابض لأسفل بالكامل.
- النقل إلى سرعة أقل بسرعة عالية جدًا (زيادة سرعة المحرك).
- المماطلة عن طريق تحرير القابض بسرعة كبيرة بدون غاز.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Motorcycle Preparation and Protective Gear

## Importance of Proper Gear
- In a crash, proper clothing and helmet greatly reduce severe injuries.
- Helmet is mandatory by Jordanian traffic law for both rider and passenger.

## Helmet
- Must meet approved safety standards.
- Full-face helmet offers best protection.
- Never ride without a helmet.

## Eye Protection
- Use a shatter-resistant face shield or goggles.
- Protects from wind, dust, insects, rain, and small debris from other vehicles.

## Clothing
- **Jacket:** Heavy, padded, or leather – protects arms and torso.
- **Pants:** Thick material, not regular jeans.
- **Gloves:** Prevent blisters and protect hands in a fall.
- **Boots:** Over the ankle, with oil-resistant soles.

## Pre-Ride Inspection (T-CLOCS)

### T – Tires and Wheels
- Check tire pressure and tread depth.
- Check wheels for damage; ensure bolts are tight.

### C – Controls
- Clutch and brake levers move freely.
- Throttle moves smoothly and returns automatically.
- Cables not frayed or loose.

### L – Lights and Electrical
- Headlights (high/low), taillight, turn signals, brake light all working.
- Horn works.

### O – Oil and Fluids
- Check engine oil, brake fluid, coolant (if liquid-cooled).

### C – Chassis
- Check chain/sprockets for tension and lubrication.
- Check suspension and frame for cracks or leaks.

### S – Stands
- Sidestand and centerstand not bent or loose.

## Being a Responsible Rider
- Never ride under influence.
- Stay focused – no phone use.
- Ride defensively – assume others do not see you.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# إعداد الدراجات النارية ومعدات الحماية

## أهمية العتاد المناسب
- في حالة وقوع حادث، فإن الملابس والخوذة المناسبة تقلل بشكل كبير من الإصابات الخطيرة.
- الخوذة إلزامية بموجب قانون المرور الأردني لكل من الراكب والراكب.

## خوذة
- يجب أن تستوفي معايير السلامة المعتمدة.
- توفر الخوذة كاملة الوجه أفضل حماية.
- لا تركب أبداً بدون خوذة.

## حماية العين
- استخدم درعًا للوجه أو نظارات واقية مقاومة للكسر.
- يحمي من الرياح والغبار والحشرات والمطر والحطام الصغير من المركبات الأخرى.

## ملابس
- **السترة:** ثقيلة أو مبطنة أو جلدية - تحمي الذراعين والجذع.
- **البنطلون:** خامة سميكة وليس الجينز العادي.
- **القفازات:** تمنع ظهور البثور وتحمي اليدين في حالة السقوط.
- **الأحذية:** فوق الكاحل، بنعل مقاوم للزيت.

## التفتيش قبل الركوب (T-CLOCS)

### T – الإطارات والعجلات
- فحص ضغط الإطارات وعمق المداس.
- فحص العجلات بحثًا عن أي ضرر؛ تأكد من أن البراغي ضيقة.

### ج – الضوابط
- تتحرك أذرع القابض والفرامل بحرية.
- يتحرك الخانق بسلاسة ويعود تلقائيًا.
- الكابلات غير مهترئة أو فضفاضة.

### إل – الأضواء والكهرباء
- المصابيح الأمامية (عالية/منخفضة)، الضوء الخلفي، إشارات الانعطاف، ضوء الفرامل كلها تعمل.
- يعمل القرن.

### O – الزيوت والسوائل
- فحص زيت المحرك، سائل الفرامل، سائل التبريد (إذا كان مبرداً بالسائل).

### ج – الهيكل
- التحقق من السلسلة/العجلات المسننة للتأكد من التوتر والتشحيم.
- التحقق من نظام التعليق والإطار للتأكد من عدم وجود شقوق أو تسربات.

### S – المدرجات
- الحامل الجانبي والمركز الأوسط غير منحنيين أو مفكوكين.

## أن تكون راكبًا مسؤولًا
- لا تركب أبداً تحت تأثير الكحول.
- حافظ على تركيزك - لا تستخدم الهاتف.
- قم بالقيادة بطريقة دفاعية - افترض أن الآخرين لا يرونك.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Motorcycle Lane Positioning and Visibility

## Lane Positioning Basics
- You have the right to the full lane – take it.
- Do not ride alongside cars in the same lane; they may not see you.

## Three Lane Positions (Imaginary)
- **Left third:** Best for left turns, passing, or when oncoming traffic is light.
- **Center:** Avoid center of lane (oil, debris, bumps). Use right or left third instead.
- **Right third:** Best for right turns, or when rain collects in center ruts.

## General Rule
- Choose the position that:
  - Makes you most visible to other drivers.
  - Gives you an escape route.
  - Avoids blind spots.

## Being Visible
- Ride where drivers ahead can see you in their mirrors.
- Avoid lingering in blind spots (especially large trucks).
- Make eye contact with drivers at intersections when possible.

## Merging and Joining Traffic
- At highway entries, signal early.
- Adjust speed to match traffic flow.
- Leave extra space when merging – cars may not see you.

## Riding Next to Other Vehicles
- Never ride side-by-side with another vehicle in the same lane.
- If possible, avoid riding directly next to trucks or buses.
- Speed up or drop back to create space.

## Blind Spots (No-Zones) of Trucks
- Directly behind the truck
- Directly in front (within 10 meters)
- On left side slightly behind the cab
- On right side (largest blind spot)

## Best Practice
- Own your lane.
- Be predictable.
- Keep a safe following distance (minimum 2 seconds, more in wet/gravel).'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# تحديد المواقع ورؤية حارة الدراجات النارية

## أساسيات تحديد موقع المسار
- لديك الحق في الحصول على المسار الكامل – خذه.
- لا تركب بجانب السيارات في نفس المسار؛ قد لا يرونك.

## ثلاثة أوضاع للمسارات (خيالية)
- **الثلث الأيسر:** الأفضل للانعطاف إلى اليسار أو المرور أو عندما تكون حركة المرور القادمة خفيفة.
- **المركز:** تجنب وسط المسار (الزيت، الحطام، المطبات). استخدم الثلث الأيمن أو الأيسر بدلاً من ذلك.
- **الثلث الأيمن:** الأفضل عند المنعطفات اليمنى، أو عندما يتجمع المطر في الأخاديد المركزية.

## القاعدة العامة
- اختر الموقف الذي:
  - يجعلك أكثر وضوحا للسائقين الآخرين.
  - يمنحك طريق الهروب.
  - يتجنب البقع العمياء.

## أن تكون مرئية
- قم بالقيادة حيث يستطيع السائقون أمامك رؤيتك في مراياهم.
- تجنب البقاء في المناطق العمياء (خاصة الشاحنات الكبيرة).
- تواصل بصريًا مع السائقين عند التقاطعات عندما يكون ذلك ممكنًا.

## دمج حركة المرور والانضمام إليها
- عند مداخل الطريق السريع، قم بالإشارة مبكرًا.
- ضبط السرعة لتتناسب مع تدفق حركة المرور.
- اترك مساحة إضافية عند الدمج - فقد لا تراك السيارات.

## الركوب بجانب المركبات الأخرى
- لا تركب أبدًا جنبًا إلى جنب مع مركبة أخرى في نفس المسار.
- إن أمكن، تجنب الركوب مباشرة بجوار الشاحنات أو الحافلات.
- تسريع أو التراجع لتوفير مساحة.

## النقاط العمياء (المناطق المحظورة) للشاحنات
- خلف الشاحنة مباشرة
- أمامك مباشرة (في حدود 10 أمتار)
- على الجانب الأيسر خلف الكابينة قليلاً
- على الجانب الأيمن (أكبر نقطة عمياء)

## أفضل الممارسات
- تملك المسار الخاص بك.
- كن متوقعا.
- حافظ على مسافة تتبع آمنة (ثانيتين على الأقل، وأكثر في الأراضي الرطبة/الحصى).'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),  -- assumes sequential execution
    'en',
    N'# Motorcycle Emergency Braking and Swerving

## Emergency Braking
- Use both brakes (front and rear) simultaneously.
- Apply front brake progressively and firmly – not grabbing.
- If the front wheel locks, release immediately and reapply smoothly.
- Rear brake: apply firmly; if it locks on rough surface, keep it locked until stopped.

## Stopping in a Curve
- Straighten the motorcycle first if possible.
- Brake while upright, then lean again.

## Swerving (Quick Direction Change)
- Used when braking alone won’t prevent a crash.
- Apply light pressure to handlebar in direction you want to go.
- Push right → go right. Push left → go left.
- Keep knees and elbows relaxed.
- Do not brake while swerving (brake first or after evading).

## Practice
- In safe parking lot, practice swerving between cones.
- Learn to look where you want to go, not at the obstacle.

## Obstacles to Avoid Swerving
- Broken pavement
- Potholes
- Fallen cargo
- Sudden stopped vehicle

## Cornering Technique
- Slow down before the curve (braking done).
- Look through the turn.
- Lean smoothly.
- Roll on throttle gradually through curve – never sudden throttle or brake.

## Cornering in Hazardous Surfaces
- Sand, gravel, wet leaves, ice – reduce speed before curve.
- Do not lean aggressively.
- Keep bike as upright as possible.

## Night and Low Visibility
- Reduce speed.
- Increase following distance.
- Use high beam when alone, low beam when following or oncoming.
- Wear reflective gear.'
);

INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    SCOPE_IDENTITY(),
    'ar',
    N'# فرملة الطوارئ للدراجات النارية والانحراف

## الكبح في حالات الطوارئ
- استخدم المكابح (الأمامية والخلفية) في وقت واحد.
- استخدم المكابح الأمامية بشكل تدريجي وثابت - دون الإمساك بها.
- إذا تم قفل العجلة الأمامية، فحررها على الفور وأعد وضعها بسلاسة.
- الفرامل الخلفية: تطبق بقوة؛ إذا تم قفله على سطح خشن، فاحتفظ به مغلقًا حتى يتوقف.

## التوقف في منحنى
- قم بتسوية الدراجة النارية أولاً إن أمكن.
- اضغط على الفرامل بينما تكون في وضع مستقيم، ثم انحنِ مرة أخرى.

## الانحراف (تغيير الاتجاه السريع)
- يُستخدم عندما لا يؤدي استخدام المكابح بمفرده إلى منع وقوع حادث.
- مارس ضغطًا خفيفًا على المقود في الاتجاه الذي تريد الذهاب إليه.
- ادفع لليمين ← اذهب لليمين. ادفع لليسار ← اتجه يسارًا.
- حافظ على استرخاء الركبتين والمرفقين.
- لا تستخدم المكابح أثناء الانحراف (استخدم المكابح أولاً أو بعد التهرب).

## الممارسة
- في ساحة انتظار السيارات الآمنة، تدرب على الانحراف بين المخاريط.
- تعلم أن تنظر إلى المكان الذي تريد الذهاب إليه، وليس إلى العائق.

## معوقات تجنب الانحراف
- الرصيف المكسور
- الحفر
- البضائع الساقطة
- توقف السيارة بشكل مفاجئ

## تقنية المنعطفات
- خفف السرعة قبل المنعطف (تم الكبح).
- انظر من خلال المنعطف.
- العجاف بسلاسة.
- قم بتشغيل دواسة الوقود تدريجيًا عبر المنعطف - لا تستخدم دواسة الوقود أو الفرامل بشكل مفاجئ أبدًا.

## الانعطاف في الأسطح الخطرة
- الرمل والحصى والأوراق المبللة والجليد - خفف السرعة قبل المنعطف.
- لا تميل بقوة.
- حافظ على الدراجة في وضع مستقيم قدر الإمكان.

## ليلا وتدني مدى الرؤية
- تقليل السرعة.
- زيادة المسافة التالية.
- استخدم الضوء العالي عندما تكون بمفردك، والضوء المنخفض عند المتابعة أو الاقتراب.
- ارتداء معدات عاكسة.'
);