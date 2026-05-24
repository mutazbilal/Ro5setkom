-- =============================================
-- Auto-generated seed file — modules
-- =============================================

-- LearningModules (base)
SET IDENTITY_INSERT Learning.LearningModules ON;
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (1, 1, 'theoretical', 1, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (2, 1, 'theoretical', 2, 1);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (3, 1, 'theoretical', 3, 2);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (4, 1, 'theoretical', 4, 3);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (5, 1, 'theoretical', 5, 4);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (6, 1, 'theoretical', 6, 5);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (7, 1, 'theoretical', 7, 1);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (8, 1, 'theoretical', 8, 6);
SET IDENTITY_INSERT Learning.LearningModules OFF;

-- ModuleTranslations
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (1, 'en', N'Introduction to Driving Responsibilities and Legal Framework', N'Comprehensive overview of driver responsibilities, legal requirements, license categories, medical fitness, and the examination process in Jordan');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (1, 'ar', N'مقدمة لمسؤوليات القيادة والإطار القانوني', N'نظرة شاملة عن مسؤوليات السائق، والمتطلبات القانونية، وفئات الترخيص، واللياقة الطبية، وعملية الفحص في الأردن');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (2, 'en', N'Road Markings: Lines, Symbols, and Their Meanings', N'Complete guide to understanding mandatory lines, warning lines, pedestrian crossings, lane arrows, and road symbols');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (2, 'ar', N'علامات الطريق: الخطوط والرموز ومعانيها', N'الدليل الكامل لفهم الخطوط الإلزامية، وخطوط التحذير، ومعابر المشاة، وسهام الحارات، ورموز الطريق');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (3, 'en', N'Traffic Signs Complete Guide - Warning, Priority, Prohibition, and Mandatory Signs', N'Comprehensive coverage of all traffic sign categories with shapes, colors, meanings, and proper responses');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (3, 'ar', N'الدليل الكامل لإشارات المرور - الإشارات التحذيرية والأولوية والحظر والإشارات الإلزامية', N'تغطية شاملة لجميع فئات إشارات المرور بالأشكال والألوان والمعاني والاستجابات المناسبة');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (4, 'en', N'Right-of-Way Rules at Intersections and Roundabouts', N'Complete guide to priority rules including right-hand rule, main road authority, roundabout navigation, T-junctions, and emergency vehicles');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (4, 'ar', N'قواعد حق الطريق عند التقاطعات والدوارات', N'دليل كامل لقواعد الأولوية بما في ذلك قاعدة اليد اليمنى، وسلطة الطريق الرئيسية، والملاحة الدائرية، وتقاطعات T، ومركبات الطوارئ');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (5, 'en', N'Lane Discipline, Turning, and Overtaking', N'Proper lane positioning, turning procedures at intersections, U-turn rules, roundabout navigation, and safe overtaking techniques');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (5, 'ar', N'الانضباط في المسار، والانعطاف، والتجاوز', N'تحديد موقع المسار الصحيح، وإجراءات الانعطاف عند التقاطعات، وقواعد الدوران على شكل حرف U، والملاحة في الدوارات، وتقنيات التجاوز الآمنة');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (6, 'en', N'Speed Limits, Following Distance, and Stopping Safely', N'Maximum and minimum speed limits by road type, two-second and three-second following rules, stopping distances, and emergency braking');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (6, 'ar', N'حدود السرعة ومسافة التتبع والتوقف الآمن', N'حدود السرعة القصوى والدنيا حسب نوع الطريق، وقواعد اتباع الثانية والثلاث ثواني، ومسافات التوقف، وفرامل الطوارئ');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (7, 'en', N'Alcohol, Drugs, Fatigue, and Safe Driving Fitness', N'Effects of alcohol, medications, and fatigue on driving ability; legal consequences; and concentration techniques');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (7, 'ar', N'الكحول والمخدرات والتعب ولياقة القيادة الآمنة', N'آثار الكحول والأدوية والتعب على القدرة على القيادة. العواقب القانونية؛ وتقنيات التركيز');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (8, 'en', N'Difficult Driving Conditions - Night, Weather, and Emergencies', N'Techniques for driving safely at night, in fog, rain, snow, ice, strong wind, and managing skids and emergencies');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (8, 'ar', N'ظروف القيادة الصعبة - الليل والطقس وحالات الطوارئ', N'تقنيات القيادة بأمان ليلاً، في الضباب والمطر والثلج والجليد والرياح القوية، وإدارة الانزلاقات وحالات الطوارئ');

-- ModuleContents (base)
SET IDENTITY_INSERT Learning.ModuleContents ON;
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (1, 1, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (2, 2, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (3, 3, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (4, 4, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (5, 5, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (6, 6, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (7, 7, 'text', NULL);
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) VALUES (8, 8, 'text', NULL);
SET IDENTITY_INSERT Learning.ModuleContents OFF;

-- ModuleContentTranslations
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (1, 'en', N'# Introduction to Driving Responsibilities and Legal Framework

## Section 1: Legal and Personal Responsibilities

Driving is a privilege, not a right. When you get behind the wheel, you accept legal and moral responsibility for yourself, your passengers, and everyone else on the road.

### Required Documents
- No person may drive any vehicle in Jordan without a valid, lawful driving license authorizing them to drive that specific vehicle category.
- Drivers must always carry their driving license, vehicle license (vehicle registration), and valid insurance documents.
- You must present these documents to any traffic officer upon request. Failure to do so is a violation.

### Basic Safety Principles
- Driving is a skill that requires full attention, respect for laws, and consideration for all other road users including pedestrians, cyclists, and motorcyclists.
- The general rule of right-of-way is fundamental: **priority is given, not taken**. Never assume another driver will yield to you even when you have the legal right-of-way.
- Always drive in a way that avoids endangering yourself or others. Defensive driving means anticipating what other road users might do wrong.

### Consequences of Violations
- Traffic violations lead to fines, imprisonment, license suspension, or impoundment of the vehicle depending on severity.
- Jordan operates a points system for driving violations. Accumulating points can result in license suspension or revocation.
- Repeated violations demonstrate unfitness to drive and carry progressively harsher penalties.

## Section 2: Fitness to Drive

### Physical Fitness
- You must be physically and mentally fit to drive at all times.
- Medical fitness is determined through an official medical examination that tests vision, limb health, and general health.
- Minimum vision requirement for most private licenses: 6/9 in the better eye with or without corrective lenses.
- For one-eyed applicants: The healthy eye must have vision of at least 6/9.

{{img:hi}}

### Mental and Emotional Fitness
- Do not drive if you are tired, emotional (angry, upset, extremely excited), or under the influence of any substance that impairs judgment.
- Emotional driving leads to aggressive behavior, poor decision-making, and increased risk-taking.
- Good driving is a combination of technical skill, knowledge of laws, and ethical behavior toward all road users.

### Medical Conditions Requiring Special Consideration
- Certain medical conditions such as epilepsy, diabetes (with risk of hypoglycemia), heart conditions, or sleep disorders may require medical clearance or restrict driving privileges.
- Always disclose relevant medical conditions during your license application.

## Section 3: Jordanian License Categories (Feras)

Jordan uses a category system (called "Feras" in Arabic) to classify different types of driving licenses.

| Category | Vehicle Type | Minimum Age |
|----------|--------------|--------------|
| 1 | Motorcycle / Scooter | 18 years |
| 2 | Agricultural vehicle | 18 years |
| 3 | Private car (manual or automatic), up to 5 tons | 18 years |
| 4 | Public passenger car / vehicle up to 7.5 tons | 21 years |
| 5 | Medium bus / vehicle over 7.5 tons | (Requires 2 years after previous category) |
| 6 | Tractor + trailer / heavy bus | (Requires 2 years after previous category) |
| 7 | Vehicles for people with disabilities | 18 years |

### Important Upgrade Rules
- Category 4 requires at least 1 year holding Category 3 (manual transmission license).
- Categories 5 and 6 require a minimum of 2 years after obtaining the previous category.
- Driving a vehicle that requires a higher category than your license permits is a serious violation with severe penalties.

## Section 4: Obtaining Your License - The Three-Step Process

### Step 1: Medical Examination
- Visit an approved medical center for a comprehensive driving fitness examination.
- Tests include vision, color perception (to distinguish traffic lights), hearing, limb mobility, and general health screening.
- The medical certificate is valid for a limited time and must be submitted with your application.

### Step 2: Theoretical Examination
- Tests your knowledge of traffic rules, right-of-way priorities, proper driving etiquette, basic vehicle maintenance, first aid, and traffic sign recognition.
- The test is typically computer-based with multiple-choice questions.
- If you fail, you may retake the exam after one week. There may be a limit on retakes within a specific period.

[Insert image of typical computer-based theoretical exam screen]

### Step 3: Practical Driving Examination
- Scheduled within one week after passing the theoretical test (subject to availability).
- A licensed examiner rides with you and evaluates your driving skills on public roads or a closed course.
- You must provide a suitable vehicle for the test (from a driving school or your own properly registered vehicle).

#### Practical Test Components:
- Vehicle preparation and pre-drive checks
- Proper startup procedure
- Moving off smoothly and safely
- Interacting with traffic appropriately
- Obeying all traffic signs and road markings
- Demonstrating correct priority rules at intersections
- Safe overtaking and meeting oncoming traffic
- Reversing in a straight line and around a corner
- Proper turning technique at junctions
- Correct gear selection and usage (manual transmission)
- Navigating curves and bends
- Normal stop and emergency stop
- Overall control, attention, and reaction time

### If You Fail the Practical Test
- You receive a written notice explaining the specific errors you made.
- You must wait at least two weeks before retaking the test.
- You may practice at a recognized training center during this waiting period.
- Common reasons for failure include: failing to check mirrors, incorrect positioning at junctions, poor clutch control (manual), not observing blind spots, or creating a dangerous situation.

### If Your Driving Poses an Immediate Danger
- The examiner has the authority to stop the test immediately.
- This results in an automatic failure and may require additional training before your next attempt.

## Section 5: Required Documents for License Application

When applying for a new driving license, prepare the following:

1. Official application form (obtained from licensing department or downloaded online)
2. Three recent color photographs (6×4 cm) with white or light blue background
3. Civil ID card or passport showing your national number
4. Proof of age (birth certificate or national ID)
5. Training completion certificate (for practical and theoretical training - required for all categories except 1 and 2)
6. Valid medical examination certificate
7. Fee payment receipt

### License Renewal and Replacement
- **Renewal:** Requires the same documents as a new application plus your expired license. Renew before the expiration date to avoid penalties.
- **Replacement for lost/damaged license:** Requires a special lost license form, new photographs, your ID, and the damaged license (if any). A police report may be required for lost licenses.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (1, 'ar', N'# مقدمة لمسؤوليات القيادة والإطار القانوني

## القسم الأول: المسؤوليات القانونية والشخصية

القيادة امتياز وليست حق. عندما تجلس خلف عجلة القيادة، فإنك تقبل المسؤولية القانونية والأخلاقية تجاه نفسك وتجاه الركاب وكل شخص آخر على الطريق.

### المستندات المطلوبة
- لا يجوز لأي شخص قيادة أي مركبة في الأردن دون الحصول على رخصة قيادة قانونية سارية المفعول تخوله قيادة تلك الفئة المحددة من المركبات.
- يجب على السائقين دائمًا حمل رخصة القيادة الخاصة بهم، ورخصة السيارة (تسجيل السيارة)، ووثائق التأمين الصالحة.
- يجب عليك تقديم هذه المستندات إلى أي ضابط مرور عند الطلب. عدم القيام بذلك يعد انتهاكا.

### مبادئ السلامة الأساسية
- القيادة مهارة تتطلب الاهتمام الكامل واحترام القوانين ومراعاة جميع مستخدمي الطريق الآخرين بما في ذلك المشاة وراكبي الدراجات والدراجات النارية.
- القاعدة العامة لحق الطريق أساسية: **الأولوية تعطى ولا تؤخذ**. لا تفترض أبدًا أن سائقًا آخر سوف يستسلم لك حتى عندما يكون لديك حق المرور القانوني.
- قم دائمًا بالقيادة بطريقة تتجنب تعريض نفسك أو الآخرين للخطر. القيادة الدفاعية تعني توقع الأخطاء التي قد يرتكبها مستخدمو الطريق الآخرون.

### عواقب المخالفات
- المخالفات المرورية تؤدي إلى غرامات أو سجن أو إيقاف الترخيص أو حجز المركبة حسب خطورتها.
- الأردن يطبق نظام النقاط لمخالفات القيادة. يمكن أن يؤدي تجميع النقاط إلى تعليق الترخيص أو إلغائه.
- المخالفات المتكررة تثبت عدم اللياقة للقيادة وتؤدي إلى فرض عقوبات أشد صرامة.

## القسم الثاني: اللياقة للقيادة

### اللياقة البدنية
- يجب أن تكون لائقًا بدنيًا وعقليًا للقيادة في جميع الأوقات.
- يتم تحديد اللياقة الطبية من خلال فحص طبي رسمي يفحص الرؤية وصحة الأطراف والصحة العامة.
- الحد الأدنى لمتطلبات الرؤية لمعظم الرخص الخاصة: 6/9 في العين الأفضل مع أو بدون عدسات تصحيحية.
- للمتقدمين أعور: يجب أن تتمتع العين السليمة برؤية لا تقل عن 6/9.

[أدخل صورة مخطط فحص العين المستخدم في الاختبارات الطبية]

### اللياقة العقلية والعاطفية
- لا تقود السيارة إذا كنت متعباً، أو منفعلاً (غاضباً، منزعجاً، متحمساً للغاية)، أو تحت تأثير أي مادة تضعف القدرة على الحكم.
- القيادة العاطفية تؤدي إلى السلوك العدواني، وسوء اتخاذ القرار، وزيادة المخاطرة.
- القيادة الجيدة هي مزيج من المهارة الفنية ومعرفة القوانين والسلوك الأخلاقي تجاه جميع مستخدمي الطريق.

### الحالات الطبية التي تتطلب عناية خاصة
- بعض الحالات الطبية مثل الصرع أو مرض السكري (مع خطر نقص السكر في الدم) أو أمراض القلب أو اضطرابات النوم قد تتطلب تصريحًا طبيًا أو تقييد امتيازات القيادة.
- قم دائمًا بالكشف عن الحالات الطبية ذات الصلة أثناء طلب الترخيص الخاص بك.

## القسم الثالث: فئات الرخصة الأردنية (فراس)

يستخدم الأردن نظام الفئات (يسمى "فراس" باللغة العربية) لتصنيف أنواع مختلفة من رخص القيادة.

| الفئة | نوع المركبة | الحد الأدنى للعمر |
|----------|--------------|--------------|
| 1 | دراجة نارية / سكوتر | 18 سنة |
| 2 | مركبة زراعية | 18 سنة |
| 3 | سيارة خاصة (يدوية أو أوتوماتيكية) حتى 5 طن | 18 سنة |
| 4 | سيارة / مركبة ركاب عامة تصل إلى 7.5 طن | 21 سنة |
| 5 | حافلة / مركبة متوسطة تزيد عن 7.5 طن | (يتطلب عامين بعد الفئة السابقة) |
| 6 | تراكتور + مقطورة / باص ثقيل | (يتطلب عامين بعد الفئة السابقة) |
| 7 | مركبات للأشخاص ذوي الإعاقة | 18 سنة |

### قواعد الترقية الهامة
- تتطلب الفئة 4 امتلاك الفئة 3 (رخصة النقل اليدوي) لمدة عام على الأقل.
- الفئتان 5 و 6 تتطلب مرور سنتين على الأقل بعد الحصول على الفئة السابقة.
- قيادة مركبة تتطلب فئة أعلى مما تسمح به رخصتك يعد انتهاكًا خطيرًا يعاقب عليه بعقوبات صارمة.

## القسم 4: الحصول على الترخيص الخاص بك - العملية المكونة من ثلاث خطوات

### الخطوة الأولى: الفحص الطبي
- زيارة أحد المراكز الطبية المعتمدة لإجراء فحص شامل للياقة القيادة.
- الاختبارات تشمل الرؤية واللون
الإدراك (للتمييز بين إشارات المرور)، والسمع، وحركة الأطراف، وفحص الصحة العامة.
- الشهادة الطبية صالحة لفترة محدودة ويجب تقديمها مع طلبك.

### الخطوة الثانية: الفحص النظري
- يختبر معرفتك بقواعد المرور، وأولويات حق الطريق، وآداب القيادة المناسبة، والصيانة الأساسية للمركبة، والإسعافات الأولية، والتعرف على إشارات المرور.
- يعتمد الاختبار عادةً على الكمبيوتر ويشتمل على أسئلة متعددة الاختيارات.
- في حالة الرسوب، يمكنك إعادة الاختبار بعد أسبوع واحد. قد يكون هناك حد لعمليات إعادة الالتقاط خلال فترة محددة.

[أدخل صورة لشاشة الامتحان النظري النموذجي المعتمد على الكمبيوتر]

### الخطوة 3: امتحان القيادة العملي
- يحدد موعده خلال أسبوع واحد بعد اجتياز الاختبار النظري (حسب توفره).
- يرافقك فاحص ترخيص ويقيم مهاراتك في القيادة على الطرق العامة أو المسار المغلق.
- يجب عليك توفير مركبة مناسبة للاختبار (من مدرسة تعليم القيادة أو سيارتك المسجلة حسب الأصول).

#### مكونات الاختبار العملي:
- إعداد السيارة وفحوصات ما قبل القيادة
- إجراءات بدء التشغيل الصحيحة
- التحرك بسلاسة وأمان
- التفاعل مع حركة المرور بشكل مناسب
- الالتزام بجميع إشارات المرور وعلامات الطريق
- إظهار قواعد الأولوية الصحيحة عند التقاطعات
- التجاوز الآمن ومواجهة حركة المرور القادمة
- الرجوع للخلف في خط مستقيم وعلى زاوية
- أسلوب الدوران الصحيح عند التقاطعات
- اختيار العتاد الصحيح واستخدامه (ناقل الحركة اليدوي)
- التنقل في المنحنيات والانحناءات
- التوقف العادي والتوقف الطارئ
- التحكم العام والانتباه وزمن رد الفعل

### إذا فشلت في الاختبار العملي
- تتلقى إشعارًا مكتوبًا يوضح الأخطاء المحددة التي ارتكبتها.
- يجب عليك الانتظار لمدة أسبوعين على الأقل قبل إعادة الاختبار.
- يمكنك التدرب في مركز تدريب معترف به خلال فترة الانتظار هذه.
- تشمل الأسباب الشائعة للفشل: الفشل في فحص المرايا، أو الوضع غير الصحيح عند التقاطعات، أو ضعف التحكم في القابض (اليدوي)، أو عدم ملاحظة النقاط العمياء، أو خلق موقف خطير.

### إذا كانت قيادتك تشكل خطرًا داهمًا
- يحق للفاحص إيقاف الاختبار فوراً.
- يؤدي هذا إلى فشل تلقائي وقد يتطلب تدريبًا إضافيًا قبل محاولتك التالية.

## القسم الخامس: المستندات المطلوبة لطلب الترخيص

عند التقدم بطلب للحصول على رخصة قيادة جديدة، قم بإعداد ما يلي:

1. نموذج الطلب الرسمي (يتم الحصول عليه من إدارة الترخيص أو تنزيله إلكترونيًا)
2. ثلاث صور شمسية حديثة مقاس 6×4 سم بخلفية بيضاء أو زرقاء فاتحة
3. البطاقة المدنية أو جواز السفر موضح به رقمك الوطني
4. إثبات السن (شهادة الميلاد أو الهوية الوطنية)
5. شهادة إتمام التدريب (للتدريب العملي والنظري - مطلوبة لجميع الفئات ما عدا الفئتين 1 و 2)
6. شهادة الفحص الطبي سارية المفعول
7. إيصال دفع الرسوم

### تجديد واستبدال الترخيص
- **التجديد:** يتطلب نفس المستندات المطلوبة في الطلب الجديد بالإضافة إلى الترخيص المنتهي الصلاحية. قم بالتجديد قبل تاريخ انتهاء الصلاحية لتجنب العقوبات.
- **بدل الرخصة المفقودة/التالفة:** يتطلب نموذج رخصة مفقودة خاصًا وصورًا جديدة وبطاقة هويتك والرخصة التالفة (إن وجدت). قد تكون هناك حاجة لتقرير الشرطة للتراخيص المفقودة.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (2, 'en', N'# Road Markings: Lines, Symbols, and Their Meanings

Road markings are painted lines, raised reflective markers, or thermoplastic symbols on the road surface that guide, warn, and inform drivers. Understanding them is essential for safe and legal driving.

## Section 1: Colors and Their Meanings

- **White lines:** Separate traffic traveling in the same direction or indicate mandatory markings such as stop lines, pedestrian crossings, or lane edges.
- **Yellow lines:** Indicate road edges (shoulder boundaries) or separate opposing traffic traveling in opposite directions.

[Insert image comparing white and yellow road line applications]

## Section 2: Mandatory (Compulsory) Lines

These lines create legal obligations that drivers must obey. Violating them is a traffic offense.

### Solid Longitudinal Lines (Continuous Lines)
- **Legal meaning:** Cannot be crossed for overtaking or changing lanes under any normal circumstances.
- **Purpose:** Separates opposing traffic flows, marks no-overtaking zones, approaches to obstacles or intersections, and road edges.
- **Yellow solid line on your side:** You are prohibited from crossing into oncoming traffic to overtake.
- **White solid line:** Do not change lanes; stay in your current lane.

[Insert picture of solid center line with "no crossing" explanation]

### Stop Line
- **Appearance:** Thick solid white line painted across the road, typically 30-50 cm (12-20 inches) wide.
- **Location:** Before intersections, railroad crossings, or any point where a complete stop is legally required.
- **Legal requirement:** You must bring your vehicle to a complete stop before this line, not on top of it or beyond it.
- **Often accompanied by:** A STOP sign on a post or the word "STOP" painted on the road surface.

**Real-world scenario:** You approach an intersection with a stop line but no stop sign. The stop line alone legally requires you to stop because it indicates the edge of the intersection where your view of cross traffic may be limited.

### Yield (Give Way) Line
- **Appearance:** A broken line made of a series of small triangles painted across the road.
- **Legal requirement:** You must give priority (yield) to all traffic on the main road. You may proceed without coming to a complete stop only if the main road is completely clear and it is safe to merge.
- **If necessary:** Stop completely before this line to assess traffic.

[Insert image comparing stop line vs. yield line appearance]

### Obstacle Lines (Hatched Areas)
- **Appearance:** Painted hatched or slanted lines forming a triangular or diagonal pattern within an area.
- **Location:** Before fixed obstacles (bridge pillars, medians, traffic islands) or to separate opposing traffic flows on wide roads.
- **Rule:** The area is surrounded by solid mandatory lines - you must not drive over or enter this area under any normal circumstances.
- **Exception:** Emergency vehicles responding to an incident may be permitted to cross in specific situations.

**Common mistake:** Drivers sometimes use hatched areas as turning lanes or to bypass traffic. This is illegal and dangerous.

## Section 3: Warning (Broken) Lines

These lines indicate where overtaking and lane changing may be permitted with caution.

### Broken Lines on Two-Way Roads
- **Outside cities (rural roads):** Broken line ratio of approximately 3:1 (three units of line, one unit of gap). The longer line segments indicate higher speeds and greater caution needed.
- **Inside cities (urban roads):** Broken line ratio of approximately 1:1 (equal line and gap lengths). Shorter segments reflect lower speeds and more frequent intersections.
- **Meaning:** Overtaking is allowed **with extreme caution** and only when the road ahead is clearly visible and clear of oncoming traffic.
- **Yellow broken lines:** Used primarily on secondary roads to warn drivers of the road edge, especially at night or in poor visibility.

[Insert picture showing broken line patterns with overtaking allowed/not allowed explanation]

### What the Line Tells You About Overtaking
- **Broken line on your side, solid on opposite side:** You may cross to overtake with caution; oncoming traffic must not cross into your lane.
- **Solid line on your side, broken on opposite:** You must not cross; oncoming traffic may cross (meaning you may face overtaking vehicles coming toward you).
- **Double solid lines (both sides solid):** No crossing from either direction under any circumstance.

## Section 4: Pedestrian Crosswalk (Zebra Crossing)

- **Appearance:** Wide white parallel stripes painted across the road, typically 2-3 meters wide.
- **Legal speed limit when approaching:** 30 km/h maximum.
- **Requirement:** You must stop completely if any pedestrian is on or about to step onto the crossing.
- **Do not:** Overtake another vehicle that has stopped at a pedestrian crossing - they have likely stopped for a pedestrian you cannot see.

### Zigzag Warning Lines
- **Location:** Painted on the road before and after pedestrian crossings, especially near schools.
- **Purpose:** Alert drivers that a pedestrian crossing is ahead and that parking and overtaking are prohibited in this zone.
- **Rule:** No parking, no stopping, and no overtaking within the zigzag zone.

[Insert image of zebra crossing with zigzag approach lines]

**Real-world scenario:** A school bus stops before a zebra crossing with its warning lights flashing. Children may be crossing. You must stop and wait until all children have crossed and the bus moves or turns off its lights.

## Section 5: Bicycle Lane Markings

- **Appearance:** Two solid white lines with a bicycle symbol painted in the space between them. The lane may also be painted a different color (often green or red) for visibility.
- **Legal requirement:** Do not drive or park in a bicycle lane. It is reserved exclusively for cyclists.
- **Intersection priority:** Cyclists using a marked bicycle lane have priority over turning vehicles at intersections. Always check your mirrors and blind spot for cyclists before turning across a bicycle lane.

[Insert picture of marked bicycle lane with bicycle symbol]

## Section 6: Words, Numbers, and Arrows on the Road

### Painted Words
- **"STOP":** Painted on the road surface before a stop line to reinforce the requirement to stop.
- **"BUS LANE":** Indicates a lane reserved for public transport buses. Private vehicles may be prohibited during certain hours (check local signs).
- **"SLOW":** Warns drivers to reduce speed for an upcoming hazard.

### Speed Numbers
- Painted numbers (e.g., "60", "80", "100") indicate the maximum speed limit for that section of road.
- These numbers supplement posted speed limit signs.

### Directional Arrows
- **Purpose:** Show the required or permitted direction of travel for each lane approaching an intersection.
- **Common arrow types:**
  - Straight ahead (arrow pointing up)
  - Right turn only (arrow pointing right)
  - Left turn only (arrow pointing left)
  - Straight or right turn (combination arrow)
  - Straight or left turn (combination arrow)

[Insert image of lane arrows at intersection approach]

**Legal requirement:** You must choose the lane that matches your intended direction. Using a lane with a straight arrow to turn left (or vice versa) is a traffic violation, even if no other vehicles are present.

**Real-world scenario:** You approach an intersection in the left-turn-only lane but decide to go straight instead. You cannot legally do this. You must turn left and then find a way to turn around or re-route.

## Section 7: Quick Reference Summary

| Marking Type | Appearance | Rule |
|--------------|------------|------|
| Solid center line | Continuous line | No crossing |
| Broken center line | Dashed line | May cross with caution |
| Stop line | Thick white line across road | Complete stop required |
| Yield line | Triangle dashes across road | Yield to traffic |
| Hatched area | Diagonal lines inside solid border | Do not enter |
| Zebra crossing | White stripes across road | Stop for pedestrians |
| Bicycle lane | Solid lines with bicycle symbol | Do not drive or park |');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (2, 'ar', N'# علامات الطريق: الخطوط والرموز ومعانيها

علامات الطريق هي خطوط مرسومة أو علامات عاكسة بارزة أو رموز لدنة بالحرارة على سطح الطريق لتوجيه السائقين وتحذيرهم وإبلاغهم. فهمها ضروري للقيادة الآمنة والقانونية.

## القسم الأول: الألوان ومعانيها

- **الخطوط البيضاء:** تفصل حركة المرور في نفس الاتجاه أو تشير إلى علامات إلزامية مثل خطوط التوقف أو معابر المشاة أو حواف الحارات.
- **الخطوط الصفراء:** تشير إلى حواف الطريق (حدود الكتف) أو حركة المرور المتعارضة المنفصلة التي تسير في اتجاهين متعاكسين.

[أدخل صورة تقارن بين تطبيقات خطوط الطرق باللونين الأبيض والأصفر]

## القسم الثاني: الخطوط الإلزامية (الإجبارية).

تخلق هذه الخطوط التزامات قانونية يجب على السائقين الالتزام بها. انتهاكهم هو جريمة مرورية.

### الخطوط الطولية الصلبة (الخطوط المستمرة)
- **المعنى القانوني:** لا يجوز التجاوز للتجاوز أو تغيير المسار تحت أي ظرف عادي.
- **الغرض:** فصل تدفقات حركة المرور المتعارضة، ووضع علامات على مناطق حظر التجاوز، ومقاربات العوائق أو التقاطعات، وحواف الطرق.
- **الخط المتصل الأصفر على جانبك:** يُحظر عليك العبور إلى حركة المرور القادمة للتجاوز.
- **خط أبيض متصل:** لا تقم بتغيير المسارات؛ البقاء في المسار الحالي الخاص بك.

[أدخل صورة لخط الوسط الصلب مع شرح "عدم وجود تقاطع"]

### خط التوقف
- **المظهر:** خط سميك أبيض صلب مرسوم عبر الطريق، ويبلغ عرضه عادةً 30-50 سم (12-20 بوصة).
- **الموقع:** قبل التقاطعات ومعابر السكك الحديدية أو أي نقطة يلزم فيها التوقف الكامل قانونيًا.
- **متطلب قانوني:** يجب عليك إيقاف سيارتك بشكل كامل قبل هذا الخط، وليس فوقه أو خلفه.
- **غالبًا ما تكون مصحوبة بما يلي:** علامة STOP على أحد المنشورات أو كلمة "STOP" مرسومة على سطح الطريق.

**سيناريو من العالم الحقيقي:** أنت تقترب من تقاطع به خط توقف ولكن لا توجد علامة توقف. يتطلب خط التوقف وحده من الناحية القانونية التوقف لأنه يشير إلى حافة التقاطع حيث قد تكون رؤيتك لحركة المرور المتقاطعة محدودة.

### خط العائد (افساح المجال).
- **المظهر:** خط متقطع مكون من سلسلة من المثلثات الصغيرة المرسومة على الجانب الآخر من الطريق.
- **المتطلبات القانونية:** يجب إعطاء الأولوية (العائد) لجميع حركة المرور على الطريق الرئيسي. لا يمكنك المضي قدمًا دون التوقف تمامًا إلا إذا كان الطريق الرئيسي خاليًا تمامًا وكان الاندماج فيه آمنًا.
- **إذا لزم الأمر:** توقف تمامًا قبل هذا الخط لتقييم حركة المرور.

[أدخل صورة تقارن بين خط التوقف ومظهر خط العائد]

### خطوط العوائق (المناطق المظللة)
- **المظهر:** خطوط مرسومة أو مائلة تشكل نمطًا مثلثًا أو قطريًا داخل المنطقة.
- **الموقع:** قبل العوائق الثابتة (أعمدة الجسور، الوسطيات، جزر المرور) أو لفصل تدفقات حركة المرور المتعارضة على الطرق الواسعة.
- **القاعدة:** المنطقة محاطة بخطوط إلزامية متصلة - لا يجوز لك القيادة أو الدخول إلى هذه المنطقة في أي ظروف عادية.
- **استثناء:** قد يُسمح لمركبات الطوارئ التي تستجيب لحادث ما بالعبور في مواقف محددة.

**خطأ شائع:** يستخدم السائقون أحيانًا المناطق المظللة كممرات للانعطاف أو لتجاوز حركة المرور. هذا غير قانوني وخطير.

## القسم 3: الخطوط التحذيرية (المكسورة).

تشير هذه الخطوط إلى الأماكن التي يجوز فيها السماح بالتجاوز وتغيير المسار بحذر.

### خطوط متقطعة على الطرق ذات الاتجاهين
- **خارج المدن (الطرق الريفية):** تبلغ نسبة الخطوط المتقطعة حوالي 3:1 (ثلاث وحدات خط ووحدة فجوة واحدة). تشير مقاطع الخطوط الأطول إلى سرعات أعلى وضرورة توخي المزيد من الحذر.
- **داخل المدن (الطرق الحضرية):** تبلغ نسبة الخطوط المتقطعة حوالي 1:1 (أطوال الخطوط والفجوات المتساوية). تعكس المقاطع الأقصر سرعات أقل وتقاطعات أكثر تكرارًا.
- **المعنى:** يُسمح بالتجاوز **بحذر شديد** وفقط عندما يكون الطريق أمامك مرئيًا بوضوح وخاليًا من حركة المرور القادمة.
- **الخطوط الصفراء المتقطعة:** تستخدم بشكل أساسي على الطرق الثانوية لتحذير السائقين من حافة الطريق، خاصة في الليل أو في حالة ضعف الرؤية.

[أدخل صورة توضح أنماط الخطوط المتقطعة مع تجاوز آل
تفسير منخفض/غير مسموح به]

### ماذا يخبرك الخط عن التجاوز
- **خط متقطع من جانبك، متصل على الجانب الآخر:** يمكنك العبور للتجاوز بحذر؛ يجب ألا تعبر حركة المرور القادمة إلى حارتك.
- **الخط المتصل من جانبك، والمكسور من الجهة المقابلة:** يجب ألا تعبر؛ قد تعبر حركة المرور القادمة (مما يعني أنك قد تواجه مركبات متجاوزة قادمة نحوك).
- **الخطوط الصلبة المزدوجة (الجانبين متصلين):** ممنوع العبور من أي اتجاه تحت أي ظرف من الظروف.

## القسم الرابع: معبر المشاة (معبر الحمار الوحشي)

- **المظهر:** خطوط بيضاء متوازية عريضة مرسومة على طول الطريق، ويبلغ عرضها عادةً 2-3 أمتار.
- **الحد الأقصى للسرعة القانونية عند الاقتراب:** 30 كم/ساعة كحد أقصى.
- **المتطلبات:** يجب عليك التوقف تمامًا في حالة وجود أي مشاة على المعبر أو على وشك الدخول إليه.
- **لا تفعل:** تجاوز مركبة أخرى توقفت عند معبر للمشاة - فمن المحتمل أنها توقفت بسبب أحد المشاة الذي لا يمكنك رؤيته.

### خطوط التحذير المتعرجة
- **الموقع:** مرسوم على الطريق قبل وبعد معابر المشاة، وخاصة بالقرب من المدارس.
- **الغرض:** تنبيه السائقين بوجود معبر للمشاة أمامهم وأن الوقوف والتجاوز محظور في هذه المنطقة.
- **القاعدة:** ممنوع الوقوف والتوقف وعدم التجاوز داخل المنطقة المتعرجة.

[أدخل صورة معبر الحمار الوحشي مع خطوط اقتراب متعرجة]

**سيناريو من العالم الحقيقي:** تتوقف حافلة مدرسية قبل معبر حمار وحشي وتومض أضواء التحذير الخاصة بها. قد يعبر الأطفال. يجب عليك التوقف والانتظار حتى يعبر جميع الأطفال وتتحرك الحافلة أو تطفئ أضواءها.

## القسم 5: علامات حارات الدراجات

- **المظهر:** خطان أبيضان متصلان مع رمز دراجة مرسوم في المسافة بينهما. يمكن أيضًا طلاء الممر بلون مختلف (غالبًا أخضر أو ​​​​أحمر) للرؤية.
- **المتطلبات القانونية:** لا تقم بالقيادة أو الوقوف في ممر مخصص للدراجات. وهي مخصصة حصريًا لراكبي الدراجات.
- **أولوية التقاطع:** يتمتع راكبو الدراجات الذين يستخدمون ممرًا محددًا للدراجات بالأولوية على تحويل المركبات عند التقاطعات. تحقق دائمًا من المرايا والنقطة العمياء لراكبي الدراجات قبل الانعطاف عبر ممر الدراجات.

[أدخل صورة لممر الدراجات المميز برمز الدراجة]

## القسم السادس: الكلمات والأرقام والأسهم على الطريق

### الكلمات المرسومة
- **"التوقف":** يتم رسمه على سطح الطريق قبل خط التوقف لتعزيز وجوب التوقف.
- **"BUS LANE":** تشير إلى المسار المخصص لحافلات النقل العام. قد يتم حظر المركبات الخاصة خلال ساعات معينة (تحقق من اللافتات المحلية).
- **"بطيء":** يحذر السائقين من تقليل السرعة تحسبًا لخطر قادم.

### أرقام السرعة
- الأرقام المرسومة (على سبيل المثال، "60"، "80"، "100") تشير إلى الحد الأقصى للسرعة لهذا الجزء من الطريق.
- هذه الأرقام تكمل علامات الحد الأقصى للسرعة المنشورة.

### أسهم الاتجاه
- **الغرض:** إظهار اتجاه السفر المطلوب أو المسموح به لكل حارة تقترب من التقاطع.
- **أنواع الأسهم الشائعة:**
  - للأمام مباشرة (السهم يشير للأعلى)
  - الانعطاف لليمين فقط (السهم يشير لليمين)
  - الانعطاف لليسار فقط (السهم يشير لليسار)
  - انعطاف مستقيم أو يمين (سهم مركب)
  - انعطاف مستقيم أو يسار (سهم مركب)

[أدخل صورة لأسهم الحارة عند اقتراب التقاطع]

**المتطلبات القانونية:** يجب عليك اختيار المسار الذي يتوافق مع اتجاهك المقصود. يعد استخدام حارة بها سهم مستقيم للانعطاف يسارًا (أو العكس) مخالفة مرورية، حتى في حالة عدم وجود مركبات أخرى.

**سيناريو العالم الحقيقي:** تقترب من تقاطع في المسار المخصص للانعطاف لليسار فقط ولكنك تقرر الاتجاه بشكل مستقيم بدلاً من ذلك. لا يمكنك القيام بذلك قانونيًا. يجب عليك الانعطاف يسارًا ثم العثور على طريقة للالتفاف أو تغيير المسار.

## القسم 7: ملخص مرجعي سريع

| نوع الوسم | المظهر | القاعدة |
|--------------|------------|------|
| خط الوسط الصلب | خط مستمر | لا معبر |
| خط الوسط المكسور | خط متقطع | قد أعبر بحذر |
| خط التوقف | خط أبيض سميك عبر الطريق | التوقف الكامل مطلوب |
| خط العائد | شرطات المثلث عبر الطريق | العائد لحركة المرور |
| منطقة فقس | خطوط قطرية داخل الحدود الصلبة | اِتَّشَح
بعد ذلك أدخل |
| معبر زيبرا | خطوط بيضاء عبر الطريق | توقف للمشاة |
| ممر الدراجات | خطوط صلبة مع رمز الدراجة | لا تقم بالقيادة أو ركن السيارة |');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (3, 'en', N'# Traffic Signs Complete Guide - Warning, Priority, Prohibition, and Mandatory Signs

Traffic signs communicate rules, warnings, and information instantly. Recognizing and responding correctly to every sign is essential for safe driving and passing your theoretical exam.

## Section 1: Warning Signs (Shape: Triangle, Point Up, Red Border, White Background, Black Symbol)

Warning signs alert you to hazards ahead. They always require reducing speed and increasing attention.

### Curve and Road Alignment Warnings

| Sign | Meaning | Correct Response |
|------|---------|-------------------|
| Right curve ahead | Road bends to the right | Reduce speed before curve, no overtaking, watch for limited visibility around bend |
| Left curve ahead | Road bends to the left | Same as right curve |
| Double curve (right then left) | S-curve, first right then left | Reduce speed significantly, stay in lane |
| Double curve (left then right) | S-curve, first left then right | Reduce speed significantly, stay in lane |

[Insert picture of right curve warning sign and the road condition it represents]

### Hill and Road Surface Warnings

| Sign | Meaning | Correct Response |
|------|---------|-------------------|
| Steep downhill | Significant downward slope ahead | Reduce speed before descent, use lower gears for engine braking, avoid riding brakes |
| Steep uphill | Significant upward slope ahead | Maintain momentum, downshift early if needed, keep right for faster vehicles |
| Uneven road | Bumps, dips, or damaged pavement ahead | Reduce speed, drive carefully to avoid vehicle damage or loss of control |
| Speed bump | Raised pavement hump ahead | Slow down significantly to cross safely at low speed |
| Dip | Sudden depression in road surface | Slow down to cross safely; suspension damage possible at speed |

[Insert picture of steep downhill warning sign]

### Road Width Warnings

| Sign | Meaning | Correct Response |
|------|---------|-------------------|
| Road narrows from both sides | Road becomes narrower from left and right | Slow down, move to center of available width, no overtaking |
| Road narrows from right | Right side of road narrows (obstruction or lane ends) | Slow down, keep left if safe, be prepared to yield |
| Road narrows from left | Left side of road narrows | Slow down, keep right |
| Bridge narrows | Bridge is narrower than approach road | Slow down, no overtaking, single file if necessary |
| Road ends at quay/river | Road terminates at water (dock, riverbank) | Slow down, be ready to stop completely |

### Work Zone Signs
- **Men working:** Road construction or maintenance ahead. Reduce speed, watch for workers and equipment, be prepared for lane shifts or reduced lanes.
- **Signals or flaggers may be present:** Obey flagger instructions even if they contradict traffic signs.

[Insert picture of "men working" warning sign]

### Other Important Warning Signs

| Sign | Meaning | Correct Response |
|------|---------|-------------------|
| Slippery road | Reduced traction due to rain, ice, oil, or loose surface | Reduce speed significantly, no sudden braking or steering, increase following distance |
| Falling rocks (right or left) | Risk of rocks falling onto road from adjacent hillside | Drive carefully, watch for rocks on road, avoid stopping in rockfall zone |
| Loose stones | Gravel or loose stones on road surface | Reduce speed, increase following distance (stones can be thrown up), no overtaking |
| Pedestrian crossing | Crosswalk ahead, pedestrians may be present | Reduce to 30 km/h, stop if pedestrians are crossing or waiting |
| Two-way traffic ahead | Road changes from divided to two-way | Keep right, be alert for oncoming vehicles, no crossing center line |
| Divided highway begins | Road ahead splits into separate carriageways | Keep right, follow lane markings, no crossing median |
| Divided highway ends | Divided road ends, becomes two-way | Keep right, be alert for oncoming traffic after the merge |
| Tunnel ahead | Enclosed tunnel passage | Reduce to 50 km/h (or posted limit), turn on headlights, keep lane, no overtaking, check that your vehicle height/width is permitted |
| Railway crossing with gate | Railroad crossing protected by gates or barriers | Stop when gates are down, give priority to trains, wait for gates to fully rise before proceeding |
| Railway crossing without gate | Unprotected railroad crossing | Reduce speed significantly, look and listen for trains, be ready to stop, proceed only when safe |
| Railway crossing distance marker | Three-stripe marker showing distance to crossing | Prepare to stop; more stripes = farther distance |
| Roundabout ahead | Circular intersection ahead | Reduce speed, give priority to vehicles already inside roundabout, choose correct lane for your exit |
| Stop sign ahead | Intersection with stop sign is approaching | Prepare to come to a complete stop |
| Yield sign ahead | Intersection with yield sign is approaching | Prepare to give way to crossing traffic |

## Section 2: Priority Signs

Priority signs tell you who has the right-of-way at intersections and narrow passages.

### Yield (Give Way)
- **Appearance:** Red-bordered inverted triangle (point down) with white center.
- **Action:** Reduce speed before the intersection. Give priority to all vehicles on the intersecting road. You may proceed without stopping only when the intersecting road is completely clear and safe.

[Insert picture of yield sign]

### Stop
- **Appearance:** Red octagon with white letters spelling "STOP".
- **Action:** Come to a **complete stop** before the stop line or before entering the intersection if no line exists. Do not creep forward. Proceed only when safe and clear in all directions.
- **Additional locations:** Also required at railway crossings without gates or signals.

[Insert picture of stop sign]

### Main Road
- **Appearance:** Yellow diamond with white border (and often a thick black outline).
- **Meaning:** You are traveling on the main road and have priority over traffic entering from side roads.
- **Caution:** Remain alert at intersections - not all drivers will yield to you properly.

### End of Main Road
- **Appearance:** Same yellow diamond shape but with black diagonal lines through it.
- **Meaning:** Your priority ends. Reduce speed and give way as required by other signs or the general right-of-way rules.

[Insert image of main road sign and end of main road sign side by side]

### Priority for Oncoming Traffic (Narrow Road)
- **Appearance:** Red-bordered circle with two arrows: one red (pointing up), one black (pointing down).
- **Meaning:** The red arrow indicates which direction has priority. If the red arrow points toward you, oncoming traffic has priority. You must stop and let them pass when the road is too narrow for two vehicles.
- **Common location:** Narrow bridges or mountain roads with limited passing space.

### Priority Over Oncoming Traffic
- **Appearance:** Blue square with two arrows: white arrow pointing down, red arrow pointing up.
- **Meaning:** You have priority. Oncoming vehicles must stop and let you pass when the road is too narrow.

[Insert image showing both narrow road priority signs]

## Section 3: Prohibition (Regulatory) Signs

Round signs with white background, red border, and black symbol. They tell you what you must NOT do.

| Sign | Meaning |
|------|---------|
| No entry both directions | Road closed to all motor vehicles (pedestrians and bicycles only) |
| No entry (one-way from opposite direction) | Do not enter this road from this end |
| No motor vehicles | No engine-powered vehicles of any kind |
| No motorcycles | Motorcycles prohibited |
| No bicycles | Bicycles prohibited |
| No mopeds | Small motorized scooters/bikes prohibited |
| No trucks or goods vehicles | Trucks exceeding a specified weight prohibited |
| No width over (number) | Vehicles wider than indicated (e.g., 2.2 meters) prohibited |
| No height over (number) | Vehicles taller than indicated (e.g., 3.5 meters) prohibited |
| No weight over (number) | Vehicles heavier than indicated (e.g., 12 tons) prohibited |
| No axle weight over (number) | Vehicles with axle load exceeding limit prohibited |
| No length over (number) | Vehicles longer than indicated prohibited |
| No left turn | Left turn prohibited at this intersection |
| No right turn | Right turn prohibited at this intersection |
| No U-turn | Turning to opposite direction prohibited |
| No overtaking | Overtaking prohibited for all vehicles (or for trucks over certain weight) |
| Speed limit (maximum) | Do not exceed the posted speed (number in red circle) |
| No horn | Horn use prohibited (near hospitals, schools, religious sites) |
| No stopping | Stopping vehicle prohibited (even briefly) |
| No parking | Parking vehicle prohibited (brief stopping may be allowed) |
| Customs stop | Must stop for customs inspection at border or checkpoint |

[Insert picture gallery of common prohibition signs: no entry, speed limit, no overtaking, no parking]

**Real-world scenario:** You see a "No left turn" sign at an intersection. You need to turn left. You cannot. You must go straight or turn right and find a safe place to turn around or re-route.

## Section 4: Mandatory (Command) Signs

Round or circular signs with blue background and white symbol. They tell you what you MUST do.

| Sign | Action Required |
|------|-----------------|
| Straight ahead only | Must drive straight; no turning |
| Turn left only | Must turn left |
| Turn right only | Must turn right |
| Straight or left | May go straight or turn left |
| Straight or right | May go straight or turn right |
| Keep left | Must keep to left side of obstacle or divider |
| Keep right | Must keep to right side of obstacle or divider |
| Minimum speed limit (blue circle with white number) | Must drive at least this speed (unless conditions prevent it) |

[Insert image of mandatory turn signs]

## Section 5: Informational (Guide) Signs

Rectangular or square signs, typically blue with white text/symbols. They provide navigation and service information.

### Types of Informational Signs

| Purpose | Example Information |
|---------|---------------------|
| Lane assignment | Diagram showing multiple lanes with arrows for each destination |
| Advance direction | "Amman 25 km" or "Irbid →" showing distance and direction |
| Route numbers | Primary route (e.g., Route 15) or secondary route (e.g., Route 122) |
| Motorway begins/ends | Indicates entrance to or exit from controlled-access highway |
| Additional lane | New lane joining from the right ahead |
| Lane reduction | Two lanes merging into one; adjust position early |
| Service signs | Petrol station, hospital, restaurant, hotel, rest area, repair shop |
| Tourist attraction | Direction to historical or cultural sites (brown background often used) |

[Insert image of guide sign showing multiple destinations with distances]

**Real-world scenario:** You are driving on an unfamiliar highway. An advance direction sign tells you that your exit is 2 kilometers ahead and recommends the right lane. Moving over early reduces stress and avoids last-second dangerous lane changes.

## Section 6: Summary - Recognizing Sign Shapes

- **Triangle pointing up, red border:** Warning (danger ahead)
- **Inverted triangle (point down), red border:** Yield
- **Octagon, red:** Stop
- **Circle, red border, white background:** Prohibition (something forbidden)
- **Circle or round, blue background:** Mandatory (something required)
- **Diamond, yellow:** Priority (main road or end of main road)
- **Rectangle or square, blue:** Information or direction

[Insert image showing sign shapes by category for quick recognition]');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (3, 'ar', N'# الدليل الكامل لإشارات المرور - الإشارات التحذيرية والأولوية والحظر والإشارات الإلزامية

تنقل إشارات المرور القواعد والتحذيرات والمعلومات على الفور. يعد التعرف على كل إشارة والاستجابة لها بشكل صحيح أمرًا ضروريًا للقيادة الآمنة واجتياز الاختبار النظري.

## القسم 1: العلامات التحذيرية (الشكل: مثلث، نقطة لأعلى، حد أحمر، خلفية بيضاء، رمز أسود)

علامات التحذير تنبهك إلى المخاطر المقبلة. إنها تتطلب دائمًا تقليل السرعة وزيادة الاهتمام.

### تحذيرات المنحنيات ومحاذاة الطريق

| التوقيع | معنى | الرد الصحيح |
|------|---------|------------------|
| المنحنى الأيمن للأمام | ينحني الطريق إلى اليمين | خفف السرعة قبل المنحنى، ممنوع التجاوز، انتبه إلى الرؤية المحدودة حول المنعطف |
| المنحنى الأيسر للأمام | ينحني الطريق إلى اليسار | نفس المنحنى الأيمن |
| منحنى مزدوج (يمين ثم يسار) | منحنى S، أولًا لليمين ثم لليسار | خفف السرعة بشكل ملحوظ، وابق في المسار |
| منحنى مزدوج (يسار ثم يمين) | منحنى S، أولًا لليسار ثم لليمين | خفف السرعة بشكل ملحوظ، وابق في المسار |

[أدخل صورة العلامة التحذيرية للمنحنى الأيمن وحالة الطريق التي تمثلها]

### تحذيرات على سطح التلال والطرق

| التوقيع | معنى | الرد الصحيح |
|------|---------|------------------|
| منحدر حاد | منحدر هبوطي كبير أمامنا | خفف السرعة قبل الهبوط، استخدم تروسًا أقل لفرملة المحرك، وتجنب ركوب الفرامل |
| شاقة شديدة الانحدار | منحدر صاعد كبير أمامنا | حافظ على الزخم، وقم بتغيير السرعة مبكرًا إذا لزم الأمر، وحافظ على اليمين للمركبات الأسرع |
| طريق غير مستوي | المطبات أو الانخفاضات أو الرصيف التالف أمامك | خفف السرعة، وقم بالقيادة بحذر لتجنب تلف السيارة أو فقدان السيطرة عليها |
| مطب السرعة | سنام الرصيف المرتفع للأمام | خفف السرعة بشكل ملحوظ للعبور بأمان بسرعة منخفضة |
| تراجع | منخفض مفاجئ على سطح الطريق | تمهل لتتمكن من العبور بأمان؛ احتمال تلف التعليق عند السرعة |

[أدخل صورة لعلامة التحذير من الانحدار الشديد]

### تحذيرات عرض الطريق

| التوقيع | معنى | الرد الصحيح |
|------|---------|------------------|
| الطريق يضيق من الجانبين | يصبح الطريق أضيق من اليسار واليمين | أبطئ السرعة، وانتقل إلى مركز العرض المتاح، بدون تجاوز |
| الطريق يضيق من اليمين | يضيق الجانب الأيمن من الطريق (عائق أو نهاية حارة) | أبطئ السرعة، وحافظ على اليسار إذا كنت آمنًا، وكن مستعدًا للاستسلام |
| الطريق يضيق من اليسار | الجانب الأيسر من الطريق يضيق | تمهل، حافظ على حقك |
| جسر يضيق | الجسر أضيق من طريق الاقتراب | تمهل، لا تجاوز، ملف واحد إذا لزم الأمر |
| ينتهي الطريق عند الرصيف/النهر | الطريق ينتهي عند الماء (رصيف، ضفة النهر) | تمهل، وكن مستعدًا للتوقف تمامًا |

### لافتات منطقة العمل
- **الرجال العاملون:** أعمال بناء الطرق أو صيانتها في المستقبل. قلل السرعة، وراقب العمال والمعدات، وكن مستعدًا لتغييرات المسار أو الممرات المنخفضة.
- **قد تكون هناك إشارات أو إشارات:** التزم بتعليمات المُبلغين حتى لو كانت تتعارض مع إشارات المرور.

[أدخل صورة اللافتة التحذيرية "رجال يعملون"]

### علامات تحذيرية مهمة أخرى

| التوقيع | معنى | الرد الصحيح |
|------|---------|------------------|
| طريق زلق | انخفاض الجر بسبب المطر أو الجليد أو الزيت أو السطح السائب | خفف السرعة بشكل كبير، لا تستخدم المكابح أو التوجيه بشكل مفاجئ، قم بزيادة مسافة التتبع |
| سقوط الصخور (يمين أو يسار) | خطر سقوط الصخور على الطريق من جانب التل المجاور | قم بالقيادة بحذر، وانتبه للصخور على الطريق، وتجنب التوقف في منطقة تساقط الصخور |
| حجارة سائبة | الحصى أو الحجارة السائبة على سطح الطريق | خفض السرعة، زيادة مسافة المتابعة (يمكن رمي الحجارة)، ممنوع التجاوز |
| معبر مشاة | معبر المشاة أمامك، قد يكون هناك مشاة | خفف السرعة إلى 30 كم/ساعة، وتوقف إذا كان هناك مشاة يعبرون الطريق أو ينتظرون |
| حركة المرور في اتجاهين أمامك | تغير الطريق من مقسم إلى اتجاهين | حافظ على اليمين، وكن متيقظًا للمركبات القادمة، ولا يوجد عبور للخط الأوسط |
| يبدأ الطريق السريع المقسم | الطريق أمامك ينقسم إلى طرق منفصلة | حافظ على اليمين، واتبع علامات المسار، ولا يوجد عبور متوسط ​​|
| ينتهي الطريق السريع المقسم | الطريق المقسم ينتهي، فيصبح ذو اتجاهين | حافظ على اليمين، وكن متيقظًا لحركة المرور القادمة بعد الدمج |
| تون
نيل قدما | ممر نفق مغلق | قلل السرعة إلى 50 كم/ساعة (أو الحد المعلن)، قم بتشغيل المصابيح الأمامية، حافظ على المسار، ممنوع التجاوز، تأكد من السماح بارتفاع/عرض سيارتك |
| معبر السكة الحديد مع بوابة | معبر السكك الحديدية المحمي بالبوابات أو الحواجز | توقف عند إغلاق البوابات، وأعط الأولوية للقطارات، وانتظر حتى ترتفع البوابات بالكامل قبل المتابعة |
| معبر السكة الحديد بدون بوابة | معبر سكك حديدية غير محمي | خفف السرعة بشكل كبير، وابحث عن القطارات واستمع إليها، وكن مستعدًا للتوقف، ولا تتقدم إلا عندما يكون ذلك آمنًا |
| علامة مسافة عبور السكة الحديد | علامة ثلاثية الخطوط توضح المسافة إلى المعبر | الاستعداد للتوقف؛ خطوط أكثر = مسافة أبعد |
| الدوار امام | أمامك تقاطع دائري | خفف السرعة، وأعطي الأولوية للمركبات الموجودة داخل الدوار، واختر المسار الصحيح لمخرجك |
| علامة التوقف للأمام | التقاطع مع إشارة التوقف يقترب | استعد للتوقف التام |
| علامة العائد قدما | التقاطع مع إشارة العائد يقترب | الاستعداد لإفساح المجال لعبور حركة المرور |

## القسم الثاني: علامات الأولوية

تخبرك علامات الأولوية بمن له حق الأولوية عند التقاطعات والممرات الضيقة.

### العائد (افساح المجال)
- **المظهر:** مثلث مقلوب حدوده حمراء (نقطة للأسفل) ومركزه أبيض.
- **الإجراء:** خفف السرعة قبل التقاطع. إعطاء الأولوية لجميع المركبات على الطريق المتقاطع. لا يجوز لك المضي قدمًا دون توقف إلا عندما يكون الطريق المتقاطع خاليًا وآمنًا تمامًا.

[أدخل صورة علامة العائد]

### توقف
- **المظهر:** مثمن أحمر بأحرف بيضاء تهجئة "STOP".
- **الإجراء:** توقف **تمامًا** قبل خط التوقف أو قبل الدخول إلى التقاطع في حالة عدم وجود خط. لا تزحف إلى الأمام. لا تتقدم إلا عندما تكون آمنًا وواضحًا في جميع الاتجاهات.
- **مواقع إضافية:** مطلوبة أيضًا عند معابر السكك الحديدية بدون بوابات أو إشارات.

[أدخل صورة علامة التوقف]

### الطريق الرئيسي
- **المظهر:** ماس أصفر ذو حدود بيضاء (وغالبًا ما يكون مخططًا أسود سميكًا).
- **المعنى:** أنت تسير على الطريق الرئيسي ولديك الأولوية على حركة المرور القادمة من الطرق الجانبية.
- **تحذير:** كن متيقظًا عند التقاطعات - لن يستسلم جميع السائقين لك بشكل صحيح.

### نهاية الطريق الرئيسي
- **المظهر:** نفس شكل الماسة الصفراء ولكن مع وجود خطوط قطرية سوداء من خلالها.
- **المعنى:** تنتهي أولويتك. خفف السرعة وأفسح المجال حسب ما تقتضيه العلامات الأخرى أو قواعد حق الأولوية العامة.

[أدخل صورة لافتة الطريق الرئيسية ونهاية لافتة الطريق الرئيسية جنبًا إلى جنب]

### الأولوية لحركة المرور القادمة (الطريق الضيق)
- **المظهر:** دائرة ذات حدود حمراء ولها سهمان: أحدهما أحمر (يشير إلى الأعلى)، والآخر أسود (يشير إلى الأسفل).
- **المعنى:** يشير السهم الأحمر إلى الاتجاه الذي له الأولوية. إذا كان السهم الأحمر يشير نحوك، فإن الأولوية لحركة المرور القادمة. يجب عليك التوقف والسماح لهم بالمرور عندما يكون الطريق ضيقًا جدًا بحيث لا يتسع لمركبتين.
- **موقع مشترك:** جسور أو طرق جبلية ضيقة ذات مساحة مرور محدودة.

### الأولوية على حركة المرور القادمة
- **المظهر:** مربع أزرق به سهمان: سهم أبيض يشير إلى الأسفل، وسهم أحمر يشير إلى الأعلى.
- **المعنى:** لك الأولوية. يجب أن تتوقف المركبات القادمة وتسمح لك بالمرور عندما يكون الطريق ضيقًا جدًا.

[أدخل صورة توضح كلا من علامات أولوية الطريق الضيقة]

## القسم الثالث: علامات المنع (التنظيمية).

علامات مستديرة ذات خلفية بيضاء وحدود حمراء ورمز أسود. يقولون لك ما لا يجب عليك فعله.

| التوقيع | معنى |
|------|---------|
| ممنوع الدخول في الاتجاهين | الطريق مغلق أمام جميع المركبات الآلية (المشاة والدراجات فقط) |
| ممنوع الدخول (اتجاه واحد من الاتجاه المعاكس) | لا تدخل هذا الطريق من هذه النهاية |
| لا يوجد سيارات | ممنوع المركبات التي تعمل بمحرك من أي نوع |
| لا دراجات نارية | الدراجات النارية محظورة |
| لا دراجات | الدراجات المحظورة |
| لا الدراجات النارية | الدراجات البخارية/الدراجات البخارية الصغيرة محظورة |
| لا توجد شاحنات أو مركبات بضائع | الشاحنات التي تتجاوز الوزن المحدد ممنوع |
| لا يوجد عرض فوق (الرقم) | المركبات الأعرض من المشار إليها (على سبيل المثال، 2.2 متر) محظورة |
| لا يوجد ارتفاع فوق (الرقم) | المركبات
أطول من المشار إليه (على سبيل المثال، 3.5 متر) محظور |
| لا وزن يزيد على (العدد) | المركبات الأثقل مما هو مذكور (على سبيل المثال، 12 طنًا) محظورة |
| لا يزيد وزن المحور عن (العدد) | المركبات ذات الحمولة المحورية التي تتجاوز الحد المسموح به |
| لا يوجد طول يزيد على (الرقم) | المركبات الأطول مما هو مذكور محظورة |
| لا يوجد انعطاف لليسار | ممنوع الانعطاف يسارًا عند هذا التقاطع |
| لا يوجد انعطاف يمين | ممنوع الانعطاف يمينًا عند هذا التقاطع |
| لا يوجد منعطف على شكل حرف U | ممنوع الإلتفاف إلى الإتجاه المعاكس |
| ممنوع التجاوز | ممنوع التجاوز لجميع المركبات (أو للشاحنات التي يزيد وزنها عن حد معين) |
| الحد الأقصى للسرعة (الحد الأقصى) | لا تتجاوز السرعة المعلنة (الرقم في الدائرة الحمراء) |
| لا قرن | ممنوع استخدام البوق (بالقرب من المستشفيات والمدارس والأماكن الدينية) |
| لا توقف | ممنوع إيقاف المركبة (ولو لفترة وجيزة) |
| لا يوجد موقف سيارات | ممنوع ركن السيارة (قد يُسمح بالتوقف لفترة قصيرة) |
| توقف الجمارك | يجب التوقف للتفتيش الجمركي على الحدود أو نقطة التفتيش |

[أدخل معرض الصور لعلامات المنع الشائعة: ممنوع الدخول، حدود السرعة، ممنوع التجاوز، ممنوع ركن السيارة]

**سيناريو العالم الحقيقي:** ترى لافتة "ممنوع الانعطاف إلى اليسار" عند أحد التقاطع. عليك أن تستدير لليسار. لا يمكنك ذلك. يجب عليك السير بشكل مستقيم أو الانعطاف يمينًا والعثور على مكان آمن للالتفاف أو تغيير المسار.

## القسم الرابع: العلامات الإلزامية (الأمر).

علامات مستديرة أو دائرية ذات خلفية زرقاء ورمز أبيض. يقولون لك ما يجب عليك القيام به.

| التوقيع | الإجراء مطلوب |
|------|-----------------|
| للأمام مباشرة فقط | يجب أن تقود السيارة بشكل مستقيم؛ لا تحول |
| اتجه يسارًا فقط | يجب أن اتجه يسارا |
| انعطف يمينًا فقط | يجب أن يتجه إلى اليمين |
| مستقيم أو يسار | قد يتجه بشكل مستقيم أو يتجه يسارًا |
| مستقيم أو صحيح | قد يتجه بشكل مستقيم أو يتجه يمينًا |
| حافظ على اليسار | يجب الالتزام بالجانب الأيسر من العائق أو الحاجز |
| حافظ على الحق | يجب الالتزام بالجانب الأيمن من العائق أو الحاجز |
| الحد الأدنى للسرعة (دائرة زرقاء مع رقم أبيض) | يجب القيادة بهذه السرعة على الأقل (ما لم تمنع الظروف ذلك) |

[أدخل صورة إشارات الانعطاف الإلزامية]

## القسم الخامس: العلامات الإرشادية (الإرشادية).

علامات مستطيلة أو مربعة، وعادةً ما تكون باللون الأزرق مع نص/رموز بيضاء. أنها توفر معلومات الملاحة والخدمة.

### أنواع العلامات المعلوماتية

| الغرض | معلومات المثال |
|---------|---------------------|
| تخصيص حارة | رسم تخطيطي يوضح مسارات متعددة مع أسهم لكل وجهة |
| الاتجاه المتقدم | "عمان 25 كم" أو "إربد →" تظهر المسافة والاتجاه |
| أرقام الطرق | الطريق الرئيسي (على سبيل المثال، الطريق 15) أو الطريق الثانوي (على سبيل المثال، الطريق 122) |
| يبدأ/ينتهي الطريق السريع | يشير إلى الدخول إلى الطريق السريع الذي يمكن التحكم في الوصول إليه أو الخروج منه |
| حارة إضافية | حارة جديدة تنضم من اليمين إلى الأمام |
| تخفيض المسار | مساران يندمجان في مسار واحد؛ ضبط الموقف في وقت مبكر |
| علامات الخدمة | محطة بنزين، مستشفى، مطعم، فندق، منطقة استراحة، ورشة إصلاح |
| جذب سياحي | الاتجاه إلى المواقع التاريخية أو الثقافية (خلفية بنية غالبًا ما تستخدم) |

[أدخل صورة اللافتة الإرشادية التي توضح الوجهات المتعددة مع المسافات]

**سيناريو العالم الحقيقي:** أنت تقود على طريق سريع غير مألوف. تخبرك علامة الاتجاه المتقدمة أن مخرجك يقع على بعد كيلومترين للأمام وتوصي بالمسار الأيمن. يؤدي التحرك مبكرًا إلى تقليل التوتر وتجنب تغيير المسار الخطير في الثانية الأخيرة.

## القسم 6: ملخص - التعرف على أشكال اللافتات

- **مثلث يشير لأعلى، حد أحمر:** تحذير (خطر قادم)
- **مثلث مقلوب (أشر إلى الأسفل)، حد أحمر:** العائد
- **المثمن، الأحمر:** توقف
- **دائرة، حد أحمر، خلفية بيضاء:** الحظر (شيء ممنوع)
- **دائرة أو مستديرة، خلفية زرقاء:** إلزامي (شيء مطلوب)
- **الماسي، الأصفر:** الأولوية (الطريق الرئيسي أو نهاية الطريق الرئيسي)
- **مستطيل أو مربع، أزرق:** معلومات أو اتجاه

[أدخل صورة توضح أشكال اللافتات حسب الفئة للتعرف عليها بسرعة]');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (4, 'en', N'# Right-of-Way Rules at Intersections and Roundabouts

Right-of-way rules determine who goes first at intersections, roundabouts, and other traffic situations. These rules prevent confusion and crashes. Memorize them completely.

## Section 1: General Approach to Any Intersection

Before applying specific rules, follow this safety routine at every intersection:

1. **Reduce speed** as you approach, even if you have priority.
2. **Choose the correct lane** well in advance using road markings and signs.
3. **Signal your intention** using turn signals at least 30 meters before the intersection.
4. **Check for other road users** - pedestrians, cyclists, motorcyclists, and other vehicles.
5. **Do not enter** if the intersection is already congested (gridlock rules).
6. **Maintain awareness** of vehicles behind you that may not expect you to stop.

[Insert image of intersection approach with lane selection and signaling]

## Section 2: Rule 1 - Right-Hand Rule (Equal Priority Intersections)

**When does this apply?** At intersections where there are no traffic signs, no traffic lights, and no road markings indicating a main road.

**The rule:** The vehicle coming from your **right** has priority over you. You must yield to that vehicle.

**How it works in all directions:**
- If you approach an intersection and see a vehicle coming from your right, you must wait for that vehicle to pass before proceeding.
- The vehicle to your left must yield to you.
- This creates a consistent clockwise priority system.

[Insert picture of equal priority intersection showing which vehicle yields to which]

**Real-world scenario:** You arrive at an uncontrolled four-way intersection in a residential area. A car approaches from your right at the same time. You stop and let that car go first. After it passes, you may proceed, checking that the vehicle to your left is also yielding to you.

**Common mistake:** Assuming that the first vehicle to arrive goes first. While polite, this is not the legal rule. The right-hand rule is the law, even if you arrived first.

## Section 3: Rule 2 - Opposite Direction Priority

**The rule:** When vehicles approach from opposite directions and one intends to turn left across the path of the other, the vehicle going straight or turning right has priority over the left-turning vehicle.

**Application:**
- You face an oncoming vehicle at an intersection.
- You want to turn left. The oncoming vehicle wants to go straight or turn right.
- The oncoming vehicle has priority. You must wait.
- The same applies if you want to go straight and the oncoming vehicle wants to turn left - you have priority.

[Insert image of opposite direction intersection with left-turning vehicle yielding]

**Real-world scenario:** You are at an intersection, signaling left. An oncoming car is approaching with no turn signal (going straight). You must wait for that car to clear the intersection before completing your left turn.

## Section 4: Rule 3 - Main Road vs. Secondary Road

**The rule:** Vehicles traveling on the main road (marked by priority signs) have priority over vehicles entering from side roads.

**Application:**
- If you are on the main road (yellow diamond sign), you may proceed through intersections without stopping.
- Vehicles from side roads must yield to you.
- If you are entering from a secondary road, you must yield to all traffic on the main road.

[Insert picture of main road sign and yield sign for side road]

**Caution:** Even when you have priority, always be prepared for drivers on side roads to pull out in front of you. Defensive driving means anticipating mistakes.

## Section 5: Rule 4 - Roundabout Priority

Roundabouts (traffic circles) keep traffic moving and reduce the severity of crashes compared to traditional intersections when used correctly.

### The Fundamental Rule
- **Vehicles already inside the roundabout have priority.**
- Vehicles waiting to enter must yield and wait for a safe gap in traffic.

### Lane Selection for Roundabouts

| Intended Exit | Lane to Enter | Lane to Stay In |
|---------------|---------------|-----------------|
| First exit (right turn) | Right lane | Right lane through roundabout |
| Straight ahead (second exit) | Either lane (if two lanes entering) | Stay in your lane through roundabout |
| Left turn (third exit or beyond) | Left lane | Left lane until near exit, then signal and move to exit |

[Insert image of multi-lane roundabout with lane arrows for each exit]

### Roundabout Navigation Steps

1. **Approach:** Reduce speed. Choose correct lane based on your exit.
2. **Yield:** Look left (in right-hand traffic countries) and yield to traffic already in the roundabout.
3. **Enter:** When a safe gap appears, merge smoothly.
4. **Navigate:** Stay in your lane. Do not change lanes inside the roundabout.
5. **Signal to exit:** Use right turn signal before your exit.
6. **Exit:** Exit smoothly, checking for pedestrians at crosswalks.

**Prohibited actions in roundabouts:**
- Stopping inside the roundabout (except to avoid a crash)
- Changing lanes
- Overtaking
- Driving next to a large truck or bus (stay behind or ahead, not beside)

**Real-world scenario:** You approach a roundabout and see a truck already inside, taking the left lane. You are in the right lane wanting to go straight. The truck blocks your view of traffic coming from the left. Wait until you have a clear view and a safe gap - do not assume the roundabout is clear just because you cannot see traffic.

## Section 6: Rule 5 - Railway Crossing Priority

**The rule:** Trains always have absolute priority over all road vehicles.

**Requirements at railway crossings:**
- Stop when gates are lowered or lights flash.
- Do not proceed until the train has completely passed and gates have fully risen.
- At crossings without gates, stop, look both ways, and listen before crossing.

[Insert picture of railway crossing with gates down and flashing lights]

**Critical warning:** Never stop on railway tracks. If traffic is backed up across a crossing, wait before the tracks until there is space on the other side.

## Section 7: Rule 6 - T-Junction Priority

**The rule:** The road that continues straight (the through road) has priority over the road that ends (the stem of the T).

**Application:**
- If you are on the road that ends at the T, you must yield to traffic traveling in either direction on the continuing road.
- If you are on the continuing road, you have priority over vehicles entering from the ending road.

[Insert image of T-junction with yield markings on ending road]

## Section 8: Rule 7 - Emergency and Official Vehicles

**The rule:** Police vehicles, ambulances, civil defense vehicles, and official government convoys using flashing lights and/or sirens have priority over all other traffic.

**Your legal duty:**
- Pull to the right side of the road as far as safely possible.
- Come to a complete stop if necessary to allow them to pass.
- Do not follow closely behind an emergency vehicle responding to a call.
- Do not enter an intersection if an emergency vehicle is approaching, even if your light is green.

[Insert image of vehicles pulling right for emergency vehicle with lights and sirens]

**Real-world scenario:** You are stopped at a red light and hear a siren approaching from behind. You see an ambulance in your mirror. You may carefully move forward or to the side (if safe) to create a path, even if the light is still red.

## Section 9: Rule 8 - Exiting Private Property

**The rule:** Vehicles exiting private areas (garages, fuel stations, private driveways, farms, parking lots) must stop and check for traffic before entering the public road.

**Application:**
- You do not have priority when entering a road from private property.
- You must yield to all traffic already on the road.
- This applies even if there are no signs or markings at the exit.

## Section 10: Rule 9 - Organized Processions

**The rule:** Organized pedestrian groups have priority. This includes:
- School groups (students walking in an organized manner)
- Scout troops
- Military processions (on foot)
- Funeral processions
- Official marches or parades

**Your duty:** Stop and allow the entire procession to pass before proceeding.

## Section 11: The Golden Rule and Common Violations

### Golden Rule (Memorize This)
**Priority is given, not taken.**

You never have the "right" to force your way through an intersection. You have the legal priority, but you must still drive safely and avoid crashes even if another driver violates your priority.

### Common Priority Violations and Mistakes

1. **Rolling through stop signs:** A complete stop is legally required, not a slow roll.
2. **Entering roundabouts without yielding:** Drivers who speed into roundabouts cause crashes. Yield means wait.
3. **Blocking intersections:** Entering a congested intersection even though you cannot clear it before the light changes.
4. **Assuming right-of-way at four-way stops:** The right-hand rule applies, not first-come-first-served.
5. **Not yielding to pedestrians:** Pedestrians in marked crosswalks have priority.

**Real-world scenario:** You have a green light and approach an intersection. A car runs the red light from your left. You have priority, but if you continue without checking, you will crash. Always look even when you have the green.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (4, 'ar', N'#قواعد حق المرور عند التقاطعات والدوارات

تحدد قواعد حق الأولوية من يذهب أولاً عند التقاطعات والدوارات ومواقف المرور الأخرى. تمنع هذه القواعد الارتباك والتعطل. احفظهم بالكامل.

## القسم 1: النهج العام لأي تقاطع

قبل تطبيق قواعد محددة، اتبع روتين السلامة هذا عند كل تقاطع:

1. **تقليل السرعة** عند اقترابك، حتى لو كانت لديك الأولوية.
2. **اختر المسار الصحيح** مسبقًا باستخدام علامات وإشارات الطريق.
3. **قم بالإشارة إلى نيتك** باستخدام إشارات الانعطاف قبل 30 مترًا على الأقل من التقاطع.
4. **التحقق من وجود مستخدمي الطريق الآخرين** - المشاة وراكبي الدراجات وراكبي الدراجات النارية والمركبات الأخرى.
5. **لا تدخل** إذا كان التقاطع مزدحمًا بالفعل (قواعد شبكة الأمان).
6. **حافظ على وعي** بالمركبات التي خلفك والتي قد لا تتوقع منك التوقف.

[أدخل صورة نهج التقاطع مع تحديد المسار والإشارة]

## القسم 2: القاعدة 1 - قاعدة اليد اليمنى (التقاطعات ذات الأولوية المتساوية)

**متى ينطبق ذلك؟** عند التقاطعات التي لا توجد فيها إشارات مرور، أو إشارات مرور، أو علامات طريق تشير إلى طريق رئيسي.

**القاعدة:** المركبة القادمة من **يمينك** لها الأولوية عليك. يجب أن تستسلم لتلك السيارة.

**كيف يعمل في كل الاتجاهات:**
- إذا اقتربت من تقاطع طرق ورأيت مركبة قادمة من يمينك، فيجب عليك انتظار مرور تلك السيارة قبل المتابعة.
- السيارة التي على يسارك يجب أن تخضع لك.
- يؤدي هذا إلى إنشاء نظام أولوية ثابت في اتجاه عقارب الساعة.

[أدخل صورة للتقاطع ذي الأولوية المتساوية موضحًا أي مركبة تتجه إلى أي منها]

**سيناريو العالم الحقيقي:** وصولك إلى تقاطع رباعي غير منضبط في منطقة سكنية. تقترب سيارة من يمينك في نفس الوقت. توقف واترك تلك السيارة تسير أولاً. بعد مروره، يمكنك المتابعة والتأكد من أن السيارة التي على يسارك تخضع لك أيضًا.

**خطأ شائع:** افتراض أن أول مركبة تصل تذهب أولاً. على الرغم من التهذيب، إلا أن هذه ليست القاعدة القانونية. قاعدة اليمين هي القانون، حتى لو وصلت أولاً.

## القسم 3: القاعدة 2 - أولوية الاتجاه المعاكس

**القاعدة:** عندما تقترب المركبات من اتجاهين متعاكسين وتنوي إحداهما الانعطاف يسارًا مقابل مسار الأخرى، تكون الأولوية للمركبة التي تسير بشكل مستقيم أو تنعطف يمينًا على المركبة التي تنعطف يسارًا.

**التطبيق:**
- تواجه مركبة قادمة عند تقاطع.
- تريد أن تستدير لليسار. تريد السيارة القادمة السير بشكل مستقيم أو الانعطاف إلى اليمين.
- السيارة القادمة لها الأولوية. يجب عليك الانتظار.
- وينطبق الشيء نفسه إذا كنت تريد السير بشكل مستقيم وكانت السيارة القادمة تريد الانعطاف يسارًا - فلديك الأولوية.

[أدخل صورة لتقاطع الاتجاه المعاكس مع عودة المركبة إلى اليسار]

**السيناريو الواقعي:** أنت عند تقاطع طرق، تشير إلى اليسار. هناك سيارة قادمة تقترب بدون إشارة انعطاف (تسير في خط مستقيم). يجب عليك الانتظار حتى تجتاز تلك السيارة التقاطع قبل إكمال المنعطف الأيسر.

## القسم 4: القاعدة 3 - الطريق الرئيسي مقابل الطريق الثانوي

**القاعدة:** المركبات التي تسير على الطريق الرئيسي (المميزة بعلامات الأولوية) لها الأولوية على المركبات التي تدخل من الطرق الجانبية.

**التطبيق:**
- إذا كنت على الطريق الرئيسي (علامة الماسة الصفراء)، فيمكنك السير عبر التقاطعات دون توقف.
- يجب أن تخضع لك المركبات القادمة من الطرق الجانبية.
- إذا كنت تدخل من طريق فرعي، فيجب عليك مراعاة جميع حركة المرور على الطريق الرئيسي.

[أدخل صورة لافتة الطريق الرئيسية ولافتة الاستسلام للطريق الجانبي]

**تحذير:** حتى عندما تكون لديك الأولوية، كن مستعدًا دائمًا لخروج السائقين على الطرق الجانبية أمامك. القيادة الدفاعية تعني توقع الأخطاء.

## القسم 5: القاعدة 4 - أولوية الدوار

الدوارات (الدوائر المرورية) تحافظ على حركة المرور وتقلل من خطورة الحوادث مقارنة بالتقاطعات التقليدية عند استخدامها بشكل صحيح.

### القاعدة الأساسية
- **للمركبات الموجودة داخل الدوار الأولوية.**
- يجب على المركبات التي تنتظر الدخول أن تستسلم وتنتظر وجود فجوة آمنة في حركة المرور.

### خط
اختيار للدوارات

| الخروج المقصود | حارة الدخول | حارة للبقاء فيها |
|---------------|--------------|-----------------|
| المخرج الأول (الانعطاف لليمين) | المسار الأيمن | المسار الأيمن عبر الدوار |
| للأمام مباشرة (المخرج الثاني) | أي حارة (في حالة دخول حارتين) | ابقَ في مسارك عبر الدوار |
| انعطف يسارًا (المخرج الثالث أو ما بعده) | المسار الأيسر | المسار الأيسر حتى قرب المخرج، ثم الإشارة والتحرك للخروج |

[أدخل صورة للدوار متعدد المسارات مع أسهم المسار لكل مخرج]

### خطوات التنقل في الدوار

1. **الاقتراب:** قلل السرعة. اختر المسار الصحيح بناءً على مخرجك.
2. **الخضوع:** انظر إلى اليسار (في البلدان التي بها حركة مرور على الجانب الأيمن) واستسلم لحركة المرور الموجودة بالفعل في الدوار.
3. **أدخل:** عندما تظهر فجوة آمنة، قم بالدمج بسلاسة.
4. **التنقل:** ابق في حارتك. عدم تغيير المسارات داخل الدوار.
5. **إشارة الخروج:** استخدم إشارة الانعطاف لليمين قبل خروجك.
6. **الخروج:** اخرج بسلاسة، وتحقق من وجود مشاة عند معابر المشاة.

**الحركات المحظورة في الدوارات:**
- التوقف داخل الدوار (إلا لتجنب الاصطدام)
- تغيير المسارات
- التجاوز
- القيادة بجوار شاحنة أو حافلة كبيرة (ابق في الخلف أو أمامك، وليس بجانبها)

**سيناريو من العالم الحقيقي:** تقترب من الدوار وترى شاحنة بداخله بالفعل، وتسلك المسار الأيسر. أنت في المسار الأيمن وتريد السير بشكل مستقيم. تحجب الشاحنة رؤيتك لحركة المرور القادمة من اليسار. انتظر حتى تحصل على رؤية واضحة وفجوة آمنة - لا تفترض أن الدوار خالٍ لمجرد أنك لا تستطيع رؤية حركة المرور.

## القسم 6: القاعدة 5 - أولوية عبور السكك الحديدية

**القاعدة:** تتمتع القطارات دائمًا بالأولوية المطلقة على جميع مركبات الطرق.

**الاشتراطات عند معابر السكك الحديدية:**
- توقف عند إنزال البوابات أو وميض الأضواء.
- لا تتقدم إلا بعد أن يمر القطار بالكامل وترتفع البوابات بالكامل.
- عند المعابر التي ليس لها بوابات، توقف وانظر في الاتجاهين واستمع قبل العبور.

[أدخل صورة معبر السكة الحديد مع بوابات مفتوحة وأضواء ساطعة]

**تحذير بالغ الأهمية:** لا تتوقف أبدًا على خطوط السكك الحديدية. إذا كانت حركة المرور متوقفة عبر المعبر، فانتظر قبل المسارات حتى تتوفر مساحة على الجانب الآخر.

## القسم 7: القاعدة 6 - أولوية الوصلة T

**القاعدة:** الطريق الذي يستمر بشكل مستقيم (الطريق العابر) له الأولوية على الطريق الذي ينتهي (جذع حرف T).

**التطبيق:**
- إذا كنت على الطريق الذي ينتهي عند T، فيجب عليك إعطاء الأولوية لحركة المرور في أي اتجاه على الطريق المستمر.
- إذا كنت على الطريق المستمر، فلديك الأولوية على المركبات التي تدخل من الطريق النهائي.

[أدخل صورة تقاطع T مع علامات الاستسلام على نهاية الطريق]

## القسم 8: القاعدة 7 - مركبات الطوارئ والمركبات الرسمية

**القاعدة:** تتمتع مركبات الشرطة وسيارات الإسعاف ومركبات الدفاع المدني والقوافل الحكومية الرسمية التي تستخدم الأضواء الساطعة و/أو صفارات الإنذار بالأولوية على جميع حركة المرور الأخرى.

** واجبك القانوني: **
- اتجه إلى الجانب الأيمن من الطريق إلى أقصى حد ممكن بأمان.
- توقف تمامًا إذا لزم الأمر للسماح لهم بالمرور.
- لا تتابع عن كثب خلف سيارة الطوارئ التي تستجيب لمكالمة.
- لا تدخل إلى التقاطع إذا كانت هناك سيارة طوارئ تقترب، حتى لو كان ضوءك أخضر.

[أدخل صورة للمركبات التي تتحرك إلى اليمين لمركبة الطوارئ المزودة بأضواء وصفارات الإنذار]

**سيناريو من العالم الحقيقي:** تتوقف عند إشارة حمراء وتسمع صفارة إنذار تقترب من الخلف. ترى سيارة إسعاف في مرآتك. يمكنك التحرك بعناية للأمام أو إلى الجانب (إذا كان آمنًا) لإنشاء مسار، حتى لو كان الضوء لا يزال أحمر.

## القسم 9: القاعدة 8 - الخروج من الملكية الخاصة

**القاعدة:** يجب على المركبات التي تخرج من المناطق الخاصة (الكراجات، محطات الوقود، الممرات الخاصة، المزارع، مواقف السيارات) التوقف والتحقق من حركة المرور قبل الدخول إلى الطريق العام.

**التطبيق:**
- ليس لك الأولوية عند دخول الطريق من ملكية خاصة.
- يجب عليك الخضوع لجميع حركة المرور الموجودة بالفعل على الطريق.
- وينطبق ذلك حتى لو لم تكن هناك علامات أو علامات عند المخرج.

## القسم 10: القاعدة 9 - المواكب المنظمة

**القاعدة:** مجموعة مشاة منظمة
شكا لها الأولوية. وهذا يشمل:
- مجموعات المدرسة (الطلاب يسيرون بطريقة منظمة)
- القوات الكشفية
- مواكب عسكرية (سيراً على الأقدام)
- مواكب الجنازة
- المسيرات أو المسيرات الرسمية

** واجبك: ** التوقف والسماح للموكب بأكمله بالمرور قبل المتابعة.

## القسم الحادي عشر: القاعدة الذهبية والمخالفات الشائعة

### القاعدة الذهبية (احفظ هذا)
**الأولوية تعطى ولا تؤخذ**

ليس لديك أبدًا "الحق" في شق طريقك عبر التقاطع. لديك الأولوية القانونية، ولكن لا يزال يتعين عليك القيادة بأمان وتجنب الاصطدامات حتى لو انتهك سائق آخر أولويتك.

### الانتهاكات والأخطاء الشائعة ذات الأولوية

1. **التدحرج عبر إشارات التوقف:** التوقف الكامل مطلوب قانونيًا، وليس التدحرج البطيء.
2. **الدخول إلى الدوارات دون مغادرة الطريق:** يتسبب السائقون الذين يدخلون الدوارات بسرعة في وقوع حوادث. العائد يعني الانتظار.
3. **سد التقاطعات:** الدخول إلى تقاطع مزدحم حتى لو لم تتمكن من إزالته قبل أن يتغير الضوء.
4. **بافتراض حق الأولوية عند التوقفات ذات الاتجاهات الأربعة:** تنطبق قاعدة اليد اليمنى، وليس أسبقية الحضور.
5. **عدم الاستسلام للمشاة:** للمشاة الموجودين في ممرات المشاة المحددة الأولوية.

**سيناريو العالم الحقيقي:** لديك ضوء أخضر وتقترب من التقاطع. سيارة تدير الضوء الأحمر من يسارك. لديك الأولوية، ولكن إذا تابعت دون التحقق، فسوف تتعطل. انظر دائمًا حتى عندما يكون لديك اللون الأخضر.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (5, 'en', N'# Lane Discipline, Turning, and Overtaking

Proper lane positioning, correct turning procedures, and safe overtaking are essential skills that prevent crashes and keep traffic flowing smoothly.

## Section 1: The Keep Right Rule

In Jordan (right-hand traffic), all drivers must keep to the right side of the road except when overtaking or turning left.

### When to Move to the Right
- You want to turn right at an upcoming intersection
- You are driving slower than surrounding traffic and vehicles behind want to overtake
- You approach a curve or hill crest (right position gives better view)
- Emergency vehicles approach from behind

### Multi-Lane Roads
- Slower vehicles use the **rightmost lane**
- Middle lanes for moderate speeds
- Left lane(s) for passing or faster traffic
- **Do not cruise in the left lane** - it blocks traffic and encourages dangerous passing on the right

[Insert image showing proper lane usage on multi-lane highway]

## Section 2: Proper Turning Procedures

### Turning Right

**Procedure:**
1. Position your vehicle in the **rightmost lane** well before the intersection.
2. Check your right mirror and blind spot for cyclists, pedestrians, or vehicles.
3. Activate your right turn signal at least 30 meters before the turn.
4. Reduce speed as you approach.
5. Turn from the rightmost lane into the rightmost lane of the cross street.
6. Complete the turn at a safe speed (typically 15-25 km/h).

**Common mistakes:**
- Swinging wide to the left before turning right
- Turning from the middle lane
- Failing to check for cyclists in the blind spot

### Turning Left

**On two-way roads with one lane each direction:**
- Move to the **right side** of your lane (not the center)
- Signal left
- Wait for oncoming traffic to clear
- Turn left only when safe and without blocking oncoming traffic

**On divided roads or roads with multiple lanes:**
- Use the **leftmost lane** designated for left turns
- If no dedicated left-turn lane, position near the center line
- Wait for oncoming traffic or a green arrow

**On one-way streets:**
- Turn left from the **leftmost lane**

[Insert image of proper left turn positioning on two-way vs. divided road]

**Critical rule:** When turning left at an intersection without a dedicated arrow, you must yield to all oncoming traffic going straight or turning right. Do not assume oncoming drivers will stop for you.

### U-Turns (Turning to Opposite Direction)

**Legally permitted only when:**
- No "No U-turn" sign is posted
- The road is not one-way
- You can complete the turn without blocking traffic or creating a hazard
- Visibility is clear in both directions
- You are not on a curve, near a hill crest, or near a railroad crossing

**Procedure:**
1. Move to the leftmost lane (or as far left as possible)
2. Signal left
3. Check mirrors and blind spot
4. Wait for a safe gap in both directions (oncoming traffic and traffic behind)
5. Turn quickly but smoothly when safe

**Important:** You **lose your right-of-way** when making a U-turn. You must yield to all other vehicles and pedestrians.

**Prohibited U-turn locations (even without a sign):**
- At curves or on hill crests (limited visibility)
- Within 150 meters of a railroad crossing
- Where you would block traffic or create danger

## Section 3: Roundabout Lane Discipline (Detailed)

### Two-Lane Roundabout Navigation

| Desired Exit | Entry Lane | Position in Roundabout | Exit |
|--------------|------------|------------------------|------|
| First exit (right turn) | Right lane | Right lane | Right lane of exit road |
| Second exit (straight) | Either lane | Stay in your lane | Appropriate lane of exit |
| Third exit (left turn) | Left lane | Left lane until past second exit | Right lane of exit after signaling |

**Critical rule:** You must exit from the same lane you entered relative to the exit road. If you enter from the left lane and want to take the third exit, you stay in the left lane until you pass the exit before yours, then signal and move to the right lane to exit.

[Insert image of multi-lane roundabout with numbered exits and lane paths]

## Section 4: Lane Changing Procedures

**Safe lane change steps:**

1. **Mirror check:** Check your interior mirror and side mirror on the side you intend to move.
2. **Signal:** Activate your turn signal for at least 3 seconds before moving.
3. **Blind spot check:** Turn your head to physically check the blind spot (area not visible in mirrors).
4. **Move gradually:** Change lanes smoothly, not abruptly.
5. **Cancel signal:** Turn off signal after completing the lane change.
6. **Maintain speed:** Do not slow down unnecessarily when changing lanes.

**Never change lanes:**
- Across a solid white or yellow line
- In an intersection
- On a curve or hill crest with limited visibility
- When it would force another driver to brake suddenly

[Insert diagram showing blind spot areas around a vehicle]

## Section 5: Overtaking Rules and Procedures

Overtaking means passing a moving or stationary vehicle or obstacle on the road.

### Where to Overtake

**Standard rule:** Always overtake on the **left side** of the vehicle ahead.

**Exceptions (overtake on right allowed when):**
- The vehicle ahead is signaling and preparing to turn left
- On multi-lane roads where lanes are separated and traffic is moving at different speeds (e.g., slower traffic in right lane)

### Safe Overtaking Procedure

1. **Check ahead:** Ensure the road is clear for enough distance to complete the overtake safely. For highway speeds, you need at least 300-400 meters of clear road ahead.
2. **Check behind:** Check interior mirror, side mirror, and blind spot to ensure no vehicle is already overtaking you.
3. **Signal:** Signal left to indicate your intention.
4. **Move out:** Pull into the overtaking lane, maintaining a safe side distance (at least 1.5 meters) from the vehicle you are passing.
5. **Complete quickly:** Accelerate to complete overtaking promptly but safely. Do not linger alongside the other vehicle.
6. **Signal right:** Before returning to your lane, signal right.
7. **Return safely:** Move back to your lane only when you can see the overtaken vehicle completely in your interior mirror (meaning you have at least a 2-second gap ahead of it).
8. **Cancel signal:** Turn off signal after returning to lane.

[Insert picture of proper overtaking sequence with distances marked]

### Prohibited Overtaking Situations (Memorize)

You must **NEVER** overtake in these situations:

**Visibility-related:**
- On curves where you cannot see far enough ahead
- On hill crests (approaching the top of a rise)
- In fog, heavy rain, dust storms, or any low-visibility condition

**Infrastructure-related:**
- Near pedestrian crosswalks or within 30 meters of one
- Near intersections or railroad crossings
- On bridges or in tunnels
- Where signs or solid lines prohibit overtaking

**Traffic-related:**
- When a line of vehicles is stopped (traffic jam or red light)
- When the vehicle ahead is already overtaking
- When a vehicle behind has already started overtaking you
- When traffic does not allow safe completion
- When the vehicle ahead signals (with left turn signal or hand) not to overtake
- Near stopped buses or passenger vehicles where passengers may be crossing the road

**Surface-related:**
- On slippery roads (rain, ice, snow, gravel, oil)

### Responsibilities of the Driver Being Overtaken

If another vehicle is overtaking you:
- Keep as far right as safely possible
- Do **NOT** increase your speed - this is illegal and dangerous
- Reduce speed slightly if needed to allow the overtaking vehicle to complete the maneuver safely
- Do not move left to block the overtaking vehicle

**Heavy/Slow vehicles:** If you drive a heavy or slow vehicle and traffic is building behind you with no safe overtaking opportunity, pull over at the first safe location to let others pass.

### Side Wind Effect During Overtaking

When overtaking or being overtaken by large vehicles (trucks, buses):
- Strong air displacement can push smaller vehicles sideways
- Keep both hands firmly on the steering wheel
- Anticipate the push and be ready to steer against it
- Do not brake suddenly when a truck passes - maintain steady speed

[Insert image showing wind effect when a truck overtakes a small car]

## Section 6: Common Lane and Overtaking Violations

| Violation | Danger | Penalty Severity |
|-----------|--------|------------------|
| Crossing solid line to overtake | Head-on collision risk | Severe |
| Overtaking on the right on a two-lane road | Blind spot collisions | Moderate to severe |
| Cutting back too soon after overtaking | Rear-end or sideswipe crash | Moderate |
| Overtaking at a pedestrian crossing | Pedestrian death or injury | Severe |
| Blocking the left lane while driving slowly | Encourages dangerous passes | Minor (but dangerous) |

**Real-world scenario:** You are driving on a two-lane rural road with a broken line on your side. You check ahead and see a curve approaching but it is still 500 meters away. You begin to overtake a slow truck. As you pull alongside, you realize the curve is closer than you thought and you cannot see around it. You abort the overtake, drop back behind the truck, and wait for a clearer stretch. This is the correct safe decision.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (5, 'ar', N'# انضباط المسار والانعطاف والتجاوز

يعد تحديد الموقع الصحيح للمسار وإجراءات الانعطاف الصحيحة والتجاوز الآمن من المهارات الأساسية التي تمنع الاصطدامات وتحافظ على تدفق حركة المرور بسلاسة.

## القسم 1: قاعدة الحفاظ على الحق

في الأردن (حركة المرور على اليمين)، يجب على جميع السائقين الالتزام بالجانب الأيمن من الطريق إلا عند التجاوز أو الانعطاف إلى اليسار.

### متى يجب التحرك إلى اليمين
- تريد الانعطاف يمينًا عند تقاطع قادم
- أنت تقود بسرعة أبطأ من حركة المرور المحيطة والمركبات التي خلفك تريد التجاوز
- أنت تقترب من منحنى أو قمة التل (الوضع الصحيح يعطي رؤية أفضل)
- اقتراب سيارات الطوارئ من الخلف

### طرق متعددة الحارات
- تستخدم المركبات الأبطأ **المسار الموجود في أقصى اليمين**
- الممرات الوسطى للسرعات المعتدلة
- المسار (الحارات) اليسرى للمرور أو حركة المرور الأسرع
- **لا تتجول في المسار الأيسر** - فهذا يعيق حركة المرور ويشجع على المرور الخطير على اليمين

[أدخل صورة توضح الاستخدام الصحيح للمسار على الطريق السريع متعدد المسارات]

## القسم الثاني: إجراءات الدوران الصحيحة

### الانعطاف إلى اليمين

**الإجراء:**
1. ضع سيارتك في **المسار الأقصى الأيمن** قبل التقاطع بوقت طويل.
2. تحقق من المرآة اليمنى والنقطة العمياء لراكبي الدراجات أو المشاة أو المركبات.
3. قم بتنشيط إشارة الانعطاف اليمنى قبل 30 مترًا على الأقل من الانعطاف.
4. خفف السرعة عند اقترابك.
5. انعطف من المسار الموجود في أقصى اليمين إلى المسار الموجود في أقصى يمين التقاطع.
6. أكمل المنعطف بسرعة آمنة (عادةً 15-25 كم/ساعة).

**أخطاء شائعة:**
- التأرجح على نطاق واسع إلى اليسار قبل الانعطاف إلى اليمين
- الانعطاف من المسار الأوسط
- عدم التحقق من وجود راكبي الدراجات في النقطة العمياء

### التحول إلى اليسار

**على الطرق ذات الاتجاهين بحارة واحدة في كل اتجاه:**
- انتقل إلى **الجانب الأيمن** من حارتك (وليس الوسط)
- إشارة اليسار
- انتظر حتى تختفي حركة المرور القادمة
- انعطف يسارًا فقط عندما يكون ذلك آمنًا ودون عرقلة حركة المرور القادمة

**على الطرق المقسمة أو الطرق ذات الممرات المتعددة:**
- استخدم **المسار الموجود في أقصى اليسار** المخصص للانعطاف إلى اليسار
- إذا لم يكن هناك حارة مخصصة للانعطاف إلى اليسار، فكن بالقرب من الخط الأوسط
- انتظر حركة المرور القادمة أو السهم الأخضر

**في الشوارع ذات الاتجاه الواحد:**
- انعطف يسارًا من **المسار الموجود في أقصى اليسار**

[أدخل صورة لتحديد موضع الانعطاف الصحيح لليسار على الطريق ذي الاتجاهين مقابل الطريق المقسم]

**قاعدة حاسمة:** عند الانعطاف يسارًا عند تقاطع طرق بدون سهم مخصص، يجب عليك إعطاء الأولوية لجميع حركة المرور القادمة التي تسير بشكل مستقيم أو تنعطف يمينًا. لا تفترض أن السائقين القادمين سيتوقفون من أجلك.

### المنعطفات على شكل حرف U (الانعطاف في الاتجاه المعاكس)

**مسموح به قانونًا فقط عندما:**
- عدم وضع لافتة "ممنوع الدوران على شكل حرف U".
- الطريق ليس ذو اتجاه واحد
- يمكنك إكمال المنعطف دون عرقلة حركة المرور أو خلق خطر
- الرؤية واضحة في كلا الاتجاهين
- أنت لست على منحنى، بالقرب من قمة التل، أو بالقرب من معبر للسكك الحديدية

**الإجراء:**
1. انتقل إلى أقصى اليسار (أو إلى أقصى اليسار قدر الإمكان)
2. إشارة اليسار
3. فحص المرايا والنقطة العمياء
4. انتظر وجود فجوة آمنة في كلا الاتجاهين (حركة المرور القادمة وحركة المرور الخلفية)
5. انعطف بسرعة ولكن بسلاسة عندما يكون الأمر آمنًا

**هام:** أنت **تفقد حق المرور** عند القيام بالانعطاف على شكل حرف U. يجب عليك الخضوع لجميع المركبات والمشاة الآخرين.

**مواقع الدوران المحظورة (حتى بدون وجود علامة):**
- عند المنحنيات أو على قمم التلال (رؤية محدودة)
- على مسافة 150 مترًا من معبر السكة الحديد
- حيث من شأنه أن يمنع حركة المرور أو يخلق خطرا

## القسم 3: الانضباط في حارة الدوار (مفصل)

### الملاحة في الدوار ذو المسارين

| الخروج المرغوب | حارة الدخول | الموقع في الدوار | خروج |
|--------------|-----------|-----------------------|------|
| المخرج الأول (الانعطاف لليمين) | المسار الأيمن | المسار الأيمن | المسار الأيمن لطريق الخروج |
| المخرج الثاني (مستقيم) | إما حارة | خليك في حارتك | حارة الخروج المناسبة |
| المخرج الثالث (الانعطاف يسارًا) | المسار الأيسر | المسار الأيسر حتى المخرج الثاني الماضي | حارة الخروج اليمنى بعد الإشارة |

**قاعدة حاسمة:** يجب عليك الخروج من نفس المسار الذي دخلت فيه بالنسبة لطريق الخروج. إذا دخلت من المسار الأيسر وأردت أن تسلك المخرج الثالث، فابق في المسار الأيسر حتى تتجاوز المخرج الذي يسبقك، ثم
gnal والانتقال إلى المسار الأيمن للخروج.

[أدخل صورة للدوار متعدد المسارات مع مخارج مرقمة ومسارات حارة]

## القسم الرابع: إجراءات تغيير المسار

**خطوات تغيير المسار الآمن:**

1. **فحص المرآة:** تحقق من المرآة الداخلية والمرآة الجانبية على الجانب الذي تنوي تحريكه.
2. **الإشارة:** قم بتنشيط إشارة الانعطاف لمدة 3 ثوانٍ على الأقل قبل التحرك.
3. **فحص النقطة العمياء:** أدر رأسك لتفحص النقطة العمياء فعليًا (المنطقة غير المرئية في المرايا).
4. **تحرك تدريجيًا:** قم بتغيير الممرات بسلاسة، وليس بشكل مفاجئ.
5. **إلغاء الإشارة:** قم بإيقاف تشغيل الإشارة بعد الانتهاء من تغيير المسار.
6. **حافظ على السرعة:** لا تبطئ السرعة دون داعٍ عند تغيير المسارات.

**لا تغير المسار أبدًا:**
- عبر خط أبيض أو أصفر متصل
- في تقاطع
- على منحنى أو قمة تل مع رؤية محدودة
- عندما يؤدي ذلك إلى إجبار سائق آخر على استخدام المكابح فجأة

[أدخل رسمًا تخطيطيًا يوضح مناطق النقاط العمياء حول السيارة]

## القسم الخامس: قواعد وإجراءات التجاوز

التجاوز يعني تجاوز مركبة متحركة أو متوقفة أو عائق على الطريق.

### مكان التجاوز

**القاعدة القياسية:** يجب التجاوز دائمًا من **الجانب الأيسر** من السيارة التي أمامك.

**الاستثناءات (يُسمح بالتجاوز على اليمين عندما):**
- السيارة التي أمامك تطلق الإشارة وتستعد للانعطاف إلى اليسار
- على الطرق متعددة الحارات حيث تكون الحارات مفصولة وتتحرك حركة المرور بسرعات مختلفة (على سبيل المثال، حركة مرور أبطأ في الحارة اليمنى)

### إجراءات التجاوز الآمنة

1. **التحقق مسبقًا:** تأكد من أن الطريق خالٍ لمسافة كافية لإكمال التجاوز بأمان. بالنسبة لسرعات الطرق السريعة، تحتاج إلى ما لا يقل عن 300-400 متر من الطريق الخالي أمامك.
2. **تحقق من الخلف:** تحقق من المرآة الداخلية، والمرآة الجانبية، والنقطة العمياء للتأكد من عدم تجاوزك لأي مركبة بالفعل.
3. **الإشارة:** قم بالإشارة إلى اليسار للإشارة إلى نيتك.
4. **الخروج:** ادخل إلى حارة التجاوز، وحافظ على مسافة جانبية آمنة (1.5 متر على الأقل) من السيارة التي تمر بها.
5. **أكمل بسرعة:** قم بالتسريع لإكمال التجاوز بسرعة ولكن بأمان. لا تبقى بجانب السيارة الأخرى.
6. **أشر لليمين:** قبل العودة إلى حارتك، أشر لليمين.
7. **العودة بأمان:** لا ترجع إلى مسارك إلا عندما تتمكن من رؤية السيارة التي تم تجاوزها بالكامل في المرآة الداخلية (مما يعني أن أمامك مسافة ثانيتين على الأقل).
8. **إلغاء الإشارة:** قم بإيقاف تشغيل الإشارة بعد العودة إلى المسار.

[أدخل صورة لتسلسل التجاوز الصحيح مع تحديد المسافات]

### مواقف التجاوز المحظورة (حفظ)

لا يجوز لك **أبدًا** التجاوز في هذه المواقف:

**متعلق بالرؤية:**
- على المنحنيات حيث لا يمكنك رؤية مسافة كافية أمامك
- على قمم التلال (تقترب من قمة المرتفع)
- في حالة الضباب والأمطار الغزيرة والعواصف الترابية أو أي حالة انخفاض الرؤية

**متعلق بالبنية التحتية:**
- بالقرب من ممرات المشاة أو على بعد 30 مترًا منها
- بالقرب من التقاطعات أو معابر السكك الحديدية
- على الجسور أو في الأنفاق
- في حالة وجود علامات أو خطوط متصلة تمنع التجاوز

**متعلق بحركة المرور:**
- عند توقف خط من المركبات (ازدحام مروري أو ضوء أحمر)
- عندما تكون السيارة التي أمامك قد تجاوزت بالفعل
- عندما تكون المركبة التي خلفك قد بدأت بالفعل في تجاوزك
- عندما لا تسمح حركة المرور بالإكمال الآمن
- عندما تعطي السيارة التي أمامك إشارة (بإشارة الانعطاف اليسرى أو اليد) بعدم التجاوز
- بالقرب من الحافلات أو مركبات الركاب المتوقفة حيث قد يعبر الركاب الطريق

** المتعلقة بالسطح: **
- على الطرق الزلقة (المطر، الجليد، الثلج، الحصى، النفط)

### مسؤوليات السائق الذي يتم تجاوزه

إذا تجاوزتك مركبة أخرى:
- حافظ على أقصى اليمين قدر الإمكان بأمان
- لا **لا** تزيد من سرعتك - فهذا أمر غير قانوني وخطير
- خفف السرعة قليلاً إذا لزم الأمر للسماح للمركبة المتجاوزة بإكمال المناورة بأمان
- لا تتحرك يسارًا لعرقلة السيارة المتجاوزة

**المركبات الثقيلة/البطيئة:** إذا كنت تقود مركبة ثقيلة أو بطيئة وكانت حركة المرور تتزايد خلفك دون وجود فرصة آمنة للتجاوز، توقف عند أول مكان آمن للسماح للآخرين بالمرور.

### تأثير الرياح الجانبية أثناء التجاوز

عند التجاوز أو تجاوزه من قبل لار
مركبات ge (الشاحنات والحافلات):
- إزاحة الهواء القوية يمكن أن تدفع المركبات الصغيرة إلى الجانب
- ضع كلتا يديك بقوة على عجلة القيادة
- توقع الدفع وكن مستعدًا للتوجه ضده
- لا تستخدم المكابح فجأة عندما تمر شاحنة - حافظ على سرعة ثابتة

[أدخل صورة توضح تأثير الرياح عندما تتجاوز شاحنة سيارة صغيرة]

## القسم السادس: مخالفات المسار المشترك والتجاوز

| المخالفة | خطر | شدة العقوبة |
|-----------|-------|-----------------|
| عبور الخط الصلب للتجاوز | خطر الاصطدام وجها لوجه | شديد |
| التجاوز من اليمين على طريق ذو مسارين | تصادمات النقطة العمياء | معتدلة إلى شديدة |
| التقليص بعد وقت قصير جدًا من التجاوز | تحطم النهاية الخلفية أو المسح الجانبي | معتدل |
| التجاوز عند معبر المشاة | وفاة أو إصابة أحد المشاة | شديد |
| قطع المسار الأيسر أثناء القيادة ببطء | يشجع التمريرات الخطيرة | بسيطة (ولكنها خطيرة) |

**سيناريو من العالم الحقيقي:** أنت تقود سيارتك على طريق ريفي مكون من حارتين مع وجود خط متقطع على جانبك. قمت بالتحقق للأمام ورأيت منحنى يقترب ولكنه لا يزال على بعد 500 متر. تبدأ في تجاوز شاحنة بطيئة. عندما تسير بجانبك، تدرك أن المنحنى أقرب مما كنت تعتقد ولا يمكنك الرؤية حوله. تقوم بإلغاء التجاوز، وتعود خلف الشاحنة، وتنتظر مسافة أكثر وضوحًا. هذا هو القرار الآمن الصحيح.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (6, 'en', N'# Speed Limits, Following Distance, and Stopping Safely

Speed management and safe following distances are the most critical factors in preventing crashes. Even if you break no other rule, driving at appropriate speeds with adequate space ahead prevents most collisions.

## Section 1: Understanding Stopping Distance

Your total stopping distance = Reaction Distance + Braking Distance

**Reaction distance:** The distance your vehicle travels from the moment you see a hazard to the moment you apply the brakes. For an alert driver, reaction time is approximately 0.75 to 1 second.

**Braking distance:** The distance your vehicle travels from brake application to complete stop. This varies dramatically with speed, road conditions, tire quality, and brake condition.

[Insert diagram showing reaction distance + braking distance = total stopping distance]

### Example: Stopping Distance at Different Speeds (Dry Road)

| Speed | Reaction Distance | Braking Distance | Total Stopping Distance |
|-------|------------------|------------------|------------------------|
| 30 km/h | 8 meters | 6 meters | 14 meters |
| 50 km/h | 14 meters | 17 meters | 31 meters |
| 70 km/h | 19 meters | 33 meters | 52 meters |
| 90 km/h | 25 meters | 55 meters | 80 meters |
| 110 km/h | 31 meters | 82 meters | 113 meters |

**Real-world implication:** At 110 km/h, you need more than the length of a football field to stop. If you follow closely at that speed, you will crash if the vehicle ahead stops suddenly.

## Section 2: Speed Limits in Jordan

### General Rules
- Do not exceed the maximum posted speed limit.
- Do not drive below the minimum speed if posted (usually on highways).
- Speed must always be appropriate for **conditions** - weather, traffic density, road surface condition, vehicle load, and visibility. A safe speed may be well below the posted limit in poor conditions.

### When to Reduce Speed Below the Limit
- Residential areas with children playing
- Poor visibility (fog, heavy rain, night without streetlights)
- Near schools during drop-off and pick-up times
- Approaching pedestrian crosswalks
- Curves, hills, intersections
- Areas with animals crossing (sheep, goats, camels)
- Construction or work zones

### Urban Roads (Inside City/Town Limits)

| Road Type | Private Cars & Light Trucks (≤2 tons) | Buses & Heavy Trucks |
|-----------|---------------------------------------|----------------------|
| Multi-lane divided roads (2+ lanes each direction with median) | 90 km/h | 80 km/h |
| Two-way undivided roads | 70 km/h | 70 km/h |
| Near schools and local/residential roads | 40 km/h | 40 km/h |

[Insert picture comparing divided highway vs. undivided road]

### Rural Roads (Outside City/Town Limits)

| Road Type | Private Cars & Light Trucks (≤2 tons) | Other Vehicles |
|-----------|---------------------------------------|----------------|
| Multi-lane divided highways | 110 km/h | 100 km/h |
| Two-way undivided roads | 110 km/h | 100 km/h |
| Secondary and agricultural roads | Lower limits as posted | Lower limits as posted |

### Minimum Speed
While Jordanian law does not specify a universal minimum speed number, driving unreasonably slow without cause (e.g., driving 40 km/h on a 90 km/h highway with no mechanical issue or weather problem) is a traffic violation that obstructs traffic flow and creates dangerous conditions.

### Speeding Penalties (Summary)

| Excess Over Limit | Penalty |
|-------------------|---------|
| More than 50 km/h over limit | Jail (2 weeks to 3 months) OR fine (100 JD), plus license impoundment |
| 31-50 km/h over limit | Fine 30 JD |
| 11-30 km/h over limit | Fine 20 JD |

## Section 3: The Two-Second Rule (Following Distance)

The two-second rule provides a safe following distance in good conditions.

### How to Apply the Two-Second Rule

1. Watch for the vehicle ahead to pass a fixed object (sign, tree, bridge, road marking).
2. As the rear of that vehicle passes the object, begin counting: "one-thousand-one, one-thousand-two".
3. If you reach the object before finishing "one-thousand-two", you are following too closely. Increase your distance and repeat.

[Insert image demonstrating two-second rule counting method]

### When to Use Three Seconds or More

Apply the **three-second rule** (or greater) in these situations:

- **Wet roads** (rain, standing water)
- **Poor tire condition** (worn tread)
- **Poor brake condition**
- **Heavy vehicle load** (passengers or cargo)
- **Night driving** (reduced visibility)
- **Following motorcycles or trucks** (motorcycles stop faster than cars; trucks block view ahead)
- **Driver fatigue or stress**
- **Slippery surfaces** (gravel, snow, ice, loose stones)

### Following Distance for Heavy Vehicles

If you drive a truck, bus, or heavy vehicle, always use the **three-second rule as your minimum**, even in good weather. Heavy vehicles require longer stopping distances.

### What Distance Is "Two Seconds" in Meters?

As a rough guide:
- At 50 km/h: 2 seconds = approximately 28 meters (about 4 car lengths)
- At 80 km/h: 2 seconds = approximately 44 meters (about 7 car lengths)
- At 110 km/h: 2 seconds = approximately 61 meters (about 10 car lengths)

### Stopping Distance Relationship
At 45 km/h, a small car needs a distance longer than **six times its own length** to stop completely.

**Real-world scenario:** You are driving at 90 km/h on a divided highway in light rain. You apply the three-second rule for safety. Suddenly, the vehicle ahead brakes hard and stops for a stalled car. Your three-second gap gives you enough time to react and stop safely. If you had followed at one second, you would crash.

## Section 4: Stopping and Parking Rules

### Definitions

- **Stopping (Tawaqquf):** Temporarily stopping for traffic reasons (red light, stop sign, congestion), boarding or alighting passengers, or loading/unloading goods. Brief and driver remains in vehicle.
- **Parking (Wuquf):** Leaving the vehicle stationary for any non-temporary reason. Driver may exit the vehicle.

### Where Parking AND Stopping Are Prohibited

| Location | Why Prohibited |
|----------|----------------|
| On pedestrian crosswalks or sidewalks | Blocks pedestrian access |
| On bicycle lanes | Endangers cyclists |
| On railway tracks or too close to them | Train collision risk |
| On bridges, tunnels, or overpasses (unless designated parking areas) | Blocks traffic; collision risk |
| Within 15 meters of an intersection, curve, or hill crest | Blocks visibility for other drivers |
| Double parking (parallel next to a parked car) | Blocks traffic lane |
| Within 10 meters before or after a pedestrian crossing | Blocks view of crossing pedestrians |
| In a roundabout | Extremely dangerous |
| On driveways of public/private parking entrances | Blocks access |

[Insert image showing prohibited parking zones marked]

### Parallel Parking Procedure

Parallel parking is a required skill for the practical driving test.

**Step-by-step:**
1. Signal your intention and position your vehicle parallel to the front vehicle, approximately 0.5 meters (1.5 feet) away from it.
2. Check mirrors and blind spot for approaching traffic. Wait for a gap.
3. Turn steering wheel fully toward the curb (right in Jordan).
4. Reverse slowly. Watch your right mirror to see the curb and the rear vehicle.
5. When your front bumper passes the rear bumper of the front vehicle (or when you are at approximately a 45-degree angle), turn steering wheel fully away from the curb (left).
6. Continue reversing until your vehicle is close to the rear vehicle (about 0.5 meters gap).
7. Turn steering wheel back toward the curb (right) to straighten your wheels and center your vehicle between the two vehicles.
8. Adjust forward or backward as needed to center the vehicle.

[Insert diagram showing parallel parking stages 1-5]

## Section 5: Emergency Stoppage (Breakdown)

### If Your Vehicle Breaks Down

1. **Move off the road** as soon as safely possible. Use momentum if the engine has died.
2. **Choose a safe spot** - away from curves, hill crests, or intersections.
3. **Turn on hazard lights** (four-way flashers) immediately.
4. **Place the reflective triangle:**
   - On rural roads: At least **100 meters before** your vehicle (not after)
   - On urban roads: At least **50 meters before** your vehicle
   - On curves: Place the triangle before the curve so approaching drivers see it in advance
5. **At night or low visibility:** Keep parking lights on in addition to hazard lights.
6. **Do NOT stand between your vehicle and oncoming traffic.** Stand behind a barrier or well off the road.
7. **Call for help** using your mobile phone or emergency roadside telephone.

### If You Have a Disability or Cannot Exit Safely

- Stay inside your vehicle with seatbelt fastened
- Keep hazard lights on
- Display a "help" sign in your window if available
- Call for assistance using your phone
- Wait for help to arrive

### Reflective Triangle Requirements

- Equilateral triangle shape
- Minimum side length: 45 cm (18 inches)
- Reflective material on surface
- Must be placed on the road surface or on a stand at road level

[Insert picture of reflective warning triangle placed correctly on road shoulder]

### Vehicles Prohibited from Overnight Parking Inside Residential Areas

- Vehicles over 7.5 tons gross weight (large trucks, heavy buses)
- Agricultural and construction vehicles (tractors, excavators, bulldozers) on main residential streets

These vehicles may be permitted in designated truck parking areas or industrial zones.

## Section 6: Emergency Braking Techniques

### For Vehicles Without ABS (Anti-lock Brakes)
- Apply brakes firmly but do **not** lock the wheels.
- If wheels lock (you hear screeching and lose steering), **pump the brakes** - release slightly and reapply.
- Cadence braking: Apply, release slightly, apply again rapidly.

### For Vehicles With ABS
- Apply brakes **firmly and continuously**.
- Do NOT pump the brakes - ABS pumps automatically.
- You may feel pulsing through the brake pedal - this is normal.
- Maintain steering control; ABS allows you to steer while braking hard.

### In Wet or Slippery Conditions
- Brake earlier and more gently than on dry roads.
- Increase following distance significantly.
- Avoid braking while turning - brake before entering curves.

**Real-world scenario:** A child runs into the street 30 meters ahead of you while you are traveling at 60 km/h. You have approximately 1.8 seconds to react and stop. At 60 km/h, your total stopping distance on dry pavement is approximately 45 meters - you will stop just in time. On wet pavement, stopping distance nearly doubles. Your speed must be lower in rain to stop safely for unexpected hazards.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (6, 'ar', N'# حدود السرعة ومسافة التتبع والتوقف الآمن

تعد إدارة السرعة ومسافات التتبع الآمنة من أهم العوامل الحاسمة في منع الاصطدامات. حتى لو لم تخالف أي قاعدة أخرى، فإن القيادة بسرعات مناسبة مع وجود مساحة كافية أمامك تمنع معظم حوادث الاصطدام.

## القسم الأول: فهم مسافة التوقف

مسافة التوقف الإجمالية = مسافة رد الفعل + مسافة الكبح

**مسافة رد الفعل:** المسافة التي تقطعها سيارتك من لحظة رؤية الخطر إلى لحظة استخدام الفرامل. بالنسبة للسائق المنبه، يكون وقت رد الفعل حوالي 0.75 إلى ثانية واحدة.

**مسافة الفرملة:** المسافة التي تقطعها سيارتك منذ استخدام الفرامل حتى التوقف التام. ويختلف هذا بشكل كبير حسب السرعة وظروف الطريق وجودة الإطارات وحالة الفرامل.

[أدخل رسمًا بيانيًا يوضح مسافة رد الفعل + مسافة الكبح = مسافة التوقف الإجمالية]

### مثال: مسافة التوقف بسرعات مختلفة (الطريق الجاف)

| السرعة | مسافة رد الفعل | مسافة الكبح | مسافة التوقف الإجمالية |
|-------|------------------|------------------|-----------------------|
| 30 كم/ساعة | 8 متر | 6 متر | 14 متر |
| 50 كم/ساعة | 14 متر | 17 متر | 31 متر |
| 70 كم/ساعة | 19 متر | 33 متر | 52 متر |
| 90 كم/ساعة | 25 متر | 55 متر | 80 متر |
| 110 كم/ساعة | 31 متر | 82 متر | 113 متر |

**الآثار الواقعية:** عند سرعة 110 كم/ساعة، تحتاج إلى أكثر من طول ملعب كرة قدم للتوقف. إذا تابعت عن كثب بهذه السرعة، فسوف تصطدم إذا توقفت السيارة أمامك فجأة.

## القسم الثاني: حدود السرعة في الأردن

### القواعد العامة
- لا تتجاوز الحد الأقصى للسرعة المعلنة.
- لا تقود السيارة بأقل من الحد الأدنى للسرعة إذا تم نشرها (عادةً على الطرق السريعة).
- يجب أن تكون السرعة مناسبة دائمًا **للظروف** - الطقس، وكثافة حركة المرور، وحالة سطح الطريق، وحمولة السيارة، والرؤية. قد تكون السرعة الآمنة أقل بكثير من الحد المعلن في الظروف السيئة.

### متى يجب تقليل السرعة إلى ما دون الحد الأقصى
- المناطق السكنية التي يلعب فيها الأطفال
- ضعف الرؤية (ضباب، أمطار غزيرة، ليل بدون إنارة الشوارع)
- بالقرب من المدارس أثناء أوقات التوصيل والتوصيل
- الاقتراب من ممرات المشاة
- المنحنيات والتلال والتقاطعات
- مناطق عبور الحيوانات (الأغنام والماعز والإبل)
- مناطق البناء أو العمل

### الطرق الحضرية (داخل حدود المدينة/البلدة)

| نوع الطريق | السيارات الخاصة والشاحنات الخفيفة (2 طن) | أتوبيسات وشاحنات ثقيلة |
|-----------|------------------------------------------------------||------|
| طرق مقسمة متعددة الحارات (أكثر من حارتين في كل اتجاه مع وسط) | 90 كم/ساعة | 80 كم/ساعة |
| طرق ذات اتجاهين غير مقسمة | 70 كم/ساعة | 70 كم/ساعة |
| بالقرب من المدارس والطرق المحلية/السكنية | 40 كم/ساعة | 40 كم/ساعة |

[أدخل صورة تقارن بين الطريق السريع المقسم والطريق غير المقسم]

### الطرق الريفية (خارج حدود المدينة/البلدة)

| نوع الطريق | السيارات الخاصة والشاحنات الخفيفة (2 طن) | مركبات أخرى |
|-----------|-----------------------------------------------------||----------------|
| طرق سريعة مقسمة متعددة الحارات | 110 كم/ساعة | 100 كم/ساعة |
| طرق ذات اتجاهين غير مقسمة | 110 كم/ساعة | 100 كم/ساعة |
| طرق ثانوية وزراعية | الحدود الدنيا كما نشرت | الحدود الدنيا كما نشرت |

### الحد الأدنى للسرعة
في حين أن القانون الأردني لا يحدد الحد الأدنى العالمي للسرعة، فإن القيادة ببطء غير معقول دون سبب (على سبيل المثال، القيادة بسرعة 40 كم / ساعة على طريق سريع بسرعة 90 كم / ساعة دون وجود مشكلة ميكانيكية أو مشكلة الطقس) تعتبر مخالفة مرورية تعيق تدفق حركة المرور وتخلق ظروف خطيرة.

### عقوبات السرعة (ملخص)

| تجاوز الحد | ضربة جزاء |
|-------------------|--------|
| أكثر من 50 كم/ساعة فوق الحد | الحبس من اسبوعين الى 3 اشهر او الغرامة 100 دينار وحجز الرخصة |
| 31-50 كم/ساعة فوق الحد | غرامة 30 دينار |
| 11-30 كم/ساعة فوق الحد | غرامة 20 دينار |

## القسم 3: قاعدة الثانيتين (المسافة التالية)

توفر قاعدة الثانيتين مسافة متابعة آمنة في الظروف الجيدة.

### كيفية تطبيق قاعدة الثانيتين

1. راقب مرور السيارة التي أمامك بجسم ثابت (لافتة، شجرة، جسر، علامات الطريق).
2. عندما تمر مؤخرة السيارة بالجسم، ابدأ العد: "واحد ألف،
ألف واثنان".
3. إذا وصلت إلى الهدف قبل الانتهاء من "ألف واثنين"، فأنت تتابع عن كثب. زيادة المسافة الخاصة بك وتكرار.

[أدخل صورة توضح طريقة حساب قاعدة الثانيتين]

### متى تستخدم ثلاث ثوان أو أكثر

طبّق **قاعدة الثلاث ثوانٍ** (أو أكبر) في هذه المواقف:

- **الطرق الرطبة** (المطر والمياه الراكدة)
- **حالة الإطار سيئة** (المداس مهترئ)
- **حالة الفرامل سيئة**
- **حمولة مركبة ثقيلة** (ركاب أو بضائع)
- **القيادة الليلية** (انخفاض الرؤية)
- **متابعة الدراجات النارية أو الشاحنات** (تتوقف الدراجات النارية بشكل أسرع من السيارات؛ فالشاحنات تحجب الرؤية أمامك)
- **تعب أو إجهاد السائق**
- **الأسطح الزلقة** (الحصى والثلج والجليد والأحجار السائبة)

### المسافة التالية للمركبات الثقيلة

إذا كنت تقود شاحنة أو حافلة أو مركبة ثقيلة، فاستخدم دائمًا **قاعدة الثلاث ثوانٍ كحد أدنى**، حتى في الطقس الجيد. تتطلب المركبات الثقيلة مسافات توقف أطول.

### ما هي المسافة "ثانيتين" بالأمتار؟

كدليل تقريبي:
- بسرعة 50 كم/ساعة: 2 ثانية = حوالي 28 مترًا (حوالي 4 أطوال سيارات)
- بسرعة 80 كم/ساعة: 2 ثانية = حوالي 44 مترًا (حوالي 7 أطوال للسيارة)
- بسرعة 110 كم/ساعة: 2 ثانية = حوالي 61 مترًا (حوالي 10 أطوال للسيارة)

### إيقاف العلاقة عن بعد
عند سرعة 45 كم/ساعة، تحتاج السيارة الصغيرة إلى مسافة أطول من **ستة أضعاف طولها** لتتوقف تمامًا.

**سيناريو من العالم الحقيقي:** أنت تقود بسرعة 90 كم/ساعة على طريق سريع مقسم تحت أمطار خفيفة. يمكنك تطبيق قاعدة الثلاث ثواني للسلامة. وفجأة، تضغط السيارة التي أمامك على المكابح بقوة وتتوقف أمام سيارة متوقفة. تمنحك فجوة الثلاث ثوانٍ وقتًا كافيًا للرد والتوقف بأمان. لو اتبعت في ثانية واحدة، سوف تصطدم.

## القسم الرابع: قواعد التوقف والوقوف

### التعاريف

- **التوقف (التوقف):** التوقف مؤقتًا لأسباب مرورية (الإشارة الحمراء، إشارة التوقف، الازدحام)، صعود أو إنزال الركاب، أو تحميل/تفريغ البضائع. موجز ويبقى السائق في السيارة.
- **الوقوف:** ترك المركبة متوقفة لأي سبب غير مؤقت. يمكن للسائق الخروج من السيارة.

### الأماكن التي يُحظر فيها ركن السيارة والتوقف

| الموقع | لماذا محظور |
|----------|----------------|
| على معابر المشاة أو الأرصفة | كتل وصول المشاة |
| على ممرات الدراجات | يعرض راكبي الدراجات للخطر |
| على خطوط السكك الحديدية أو قريبة جدًا منها | خطر تصادم القطارات |
| على الجسور أو الأنفاق أو الجسور (ما لم تكن هناك أماكن مخصصة لوقوف السيارات) | كتل حركة المرور. خطر الاصطدام |
| في حدود 15 مترًا من التقاطع أو المنحنى أو قمة التل | يحجب الرؤية للسائقين الآخرين |
| مواقف مزدوجة (موازية بجوار سيارة متوقفة) | كتل حارة المرور |
| في حدود 10 أمتار قبل أو بعد معبر المشاة | كتل عرض لعبور المشاة |
| في دوار | خطير للغاية |
| على ممرات مداخل مواقف السيارات العامة/الخاصة | كتل الوصول |

[أدخل صورة توضح المناطق المحظورة لوقوف السيارات]

### إجراءات وقوف السيارات الموازية

يعتبر ركن السيارة بشكل متوازي مهارة مطلوبة في اختبار القيادة العملي.

** خطوة بخطوة: **
1. قم بالإشارة إلى نيتك ووضع سيارتك بشكل موازٍ للمركبة الأمامية، على بعد حوالي 0.5 متر (1.5 قدم) منها.
2. التحقق من المرايا والنقطة العمياء للتأكد من اقتراب حركة المرور. انتظر الفجوة.
3. أدر عجلة القيادة بالكامل باتجاه الرصيف (في الأردن مباشرة).
4. قم بالرجوع للخلف ببطء. شاهد مرآتك اليمنى لترى الرصيف والمركبة الخلفية.
5. عندما يمر المصد الأمامي الخاص بك بالمصد الخلفي للمركبة الأمامية (أو عندما تكون بزاوية 45 درجة تقريبًا)، قم بإدارة عجلة القيادة بعيدًا تمامًا عن الرصيف (يسارًا).
6. استمر في الرجوع للخلف حتى تقترب سيارتك من السيارة الخلفية (مسافة حوالي 0.5 متر).
7. أدر عجلة القيادة للخلف باتجاه الرصيف (يمينًا) لتسوية عجلاتك ووضع سيارتك في المنتصف بين المركبتين.
8. اضبط للأمام أو للخلف حسب الحاجة لتوسيط السيارة.

[أدخل رسمًا بيانيًا يوضح مراحل ركن السيارة الموازية 1-5]

## القسم الخامس: التوقف الطارئ (الانهيار)

### إذا تعطلت سيارتك

1. **تحرك بعيدًا عن الطريق** في أسرع وقت ممكن بأمان. استخدم الزخم إذا
مات المحرك.
2. **اختر مكانًا آمنًا** - بعيدًا عن المنحنيات أو قمم التلال أو التقاطعات.
3. **قم بتشغيل أضواء الخطر** (الفلاشات الرباعية) على الفور.
4. **ضع المثلث العاكس:**
   - على الطرق الريفية: على الأقل **100 متر قبل** سيارتك (وليس بعدها)
   - على الطرق الحضرية: على الأقل **50 مترًا** قبل** سيارتك
   - على المنحنيات: ضع المثلث قبل المنحنى حتى يتمكن السائقون المقتربون من رؤيته مسبقًا
5. **في الليل أو انخفاض الرؤية:** احتفظ بأضواء التوقف مضاءة بالإضافة إلى أضواء الخطر.
6. ** لا تقف بين مركبتك وحركة المرور القادمة. ** قف خلف حاجز أو بعيدًا عن الطريق.
7. **اتصل بطلب المساعدة** باستخدام هاتفك المحمول أو هاتف الطوارئ الموجود على الطريق.

### إذا كنت تعاني من إعاقة أو لا تستطيع الخروج بأمان

- ابق داخل سيارتك مع ربط حزام الأمان
- إبقاء أضواء الخطر مضاءة
- اعرض علامة "مساعدة" في نافذتك إذا كانت متوفرة
- اتصل للحصول على المساعدة باستخدام هاتفك
- انتظر وصول المساعدة

### متطلبات المثلث العاكس

- شكل مثلث متساوي الأضلاع
- الحد الأدنى لطول الجانب: 45 سم (18 بوصة)
- مادة عاكسة على السطح
- يجب أن توضع على سطح الطريق أو على حامل على مستوى الطريق

[أدخل صورة لمثلث التحذير العاكس الموضوع بشكل صحيح على كتف الطريق]

### منع المركبات من الوقوف ليلاً داخل المناطق السكنية

- المركبات التي يزيد وزنها الإجمالي عن 7.5 طن (الشاحنات الكبيرة، الحافلات الثقيلة)
- المركبات الزراعية والإنشائية (جرارات، حفارات، جرافات) على الشوارع السكنية الرئيسية

قد يُسمح بهذه المركبات في مناطق وقوف الشاحنات المخصصة أو المناطق الصناعية.

## القسم 6: تقنيات الكبح في حالات الطوارئ

### للمركبات التي لا تحتوي على نظام ABS (الفرامل المانعة للانغلاق)
- استخدم الفرامل بقوة ولكن لا تقفل العجلات.
- إذا انغلقت العجلات (سمعت صريرًا وفقدت التوجيه)، **اضغط على المكابح** - حررها قليلًا ثم أعد تطبيقها.
- الكبح الإيقاعي: قم بالتطبيق، ثم حرر قليلاً، ثم قم بالتطبيق مرة أخرى بسرعة.

### للمركبات المزودة بنظام ABS
- استخدم المكابح **بثبات وبشكل مستمر**.
- لا تضغط على الفرامل - يعمل نظام ABS على الضخ تلقائيًا.
- قد تشعر بالنبض أثناء الضغط على دواسة الفرامل، وهذا أمر طبيعي.
- الحفاظ على التحكم في التوجيه؛ يسمح لك نظام ABS بالتوجيه أثناء الكبح بقوة.

### في الظروف الرطبة أو الزلقة
- قم بالفرملة مبكرًا وبلطف أكثر من الطرق الجافة.
- زيادة المسافة التالية بشكل ملحوظ.
- تجنب استخدام المكابح أثناء الانعطاف - استخدم المكابح قبل الدخول في المنحنيات.

**سيناريو من العالم الحقيقي:** يجري طفل في الشارع أمامك بمسافة 30 مترًا بينما تسير أنت بسرعة 60 كم/ساعة. لديك ما يقرب من 1.8 ثانية للرد والتوقف. عند سرعة 60 كم/ساعة، تبلغ مسافة التوقف الإجمالية على الرصيف الجاف حوالي 45 مترًا - ستتوقف في الوقت المناسب. على الرصيف الرطب، تتضاعف مسافة التوقف تقريبًا. يجب أن تكون سرعتك أقل أثناء هطول المطر حتى تتمكن من التوقف بأمان تحسبًا للمخاطر غير المتوقعة.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (7, 'en', N'# Alcohol, Drugs, Fatigue, and Safe Driving Fitness

Driving requires full physical and mental fitness. Any impairment - from alcohol, drugs, medications, fatigue, or distraction - dramatically increases crash risk. This module covers the effects, legal consequences, and safe practices.

## Section 1: Alcohol and Driving

### How Alcohol Impairs Driving

Alcohol affects the brain and body in ways directly dangerous to driving:

| Blood Alcohol Level | Effects on Driving |
|---------------------|---------------------|
| Very low (0.02%) | Reduced coordination, decreased ability to track moving objects, difficulty multitasking |
| Low (0.05%) | Reduced coordination, reduced ability to track moving objects, difficulty steering, reduced response to emergency situations |
| Moderate (0.08% - legal limit in many countries) | Poor muscle coordination, difficulty detecting hazards, impaired judgment, reduced concentration, short-term memory loss, poor speed control |
| High (0.10%+) | Slurred speech, poor coordination, slowed thinking, reduced ability to maintain lane position, significantly increased crash risk |

[Insert image showing progressive visual impairment at different BAC levels]

### Specific Driving Skills Affected by Alcohol

- **Reaction time:** Increases by 20-50% even at low levels. At 90 km/h, a 0.5-second delay adds 12.5 meters to stopping distance.
- **Judgment:** Impairs ability to judge distances, speeds, and gaps in traffic.
- **Vision:** Reduces peripheral vision (tunnel vision), decreases night vision, impairs depth perception.
- **Coordination:** Impairs fine motor control needed for steering, pedals, and gear shifting.
- **Concentration:** Makes it difficult to focus on multiple tasks (scanning, steering, speed control).

### Legal Consequences in Jordan

- Driving under the influence of alcohol is a **serious crime**, not just a traffic violation.
- If caught with any measurable alcohol in your system while driving, penalties may include:
  - Imprisonment
  - Heavy fines (hundreds to thousands of JD)
  - Long-term license suspension
  - Vehicle impoundment
- **Refusing a breathalyzer or blood test** may lead to immediate arrest and additional penalties.
- For causing death or injury while impaired, penalties include long prison sentences and permanent license revocation.

### Common Myths About Alcohol

| Myth | Reality |
|------|---------|
| "Coffee will sober me up" | Caffeine makes you feel more awake but does NOT reduce impairment or lower BAC |
| "I can drive after one drink" | One drink affects some people significantly; effects vary by weight, gender, food intake |
| "Eating soaks up alcohol" | Food slows absorption but does not reduce total BAC or impairment |
| "Time is the only cure" | TRUE. Only time lowers BAC. One hour per standard drink on average. |

**Real-world scenario:** You have two beers with dinner over two hours, feel "fine," and decide to drive. Your BAC may still be above legal limits depending on your body weight and gender. You are stopped at a checkpoint and fail the breathalyzer. You face arrest, court appearance, fines, license suspension, and a criminal record. The safest choice: designate a sober driver or use a taxi/ride service.

## Section 2: Drugs and Narcotics

### Illegal Drugs
- Any non-alcoholic narcotic substance (cannabis, cocaine, opioids, amphetamines, etc.) severely impairs driving.
- **Effects include:**
  - Increased risk-taking and reckless behavior
  - Greatly reduced awareness of hazards
  - Poor decision-making and judgment
  - Significantly slower reflexes
  - Hallucinations or altered perception (some drugs)
  - Drowsiness or sudden loss of consciousness (some drugs)

### Legal Consequences
- Driving under the influence of any illegal drug is strictly prohibited.
- Penalties are similar to or more severe than alcohol violations.
- Drug-impaired driving causing death or injury carries enhanced penalties.

## Section 3: Medications That Affect Driving

Many legal over-the-counter and prescription medications can impair driving ability as much as alcohol.

### Common Medications with Driving Warnings

| Medication Type | Examples | Potential Effects |
|-----------------|----------|-------------------|
| Antihistamines (allergy) | Diphenhydramine (Benadryl), cetirizine (Zyrtec) | Drowsiness, dizziness, slowed reaction time |
| Sleep aids (prescription and OTC) | Zolpidem (Ambien), diphenhydramine | Drowsiness, morning grogginess |
| Anxiety medications | Benzodiazepines (Xanax, Valium) | Drowsiness, impaired coordination, confusion |
| Some antidepressants | Certain SSRIs, tricyclics | Drowsiness, blurred vision, dizziness |
| Some pain relievers | Opioids (codeine, tramadol, oxycodone) | Drowsiness, euphoria, impaired judgment, slowed breathing |
| Blood pressure medications | Beta-blockers, some diuretics | Dizziness, fatigue, blurred vision |
| Muscle relaxants | Cyclobenzaprine (Flexeril) | Drowsiness, weakness, dizziness |
| Cold and flu medications | Multi-symptom formulas often contain antihistamines or cough suppressants | Drowsiness, dizziness, impaired coordination |
| Anti-nausea medications | Promethazine (Phenergan), dimenhydrinate (Dramamine) | Drowsiness, blurred vision |

### What to Do

1. **Read warning labels** on all medications. Look for phrases like:
   - "May cause drowsiness"
   - "Do not operate heavy machinery"
   - "Avoid driving until you know how this medication affects you"
   - "Use caution when driving"

2. **If the label warns against driving: DO NOT DRIVE** while taking that medication, especially during the first few days or when dosage changes.

3. **Consult your doctor or pharmacist** before driving while on any medication. Ask specifically: "Is it safe for me to drive while taking this?"

4. **Monitor yourself** even with medications that do not carry warnings. If you feel drowsy, dizzy, or "different" after taking any medication, do not drive.

**Real-world scenario:** You have a cold and take an over-the-counter nighttime cold medication that contains an antihistamine. The label says "may cause marked drowsiness." You take it at 10 PM and plan to drive to work at 7 AM. The medication can still affect you for 8-12 hours. You wake up feeling groggy but think you are fine. On the road, your reaction time is slowed, and you fail to stop in time for a red light. You cause a crash. Wait 12+ hours or find alternative transportation.

## Section 4: Driver Fatigue

Fatigue is as dangerous as alcohol impairment. Studies show being awake for 18 hours produces impairment equivalent to a BAC of 0.05%, and 24 hours awake equals 0.10% BAC.

### Why Fatigue Is Dangerous

- Fatigue reduces reaction time similarly to alcohol
- You may experience **micro-sleeps** (2-5 seconds of sleep with eyes open) without realizing it. At 90 km/h, a 4-second micro-sleep covers 100 meters of uncontrolled driving
- Accident risk increases significantly at night (especially 2 AM-6 AM) and on long trips (after 2+ hours of continuous driving)

### Signs of Fatigue (If You Experience Any, STOP Driving)

- Frequent yawning
- Heavy eyelids or blinking more than usual
- Difficulty keeping your head up
- Drifting out of your lane or hitting rumble strips
- Missing traffic signs or exits
- Not remembering the last few kilometers driven
- Feeling restless or irritable
- Slow reactions to changing traffic conditions

[Insert image showing driver exhibiting signs of fatigue]

### How to Prevent Fatigue

**Before driving:**
- Get adequate sleep - 7-8 hours recommended before long drives
- Avoid driving during your normal sleeping hours
- Avoid heavy meals before driving (digestion causes drowsiness)
- Avoid alcohol the night before long drives

**During driving:**
- Take a break every **2 hours or 150-200 km** - whichever comes first
- Stop at a safe rest area, service station, or parking area (not on the shoulder)
- Get out of the vehicle, stretch, walk around for 10-15 minutes
- If very tired: Take a **short nap (15-20 minutes)** before driving again. A 20-minute nap restores alertness for 2-3 hours.
- Drink water - dehydration increases fatigue
- Drive with a passenger who can share driving or keep you alert

**What does NOT work for fatigue:**
- Loud music
- Opening windows
- Slapping your face
- Drinking coffee (caffeine takes 30 minutes to work and does not replace sleep)

**Real-world scenario:** You are driving back from a weekend trip at 3 AM, two hours from home. You notice you are yawning and struggling to keep your eyes focused. Instead of pushing through, you stop at the next rest area. You nap for 20 minutes, drink water, and stretch. You complete the drive safely. That decision may have saved your life.

## Section 5: Concentration and Distractions

### Common Driving Distractions to Avoid

| Distraction Type | Examples |
|------------------|----------|
| Mobile phone use | Talking without hands-free (illegal in Jordan), texting, checking notifications, using apps |
| Eating/drinking | Unwrapping food, holding a drink, eating with one hand |
| Vehicle controls | Adjusting radio, GPS, or climate controls while in complex traffic |
| Passengers | Turning to talk to rear-seat passengers, arguing, dealing with children |
| Grooming | Applying makeup, shaving, combing hair |
| Reaching | Picking up dropped items from the floor or back seat |
| External distractions | Looking at crashes, billboards, scenery for too long |

### Safe Practices

1. **Set up before moving:** Adjust seat, mirrors, steering wheel, climate controls, GPS destination, and music before shifting into gear.

2. **Secure loose objects:** Phones, sunglasses, bags, and other items should be secured so they do not roll or slide.

3. **Passenger management:** Ask passengers to keep noise at a reasonable level. Deal with children''s needs before driving or pull over to address them.

4. **Phone policy:** Pull over to a safe location to use your phone. Even hands-free conversations are distracting - keep them short and simple.

5. **Eat before or after:** Do not eat while driving. If you must eat on a long trip, stop at a rest area.

### Nighttime Concentration Challenges

- Vision is reduced by **50-70%** at night compared to daylight.
- Glare from oncoming high beams temporarily blinds you and takes seconds to recover.
- **If an oncoming vehicle uses high beams:**
  - Slow down
  - Look to the right edge of your road (not at the lights)
  - Keep right in your lane
  - Do not flash your high beams back (escalates conflict)

### Driving in High Heat/Strong Sun

- Heat causes dehydration, headache, nausea, anxiety, and fatigue
- Use sunglasses to reduce glare (polarized lenses are best)
- Use your vehicle''s sun visor
- Monitor engine temperature gauge
- Keep air conditioning or ventilation on
- Reduce speed slightly and increase following distance (heat affects braking and tire grip)

## Section 6: Quick Fitness-to-Drive Checklist

**Before every drive, ask yourself:**

- [ ] Have I consumed any alcohol in the past 6-8 hours?
- [ ] Have I taken any medication that causes drowsiness or dizziness?
- [ ] Have I used any illegal or recreational drugs?
- [ ] Am I feeling tired or sleepy?
- [ ] Am I emotionally upset (angry, very sad, extremely excited)?
- [ ] Do I have any physical symptoms (fever, severe pain, dizziness)?

**If you answer YES to any: DO NOT DRIVE.**

**Real-world scenario:** You argued with your boss before leaving work. You are angry and distracted. You get behind the wheel. Your anger causes you to drive more aggressively - tailgating, speeding, running a yellow light. You cause a crash. Pull over, take 10 minutes to calm down, and only drive when you are emotionally ready to focus safely.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (7, 'ar', N'# الكحول والمخدرات والتعب ولياقة القيادة الآمنة

تتطلب القيادة لياقة بدنية وعقلية كاملة. أي ضعف - بسبب الكحول أو المخدرات أو الأدوية أو التعب أو الإلهاء - يزيد بشكل كبير من خطر الاصطدام. تغطي هذه الوحدة الآثار والعواقب القانونية والممارسات الآمنة.

## القسم 1: الكحول والقيادة

### كيف يعوق الكحول القيادة

يؤثر الكحول على الدماغ والجسم بطرق تشكل خطورة مباشرة على القيادة:

| مستوى الكحول في الدم | التأثيرات على القيادة |
|---------------------|---------------------|
| منخفضة جداً (0.02%) | انخفاض التنسيق، وانخفاض القدرة على تتبع الأجسام المتحركة، وصعوبة تعدد المهام |
| منخفض (0.05%) | انخفاض التنسيق، انخفاض القدرة على تتبع الأجسام المتحركة، صعوبة التوجيه، انخفاض الاستجابة لحالات الطوارئ |
| معتدل (0.08% - الحد القانوني في العديد من البلدان) | ضعف التنسيق العضلي، صعوبة اكتشاف المخاطر، ضعف الحكم، انخفاض التركيز، فقدان الذاكرة على المدى القصير، ضعف التحكم في السرعة |
| عالي (0.10%+) | تلعثم في الكلام، وضعف التنسيق، وبطء التفكير، وانخفاض القدرة على الحفاظ على وضع المسار، وزيادة خطر الاصطدام بشكل ملحوظ |

[أدخل صورة توضح ضعف البصر التدريجي عند مستويات مختلفة من BAC]

### مهارات القيادة المحددة المتأثرة بالكحول

- **زمن رد الفعل:** يزداد بنسبة 20-50% حتى عند المستويات المنخفضة. وعند السرعة 90 كم/ساعة، فإن التأخير لمدة 0.5 ثانية يضيف 12.5 مترًا إلى مسافة التوقف.
- **الحكم:** يضعف القدرة على تقدير المسافات والسرعات والفجوات في حركة المرور.
- **الرؤية:** تقلل الرؤية المحيطية (الرؤية النفقية)، وتقلل الرؤية الليلية، وتضعف إدراك العمق.
- **التنسيق:** يعوق التحكم الدقيق في المحركات اللازمة للتوجيه والدواسات وتبديل التروس.
- **التركيز:** يجعل من الصعب التركيز على مهام متعددة (المسح، التوجيه، التحكم في السرعة).

### العواقب القانونية في الأردن

- تعتبر القيادة تحت تأثير الكحول **جريمة خطيرة**، وليست مجرد مخالفة مرورية.
- إذا تم ضبط أي كحول قابل للقياس في نظامك أثناء القيادة، فقد تشمل العقوبات ما يلي:
  - السجن
  - غرامات باهظة (مئات إلى آلاف الدنانير)
  - تعليق الترخيص لفترة طويلة
  - حجز المركبة
- **قد يؤدي رفض اختبار الكحول أو فحص الدم** إلى الاعتقال الفوري وعقوبات إضافية.
- للتسبب في الوفاة أو الإصابة أثناء الإعاقة، تشمل العقوبات أحكامًا بالسجن لفترات طويلة وإلغاء الترخيص بشكل دائم.

### الخرافات الشائعة حول الكحول

| الأسطورة | الواقع |
|------|---------|
| "القهوة سوف توقظني" | يجعلك الكافيين تشعر بمزيد من اليقظة ولكنه لا يقلل من ضعف أو انخفاض مستوى BAC |
| "أستطيع أن أقود السيارة بعد تناول مشروب واحد" | يؤثر المشروب الواحد على بعض الأشخاص بشكل ملحوظ؛ تختلف التأثيرات حسب الوزن والجنس وتناول الطعام |
| "الأكل يمتص الخمر" | يبطئ الطعام الامتصاص ولكنه لا يقلل من إجمالي BAC أو ضعفه |
| "الوقت هو العلاج الوحيد" | حقيقي. الوقت فقط يخفض نسبة BAC. ساعة واحدة لكل مشروب قياسي في المتوسط. |

**سيناريو من العالم الحقيقي:** تناولت كأسين من البيرة مع العشاء لمدة ساعتين، وتشعر بأنك "بحالة جيدة"، وتقرر القيادة. قد لا يزال مستوى BAC الخاص بك أعلى من الحدود القانونية اعتمادًا على وزن جسمك وجنسك. لقد تم إيقافك عند نقطة تفتيش وفشل جهاز فحص الكحول. ستواجه الاعتقال والمثول أمام المحكمة والغرامات وتعليق الترخيص والسجل الجنائي. الخيار الأكثر أمانًا: تعيين سائق رصين أو استخدام خدمة سيارات الأجرة/الركوب.

## القسم الثاني: المخدرات والمخدرات

### المخدرات غير المشروعة
- أي مادة مخدرة غير كحولية (الحشيش، الكوكايين، المواد الأفيونية، الأمفيتامينات وغيرها) تضعف القيادة بشدة.
- **تشمل التأثيرات:**
  - زيادة المخاطرة والسلوك المتهور
  - انخفاض كبير في الوعي بالمخاطر
  - سوء اتخاذ القرار والحكم
  - ردود أفعال أبطأ بشكل ملحوظ
  - الهلوسة أو تغير في الإدراك (بعض الأدوية).
  - النعاس أو فقدان الوعي المفاجئ (بعض الأدوية).

### العواقب القانونية
- يمنع منعا باتا القيادة تحت تأثير أي مخدرات غير مشروعة.
- العقوبات مشابهة أو أشد من مخالفات الكحول.
- القيادة تحت تأثير المخدرات والتي تسبب الوفاة أو الإصابة تحمل عقوبات مشددة.

## القسم الثالث: الأدوية التي تؤثر على القيادة

كثير
يمكن للأدوية القانونية التي لا تستلزم وصفة طبية أن تضعف القدرة على القيادة مثل الكحول.

### الأدوية الشائعة مع تحذيرات القيادة

| نوع الدواء | أمثلة | التأثيرات المحتملة |
|-----------------|----------|------------------|---------|
| مضادات الهيستامين (الحساسية) | ديفينهيدرامين (بينادريل)، سيتريزين (زيرتيك) | نعاس، دوخة، تباطؤ وقت رد الفعل |
| مساعدات النوم (وصفة طبية وOTC) | زولبيديم (أمبين)، ديفينهيدرامين | النعاس والترنح الصباحي |
| أدوية القلق | البنزوديازيبينات (زاناكس، الفاليوم) | نعاس، ضعف التنسيق، ارتباك |
| بعض مضادات الاكتئاب | بعض مثبطات استرداد السيروتونين الانتقائية، ثلاثية الحلقات | نعاس، عدم وضوح الرؤية، دوخة |
| بعض مسكنات الألم | المواد الأفيونية (الكودايين، الترامادول، أوكسيكودون) | النعاس، النشوة، ضعف الحكم، تباطؤ التنفس |
| أدوية ضغط الدم | حاصرات بيتا وبعض مدرات البول | دوخة، تعب، عدم وضوح الرؤية |
| مرخيات العضلات | سيكلوبنزابرين (فليكسيريل) | النعاس والضعف والدوخة |
| أدوية البرد والانفلونزا | غالبًا ما تحتوي التركيبات متعددة الأعراض على مضادات الهيستامين أو مثبطات السعال | نعاس، دوخة، ضعف التنسيق |
| أدوية مضادة للغثيان | بروميثازين (فينيرجان)، ديمينهيدرينات (درامامين) | النعاس وعدم وضوح الرؤية |

### ماذا تفعل

1. **اقرأ الملصقات التحذيرية** على جميع الأدوية. ابحث عن عبارات مثل:
   - "قد يسبب النعاس"
   - "لا تشغل الآلات الثقيلة"
   - "تجنب القيادة حتى تعرف مدى تأثير هذا الدواء عليك"
   - "توخى الحذر أثناء القيادة"

2. **إذا كان الملصق يحذر من القيادة: لا تقود السيارة** أثناء تناول هذا الدواء، خاصة خلال الأيام القليلة الأولى أو عند تغيير الجرعة.

3. **استشر طبيبك أو الصيدلي** قبل القيادة أثناء تناول أي دواء. اسأل على وجه التحديد: "هل من الآمن بالنسبة لي القيادة أثناء تناول هذا الدواء؟"

4. **راقب نفسك** حتى مع الأدوية التي لا تحمل تحذيرات. إذا شعرت بالنعاس أو الدوار أو "الاختلاف" بعد تناول أي دواء، فلا تقود السيارة.

**سيناريو من العالم الحقيقي:** أنت مصاب بنزلة برد وتتناول دواء نزلات البرد الليلي الذي لا يستلزم وصفة طبية والذي يحتوي على مضاد للهستامين. الملصق يقول "قد يسبب نعاسًا ملحوظًا". تأخذها في الساعة 10 مساءً وتخطط للقيادة إلى العمل في الساعة 7 صباحًا. يمكن أن يستمر تأثير الدواء عليك لمدة 8-12 ساعة. تستيقظ وأنت تشعر بالترنح ولكنك تعتقد أنك بخير. على الطريق، يتباطأ وقت رد فعلك، وتفشل في التوقف في الوقت المناسب للحصول على الضوء الأحمر. أنت تسبب حادث. انتظر أكثر من 12 ساعة أو ابحث عن وسيلة نقل بديلة.

## القسم الرابع: تعب السائق

التعب خطير مثل ضعف الكحول. تشير الدراسات إلى أن البقاء مستيقظًا لمدة 18 ساعة يؤدي إلى انخفاض يعادل نسبة BAC بنسبة 0.05%، والاستيقاظ لمدة 24 ساعة يساوي 0.10% من نسبة BAC.

### لماذا يعتبر الإرهاق خطيرًا؟

- التعب يقلل من وقت رد الفعل على غرار الكحول
- قد تواجه **فترات نوم قصيرة** (من 2 إلى 5 ثوانٍ من النوم وعيناك مفتوحتان) دون أن تدرك ذلك. عند سرعة 90 كم/ساعة، يغطي النوم الصغير لمدة 4 ثوانٍ مسافة 100 متر من القيادة غير المنضبطة
- يزداد خطر وقوع الحوادث بشكل كبير في الليل (خاصة من الساعة 2 صباحًا حتى 6 صباحًا) وفي الرحلات الطويلة (بعد أكثر من ساعتين من القيادة المتواصلة)

### علامات التعب (إذا شعرت بأي منها، توقف عن القيادة)

- التثاؤب المتكرر
- ثقل الجفون أو الرمش أكثر من المعتاد
- صعوبة في إبقاء رأسك مرفوعاً
- الانجراف خارج المسار الخاص بك أو ضرب شرائط الدمدمة
- عدم وجود إشارات مرورية أو مخارج
- عدم تذكر الكيلومترات القليلة الماضية التي قطعتها
- الشعور بعدم الراحة أو الانفعال
- ردود أفعال بطيئة تجاه الظروف المرورية المتغيرة

[أدخل صورة تظهر على السائق علامات الإرهاق]

### كيفية منع التعب

**قبل القيادة:**
- احصل على قسط كافٍ من النوم - يوصى به قبل 7 إلى 8 ساعات من القيادة الطويلة
- تجنب القيادة أثناء ساعات نومك الطبيعية
- تجنب الوجبات الثقيلة قبل القيادة (الهضم يسبب النعاس)
- تجنب الكحول في الليلة التي تسبق القيادة لمسافات طويلة

**أثناء القيادة:**
- خذ قسطًا من الراحة كل **ساعتين أو 150-200 كيلومتر** - أيهما يأتي أولاً
- توقف عند منطقة استراحة آمنة أو محطة خدمة أو منطقة وقوف السيارات (وليس على الكتف)
- اخرج من السيارة، تمدد، تجول لمدة 10-15 دقيقة
- إذا جدا
متعب: خذ **قيلولة قصيرة (15-20 دقيقة)** قبل القيادة مرة أخرى. قيلولة لمدة 20 دقيقة تعيد اليقظة لمدة 2-3 ساعات.
- شرب الماء - فالجفاف يزيد التعب
- قم بالقيادة مع أحد الركاب الذي يمكنه مشاركة القيادة أو إبقائك في حالة تأهب

**ما لا ينفع من التعب:**
- الموسيقى الصاخبة
- فتح النوافذ
- الصفع وجهك
- شرب القهوة (الكافيين يستغرق 30 دقيقة للعمل ولا يحل محل النوم)

**السيناريو الواقعي:** أنت تعود بالسيارة من رحلة عطلة نهاية الأسبوع في الساعة 3 صباحًا، على بعد ساعتين من المنزل. لاحظت أنك تتثاءب وتكافح من أجل الحفاظ على تركيز عينيك. بدلاً من المضي قدمًا، تتوقف عند منطقة الراحة التالية. تغفو لمدة 20 دقيقة، وتشرب الماء، وتمارس تمارين التمدد. أكملت القيادة بأمان. ربما يكون هذا القرار قد أنقذ حياتك.

## القسم 5: التركيز والتشتت

### عوامل تشتيت الانتباه الشائعة أثناء القيادة والتي يجب تجنبها

| نوع الهاء | أمثلة |
|------------------|---------|
| استخدام الهاتف المحمول | التحدث بدون استخدام اليدين (غير قانوني في الأردن)، إرسال الرسائل النصية، التحقق من الإشعارات، استخدام التطبيقات |
| الأكل والشرب | فك تغليف الطعام، وإمساك الشراب، والأكل بيد واحدة |
| ضوابط السيارة | ضبط أجهزة التحكم في الراديو أو نظام تحديد المواقع العالمي (GPS) أو المناخ أثناء وجود حركة مرور معقدة |
| الركاب | اللجوء للتحدث مع ركاب المقاعد الخلفية، والجدال، والتعامل مع الأطفال |
| الاستمالة | وضع المكياج والحلاقة وتمشيط الشعر |
| الوصول | التقاط الأشياء المتساقطة من الأرض أو المقعد الخلفي |
| الانحرافات الخارجية | النظر إلى الأعطال واللوحات الإعلانية والمناظر الطبيعية لفترة طويلة |

### الممارسات الآمنة

1. **الإعداد قبل التحرك:** اضبط المقعد والمرايا وعجلة القيادة وأدوات التحكم في المناخ ووجهة نظام تحديد المواقع العالمي (GPS) والموسيقى قبل التبديل إلى السرعة.

2. **تأمين الأشياء السائبة:** يجب تأمين الهواتف والنظارات الشمسية والحقائب وغيرها من العناصر بحيث لا تتدحرج أو تنزلق.

3. **إدارة الركاب:** اطلب من الركاب إبقاء الضوضاء عند مستوى معقول. تعامل مع احتياجات الأطفال قبل القيادة أو التوقف لتلبيتها.

4. **سياسة الهاتف:** انتقل إلى مكان آمن لاستخدام هاتفك. حتى المحادثات بدون استخدام اليدين قد تشتت الانتباه - اجعلها قصيرة وبسيطة.

5. **تناول الطعام قبل أو بعد:** لا تأكل أثناء القيادة. إذا كان عليك تناول الطعام أثناء رحلة طويلة، توقف عند منطقة الاستراحة.

### تحديات التركيز الليلي

- تقل الرؤية بنسبة **50-70%** في الليل مقارنة بضوء النهار.
- الوهج الصادر من الأضواء العالية القادمة يصيبك بالعمى مؤقتًا ويستغرق ثوانٍ للتعافي.
- **إذا كانت هناك مركبة قادمة تستخدم الضوء العالي:**
  - ابطئ
  - انظر إلى الحافة اليمنى من طريقك (وليس عند الأضواء)
  - حافظ على حقك في مسارك
  - لا تعيد إضاءة الأضواء العالية (يؤدي ذلك إلى تفاقم الصراع)

### القيادة في درجات حرارة عالية/شمس قوية

- الحرارة تسبب الجفاف والصداع والغثيان والقلق والتعب
- استخدم النظارات الشمسية لتقليل الوهج (العدسات المستقطبة هي الأفضل)
- استخدم حاجب الشمس الخاص بسيارتك
- مراقبة مقياس درجة حرارة المحرك
- استمر في تشغيل مكيف الهواء أو التهوية
- خفف السرعة قليلاً وقم بزيادة مسافة التتبع (تؤثر الحرارة على المكابح وتماسك الإطارات)

## القسم 6: قائمة التحقق السريعة من اللياقة البدنية للقيادة

**قبل كل رحلة اسأل نفسك:**

- [ ] هل تناولت أي كحول خلال الـ 6-8 ساعات الماضية؟
- [ ] هل تناولت أي دواء يسبب النعاس أو الدوخة؟
- [ ] هل استخدمت أي مخدرات غير قانونية أو ترفيهية؟
- [ ] هل أشعر بالتعب أو النعاس؟
- [ ] هل أنا منزعج عاطفيا (غاضب، حزين جدا، متحمس للغاية)؟
- [ ] هل أعاني من أي أعراض جسدية (حمى، ألم شديد، دوخة)؟

**إذا أجبت بنعم على أي سؤال: لا تقود السيارة.**

**سيناريو من العالم الحقيقي:** لقد تشاجرت مع رئيسك في العمل قبل مغادرة العمل. أنت غاضب ومشتت. أنت تجلس خلف عجلة القيادة. إن غضبك يدفعك إلى القيادة بشكل أكثر عدوانية - التتبع، والسرعة، والتجاوز في الإشارة الصفراء. أنت تسبب حادث. توقف جانبًا، وخذ 10 دقائق لتهدأ، ولا تقود السيارة إلا عندما تكون مستعدًا عاطفيًا للتركيز بأمان.');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (8, 'en', N'# Difficult Driving Conditions - Night, Weather, and Emergencies

Driving becomes significantly more dangerous in adverse conditions. Crash rates double or triple at night, in rain, or in fog. This module teaches you how to adapt your driving to stay safe.

## Section 1: Night Driving

### The Statistics
- Accident rate **doubles** at night compared to daytime.
- At speeds over 110 km/h, the night crash rate increases **six times**.
- Most night crashes occur between midnight and 6 AM, especially 2 AM-4 AM.

### Vision Limitations at Night
- Depth perception is reduced
- Peripheral vision narrows
- Color recognition decreases (red looks black, green looks gray)
- Glare recovery takes longer (5-10 seconds after bright lights)
- Overall vision is reduced by 50-70%

### Night Driving Safety Checklist

**Before driving:**
- Ensure all lights work: headlights (high and low beam), taillights, brake lights, turn signals, hazard lights
- Clean headlights, taillights, and windows (inside and out)
- Aim headlights properly (ask a mechanic if unsure)
- Check that reflective markers and license plates are clean and visible

**During driving:**
- Use **low beams** inside cities and on well-lit roads
- Use **high beams** on dark rural roads with no oncoming traffic
- **Dim high beams** when:
  - A vehicle is less than 200 meters ahead of you in your direction
  - A vehicle approaches from the opposite direction (dim at least 150 meters before meeting)
- Reduce speed - your effective sight distance is shorter than your stopping distance
- Increase following distance to 3-4 seconds minimum
- Be extra cautious at intersections (other drivers may not see you)
- Watch for pedestrians, cyclists, and animals (harder to see at night)

### Managing Glare

**From oncoming high beams:**
- Slow down
- Look to the right edge of the road (use the right line or shoulder as a guide)
- Do not stare at the lights
- Keep right in your lane
- Do not flash your high beams back (this creates danger for both of you)

**From high beams behind you:**
- Adjust your rearview mirror to night mode (flip the tab)
- Slow down and let the vehicle pass
- Do not brake-check the driver

[Insert image showing night mode mirror adjustment]

**Real-world scenario:** You are driving on a dark rural road at 90 km/h with high beams on. You see headlights approaching on a curve. You dim your lights 150 meters before meeting. The oncoming driver does not dim theirs. You look to the right edge of the road, slow to 70 km/h, and stay in your lane. After passing, you return to normal speed and high beams. This safe response prevents temporary blindness and a potential crash.

## Section 2: Fog Driving

Fog is one of the most dangerous conditions because it dramatically reduces visibility and creates optical illusions.

### Fog Types and Visibility
- Light fog: 200-400 meters visibility - reduce speed moderately
- Moderate fog: 100-200 meters visibility - reduce speed significantly
- Dense fog: 50-100 meters visibility - drive very slowly, consider pulling over
- Thick fog: Under 50 meters visibility - pull off the road safely

### Fog Driving Rules

1. **Use low beam headlights** - NOT high beams. High beams reflect off fog droplets and create a white wall, reducing visibility further.

2. **Use fog lights** if your vehicle has them - but only in fog or heavy rain/snow. Do not use fog lights in clear conditions (they blind other drivers).

3. **Reduce speed dramatically.** As a guide:
   - 200m visibility: maximum 50 km/h
   - 100m visibility: maximum 30 km/h
   - 50m visibility: maximum 15 km/h

4. **Increase following distance to 5+ seconds** - you may not see brake lights until very close.

5. **Use the right edge line as a guide** - follow the white or reflective markers on the right side.

6. **Do not stop in travel lanes** - if visibility drops to near zero, carefully pull off the road completely, turn on hazard lights, and wait for conditions to improve.

7. **Watch for vehicles that have stopped ahead** - fog can hide stopped vehicles until you are very close.

[Insert image of foggy road showing reduced visibility and proper headlight use]

**Real-world scenario:** You enter a fog bank on a highway. Visibility drops to 50 meters. You reduce speed to 20 km/h, use low beams and fog lights, and follow the right edge line. You see taillights ahead - a chain of cars moving at 15 km/h. You maintain a 5-second gap. After 20 minutes, the fog clears. You avoided a multi-car pileup that happened 1 km ahead where drivers had been speeding.

## Section 3: Rain and Wet Roads

Rain reduces tire grip (traction) and increases stopping distances significantly.

### Traction Loss in Rain

| Condition | Traction Compared to Dry Road |
|-----------|-------------------------------|
| Light rain (road slightly damp) | 80-90% of dry traction |
| Moderate rain (standing water) | 50-70% of dry traction |
| Heavy rain (flowing water) | 30-50% of dry traction |
| First rain after dry spell (oil rises to surface) | As low as 20-30% (extremely slippery) |

### Rain Driving Rules

1. **Reduce speed** - wet roads require lower speeds for safe stopping.

2. **Increase following distance to 4+ seconds.**

3. **Use low beam headlights** - required by law in rain in many jurisdictions. High beams reflect off raindrops.

4. **Avoid sudden braking or sharp turns** - gentle inputs only.

5. **Use windshield wipers** - replace wiper blades annually for best performance.

6. **Defrost windows** - use defroster to prevent interior fogging.

7. **Watch for hydroplaning** - when tires lose contact with road and ride on water film.

### Hydroplaning: Causes and Recovery

**Hydroplaning occurs when:**
- Speed is too high for water depth
- Tire tread is worn (less than 3mm tread depth)
- Water depth exceeds tire tread capacity
- Typically occurs above 70-80 km/h in standing water

**Signs of hydroplaning:**
- Steering feels "light"
- Vehicle does not respond to steering input
- Engine sounds louder (less resistance)

**If you hydroplane:**
- **DO NOT** brake suddenly
- **DO NOT** turn sharply
- **Gently** lift off the accelerator
- Keep steering wheel straight
- Wait for tires to regain contact (usually 1-3 seconds)
- When traction returns, continue at reduced speed

[Insert image showing hydroplaning with water depth and tire contact patch]

**Real-world scenario:** Heavy rain begins while you are driving at 100 km/h. You ignore advice and maintain speed. You hit a patch of standing water. The steering goes light - you are hydroplaning. You panic and hit the brakes. The vehicle spins. You crash. Alternative: You reduced speed to 70 km/h when rain started. You maintain control, arrive safely, and avoid a crash.

## Section 4: Snow and Ice

Snow and ice are the most dangerous driving surfaces. If you do not have experience driving in these conditions, consider postponing travel or using public transportation.

### Traction Levels on Ice and Snow
- Dry road: 100% traction
- Wet road: 50-70% traction
- Packed snow: 20-30% traction
- Ice: 5-10% traction

### Snow and Ice Driving Rules

1. **Reduce speed dramatically** - maximum 30-40 km/h on snow, 10-20 km/h on ice.

2. **Increase following distance to 10+ seconds** - stopping distances on ice are 10x longer than dry roads.

3. **Avoid sudden ANYTHING** - no sudden acceleration, braking, or steering.

4. **Use lower gears** - engine braking provides more control than brakes on ice. In an automatic, use "2" or "L" or manual mode.

5. **Brake gently and early** - if wheels lock, release and pump brakes (or let ABS work).

6. **Be extra careful on:** Bridges (freeze first), shaded areas (ice remains longer), curves, intersections (polished ice from vehicles stopping).

7. **If you get stuck:** Do not spin tires (digs deeper). Rock back and forth (forward, reverse, forward). Use sand, salt, or floor mats under tires for traction.

[Insert image of vehicle driving on snow-covered road with proper following distance marked]

### Black Ice
- Thin, transparent ice that looks like wet pavement
- Extremely dangerous because drivers do not see it
- Most common on bridges, overpasses, and shaded curves
- If you hit black ice: Do NOT brake. Do NOT turn. Keep steering straight. Gently lift accelerator. Wait for tires to find pavement.

## Section 5: Strong Wind and Sandstorms

Jordan experiences khamsin winds and sandstorms, especially in spring and summer. High winds and blowing sand create serious driving hazards.

### Effects of Strong Wind

- **Lateral force** pushes vehicles sideways, especially:
  - High-profile vehicles (SUVs, vans, trucks, buses)
  - Lightweight vehicles
  - Vehicles towing trailers
- **Sand reduces visibility** and road grip (sand on pavement is like loose gravel)
- **Sudden gusts** from gaps in buildings, terrain, or passing large trucks

### Wind and Sand Driving Rules

1. **Keep both hands on the steering wheel** - be ready to counter wind gusts.

2. **Reduce speed** - slower speeds reduce wind effect.

3. **Close all windows** - prevents sand from entering the vehicle.

4. **Use low beam or fog lights** during daytime sandstorms. Use low beams after sunset (high beams reflect off sand).

5. **Increase following distance** - sand reduces braking grip.

6. **Watch for:** fallen branches, overturned vehicles, sand drifts across road.

7. **If wind becomes extreme:** Pull off the road completely in a safe location (not on the shoulder if possible). Turn off engine. Set parking brake. Turn on hazard lights. Wait for conditions to improve.

[Insert image of vehicle during sandstorm with low visibility]

## Section 6: Skid Recovery (Loss of Traction)

Skids occur when tires lose grip. Knowing how to recover is essential.

### Rear-Wheel Skid (Oversteer) - Rear slides out
- **Cause:** Too much speed in a turn, or too much acceleration (rear-wheel drive)
- **Vehicle feels like:** The rear is trying to pass the front
- **Recovery:**
  1. Immediately lift foot from accelerator
  2. **Steer in the direction the rear is sliding** (countersteer)
  3. Do not brake
  4. When rear regains grip, straighten steering wheel

**Example:** Rear slides right. Steer right toward the skid.

### Front-Wheel Skid (Understeer) - Front wheels lose grip
- **Cause:** Too much speed entering a turn, braking in a turn
- **Vehicle feels like:** The front continues straight even though wheels are turned
- **Recovery:**
  1. Lift foot from accelerator
  2. Shift to neutral (or clutch in for manual)
  3. Do NOT brake
  4. Steer toward the direction of skid (continue steering into the turn)
  5. When front regains grip, shift back to Drive (or appropriate gear)

### Four-Wheel Skid (All wheels sliding)
- **Cause:** Braking too hard on slippery surface
- **Recovery:**
  1. Lift accelerator
  2. Shift to neutral
  3. Release brakes to allow wheels to rotate
  4. Pump brakes gently (do not lock wheels)
  5. Steer desired direction

### Skid Prevention
- Reduce speed in rain, snow, ice, gravel
- Brake before turns, not during turns
- Accelerate gently on slippery surfaces
- Avoid abrupt steering movements

[Insert diagram showing rear-wheel skid and countersteering direction]

## Section 7: Accident and Emergency Procedures

### After a Crash

1. **Stop immediately** - leaving the scene is a crime (hit and run).

2. **Check for injuries** - provide first aid if trained. Call ambulance for any serious injury.

3. **Call police** - required for any crash with injuries or significant damage. Even minor crashes should be reported for insurance purposes.

4. **Do NOT move vehicles** unless:
   - They block traffic completely
   - No serious injuries
   - Minor damage only
   - You have photographed the scene first

5. **Exchange information** with the other driver:
   - Full name
   - Car registration number
   - Driving license number
   - Insurance company and policy number

6. **Document the scene** (if safe):
   - Photograph all vehicles from multiple angles
   - Photograph license plates
   - Photograph the intersection or location
   - Get witness names and phone numbers

### Your Legal Duty as a Witness

If you pass a crash with injuries, you are legally required to stop and help until emergency services arrive. Failure to do so is a crime.

### Reporting Requirement

If you are involved in a crash, you must report it within **48 hours** to the police or licensing department with your name, car number, and license number. Failure to report makes you a "fleeing the scene" offender with severe penalties.

### Breakdown Emergency (Review from Module 6)
1. Move off road
2. Hazard lights on
3. Reflective triangle 100m (rural) or 50m (urban) before vehicle
4. At night: parking lights on
5. Do not stand between vehicle and traffic
6. Call for help
7. If disabled and cannot exit: stay inside, hazard lights on, call for help

[Insert image showing correct placement of warning triangle on rural road]');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (8, 'ar', N'# ظروف القيادة الصعبة - الليل، الطقس، وحالات الطوارئ

تصبح القيادة أكثر خطورة بشكل ملحوظ في الظروف المعاكسة. تتضاعف معدلات الاصطدام ثلاث مرات في الليل أو في المطر أو في الضباب. تعلمك هذه الوحدة كيفية تكييف قيادتك للبقاء آمنًا.

## القسم 1: القيادة الليلية

### الإحصائيات
- معدل الحوادث **يتضاعف** ليلاً مقارنة بالنهار.
- عند السرعات التي تزيد عن 110 كم/ساعة، يزداد معدل التصادم الليلي **ست مرات**.
- تحدث معظم حوادث المرور الليلية بين منتصف الليل والساعة 6 صباحًا، خصوصًا بين الساعة 2 صباحًا و4 صباحًا.

### حدود الرؤية في الليل
- يتم تقليل إدراك العمق
- تضيق الرؤية المحيطية
- انخفاض التعرف على الألوان (يبدو اللون الأحمر أسودًا، والأخضر يبدو رماديًا)
- يستغرق التعافي من الوهج وقتًا أطول (من 5 إلى 10 ثوانٍ بعد الأضواء الساطعة)
- تقل الرؤية بشكل عام بنسبة 50-70%

### قائمة التحقق من سلامة القيادة الليلية

**قبل القيادة:**
- التأكد من عمل جميع الأضواء: المصابيح الأمامية (الشعاع العالي والمنخفض)، المصابيح الخلفية، أضواء الفرامل، إشارات الانعطاف، أضواء الخطر
- تنظيف المصابيح الأمامية والخلفية والنوافذ (من الداخل والخارج)
- قم بتوجيه المصابيح الأمامية بشكل صحيح (اسأل الميكانيكي إذا لم تكن متأكدًا)
- التأكد من أن العلامات العاكسة ولوحات الترخيص نظيفة ومرئية

**أثناء القيادة:**
- استخدم **الإنارة المنخفضة** داخل المدن وعلى الطرق المضاءة جيدًا
- استخدم **الأضواء العالية** على الطرق الريفية المظلمة التي لا توجد بها حركة مرور قادمة
- **الإضاءات العالية الخافتة** عندما:
  - وجود مركبة أمامك بأقل من 200 متر في اتجاهك
  - اقتراب مركبة من الاتجاه المعاكس (خافتة على الأقل 150 متر قبل اللقاء)
- قلل السرعة - مسافة الرؤية الفعالة لديك أقصر من مسافة التوقف
- قم بزيادة مسافة التتبع إلى 3-4 ثوانٍ كحد أدنى
- كن حذرًا جدًا عند التقاطعات (قد لا يراك السائقون الآخرون)
- انتبه للمشاة وراكبي الدراجات والحيوانات (تصعب رؤيتهم في الليل)

### إدارة الوهج

**من الأضواء العالية القادمة:**
- ابطئ
- انظر إلى الحافة اليمنى من الطريق (استخدم الخط أو الكتف الأيمن كدليل)
- لا تحدق في الأضواء
- حافظ على حقك في مسارك
- لا تضيء الأنوار العالية مرة أخرى (فهذا يشكل خطراً عليكما)

**من الأضواء العالية خلفك:**
- اضبط مرآة الرؤية الخلفية على الوضع الليلي (اقلب علامة التبويب)
- خفف السرعة واترك السيارة تمر
- لا تقم بفحص الفرامل للسائق

[أدخل صورة توضح تعديل مرآة الوضع الليلي]

**سيناريو العالم الحقيقي:** أنت تقود على طريق ريفي مظلم بسرعة 90 كم/ساعة مع تشغيل الأضواء العالية. ترى المصابيح الأمامية تقترب من منحنى. قم بإطفاء أضواءك على بعد 150 مترًا قبل الاجتماع. السائق القادم لا يخفت صوته. تنظر إلى الحافة اليمنى من الطريق، وتبطئ إلى 70 كم/ساعة، وتظل في مسارك. بعد الاجتياز تعود إلى السرعة العادية والأضواء العالية. تمنع هذه الاستجابة الآمنة العمى المؤقت والاصطدام المحتمل.

## القسم الثاني: القيادة في الضباب

يعد الضباب من أخطر الظروف لأنه يقلل الرؤية بشكل كبير ويخلق خداعًا بصريًا.

### أنواع الضباب والرؤية
- ضباب خفيف: مدى الرؤية 200 - 400 متر - خفض السرعة قليلاً
- ضباب متوسط: مدى الرؤية 100 - 200 متر - خفض السرعة بشكل ملحوظ
- ضباب كثيف: مدى الرؤية 50-100 متر - قم بالقيادة ببطء شديد، وفكر في التوقف
- ضباب كثيف: مدى الرؤية أقل من 50 مترًا - ابتعد عن الطريق بأمان

### قواعد القيادة في الضباب

1. **استخدم المصابيح الأمامية ذات الضوء المنخفض** - وليس الأضواء العالية. تعكس الحزم العالية قطرات الضباب وتشكل جدارًا أبيض، مما يقلل من الرؤية بشكل أكبر.

2. **استخدم مصابيح الضباب** إذا كانت سيارتك مزودة بها - ولكن فقط في الضباب أو الأمطار الغزيرة/الثلوج. لا تستخدم مصابيح الضباب في ظروف واضحة (فهي تعمي السائقين الآخرين).

3. **تقليل السرعة بشكل كبير.** كدليل:
   - مدى الرؤية 200 متر: السرعة القصوى 50 كم/ساعة
   - مدى الرؤية 100 متر: الحد الأقصى 30 كم/ساعة
   - مدى الرؤية 50 مترًا: الحد الأقصى 15 كم/ساعة

4. **قم بزيادة مسافة المتابعة إلى أكثر من 5 ثوانٍ** - قد لا ترى أضواء الفرامل حتى تكون قريبة جدًا.

5. **استخدم خط الحافة اليمنى كدليل** - اتبع العلامات البيضاء أو العاكسة على الجانب الأيمن.

6. **لا تتوقف في حارات السفر** - إذا انخفضت الرؤية إلى ما يقرب من الصفر، اخرج بعناية من الطريق تمامًا، وقم بتشغيل أضواء الخطر، وانتظر حتى تتحسن الظروف.

7. ** انتبه للمركبات
التي توقفت أمامك** - يمكن للضباب أن يخفي المركبات المتوقفة حتى تكون قريبًا جدًا.

[أدخل صورة للطريق الضبابي توضح انخفاض الرؤية والاستخدام المناسب للمصابيح الأمامية]

**سيناريو العالم الحقيقي:** تدخل إلى ضفة ضباب على الطريق السريع. وتنخفض الرؤية إلى 50 مترًا. خفض السرعة إلى 20 كم/ساعة، واستخدم الأضواء المنخفضة ومصابيح الضباب، واتبع خط الحافة اليمنى. ترى المصابيح الخلفية أمامك - سلسلة من السيارات تتحرك بسرعة 15 كم/ساعة. تحافظ على فجوة مدتها 5 ثوان. وبعد 20 دقيقة ينقشع الضباب. لقد تجنبت تصادم سيارات متعددة حدث على بعد كيلومتر واحد أمامك حيث كان السائقون مسرعين.

## القسم الثالث: الأمطار والطرق الرطبة

يقلل المطر من تماسك الإطارات (الجر) ويزيد من مسافات التوقف بشكل كبير.

### فقدان الجر أثناء المطر

| الحالة | الجر مقارنة بالطريق الجاف |
|-----------|---------------------------|
| أمطار خفيفة (الطريق رطبة قليلاً) | 80-90% من الجر الجاف |
| أمطار متوسطة (مياه راكدة) | 50-70% من الجر الجاف |
| أمطار غزيرة (المياه الجارية) | 30-50% من الجر الجاف |
| المطر الأول بعد فترة الجفاف (ارتفاع النفط إلى السطح) | منخفضة تصل إلى 20-30% (زلقة للغاية) |

### قواعد القيادة أثناء المطر

1. **تقليل السرعة** - تتطلب الطرق الرطبة سرعات أقل للتوقف الآمن.

2. **قم بزيادة مسافة المتابعة إلى أكثر من 4 ثوانٍ.**

3. **استخدم المصابيح الأمامية ذات الضوء المنخفض** - وهو أمر مطلوب بموجب القانون أثناء المطر في العديد من الولايات القضائية. تعكس الحزم العالية قطرات المطر.

4. **تجنب الفرملة المفاجئة أو المنعطفات الحادة** - مدخلات لطيفة فقط.

5. **استخدم ماسحات الزجاج الأمامي** - استبدل شفرات الماسحات سنويًا للحصول على أفضل أداء.

6. **إزالة الصقيع من النوافذ** - استخدم مزيل الصقيع لمنع تكون الضباب داخل السيارة.

7. **احترس من الانزلاق المائي** - عندما تفقد الإطارات الاتصال بالطريق وتصطدم بطبقة من الماء.

### الانزلاق المائي: الأسباب والعلاج

**يحدث التحليق المائي عندما:**
- السرعة عالية جدًا بالنسبة لعمق الماء
- مداس الإطار متآكل (عمق مداس أقل من 3 مم)
- عمق الماء يتجاوز سعة مداس الإطار
- يحدث عادة بسرعة أعلى من 70-80 كم/ساعة في المياه الراكدة

**علامات الانزلاق المائي:**
- التوجيه يشعر بأنه "خفيف"
- عدم استجابة السيارة لمدخلات التوجيه
- صوت المحرك أعلى (مقاومة أقل)

**إذا كنت بالطائرة المائية:**
- **لا** تضغط على الفرامل فجأة
- **لا** تستدير بشكل حاد
- **بلطف** ارفع دواسة الوقود
- حافظ على عجلة القيادة مستقيمة
- انتظر حتى تستعيد الإطارات الاتصال (عادةً من 1 إلى 3 ثوانٍ)
- عند عودة الجر، تابع السير بسرعة منخفضة

[أدخل صورة توضح التحليق المائي بعمق الماء ورقعة ملامسة الإطار]

**سيناريو العالم الحقيقي:** يبدأ هطول أمطار غزيرة أثناء القيادة بسرعة 100 كم/ساعة. أنت تتجاهل النصيحة وتحافظ على السرعة. لقد اصطدمت برقعة من المياه الراكدة. يصبح التوجيه خفيفًا - أنت تحلق مائيًا. أنت ذعر وضغطت على الفرامل. تدور السيارة. لقد تحطمت. البديل: لقد خفضت السرعة إلى 70 كم/ساعة عند بدء هطول الأمطار. يمكنك الحفاظ على السيطرة والوصول بأمان وتجنب وقوع حادث.

## القسم 4: الثلج والجليد

يعد الثلج والجليد من أخطر أسطح القيادة. إذا لم تكن لديك خبرة في القيادة في هذه الظروف، فكر في تأجيل السفر أو استخدام وسائل النقل العام.

### مستويات الجر على الجليد والثلج
- الطريق الجاف: قوة جر 100%
- الطريق الرطب: 50-70% جر
- الثلوج المكدسة: 20-30% جر
- الثلج: 5-10% جر

### قواعد القيادة على الجليد والثلج

1. **خفض السرعة بشكل كبير** - بحد أقصى 30-40 كم/ساعة على الثلج، و10-20 كم/ساعة على الجليد.

2. **زيادة مسافة التتبع إلى أكثر من 10 ثوانٍ** - مسافات التوقف على الجليد أطول بـ 10 مرات من الطرق الجافة.

3. **تجنب أي شيء مفاجئ** - لا يوجد تسارع مفاجئ أو فرملة أو توجيه.

4. **استخدم تروسًا أقل** - توفر فرملة المحرك تحكمًا أكبر من الفرامل على الجليد. في الوضع التلقائي، استخدم "2" أو "L" أو الوضع اليدوي.

5. **الفرامل بلطف وفي وقت مبكر** - في حالة قفل العجلات، قم بتحرير الفرامل وضخها (أو دع نظام ABS يعمل).

6. **كن حذرًا للغاية بشأن:** الجسور (التجميد أولاً)، والمناطق المظللة (يظل الجليد أطول)، والمنحنيات، والتقاطعات (الثلج المصقول الناتج عن توقف المركبات).

7. **إذا واجهتك مشكلة:** لا تقم بتدوير الإطارات (قم بالحفر بشكل أعمق). تأرجح للأمام والخلف (للأمام، للخلف، للأمام). استخدم الرمل أو الملح أو حصائر الأرضية أسفل الإطارات من أجل الجر.

[أدخل صورة للمركبة وهي تسير على طريق مغطى بالثلوج مع المتابعة الصحيحة
المسافة المحددة]

### الجليد الأسود
- جليد رقيق وشفاف يشبه الرصيف الرطب
- خطير للغاية لأن السائقين لا يرونه
- أكثر شيوعاً على الجسور والجسور والمنحنيات المظللة
- إذا اصطدمت بالثلج الأسود: لا تستخدم المكابح. لا تتحول. حافظ على التوجيه بشكل مستقيم. ارفع دواسة الوقود بلطف. انتظر حتى تجد الإطارات الرصيف.

## القسم الخامس: الرياح القوية والعواصف الرملية

ويشهد الأردن رياح الخمسين والعواصف الرملية، خاصة في فصلي الربيع والصيف. تشكل الرياح العاتية والرمال العاتية مخاطر جسيمة أثناء القيادة.

### آثار الرياح القوية

- **القوة الجانبية** تدفع المركبات جانبًا، خصوصًا:
  - المركبات رفيعة المستوى (سيارات الدفع الرباعي والشاحنات الصغيرة والشاحنات والحافلات)
  - المركبات الخفيفة
  - مركبات سحب المقطورات
- **الرمال تقلل من مدى الرؤية** وتماسك الطريق (الرمال الموجودة على الرصيف تشبه الحصى السائب)
- **هبات مفاجئة** ناجمة عن الفجوات في المباني أو التضاريس أو مرور الشاحنات الكبيرة

### قواعد القيادة بالرياح والرمال

1. **أبق يديك على عجلة القيادة** - كن مستعدًا لمواجهة هبوب الرياح.

2. **تقليل السرعة** - السرعات البطيئة تقلل من تأثير الرياح.

3. **أغلق جميع النوافذ** - يمنع دخول الرمال إلى السيارة.

4. **استخدم الضوء المنخفض أو مصابيح الضباب** أثناء العواصف الرملية أثناء النهار. استخدم عوارض منخفضة بعد غروب الشمس (العوارض العالية تعكس الرمال).

5. **زيادة مسافة التتبع** - الرمال تقلل من قبضة المكابح.

6. **احترس من:** الفروع المتساقطة، والمركبات المقلوبة، وانجراف الرمال عبر الطريق.

7. **إذا اشتدت الرياح:** ابتعد عن الطريق تمامًا في مكان آمن (وليس على الكتف إن أمكن). أطفئ المحرك. ضبط فرامل الانتظار. قم بتشغيل أضواء الخطر. انتظر حتى تتحسن الظروف.

[أدخل صورة المركبة أثناء العاصفة الرملية مع انخفاض الرؤية]

## القسم 6: التعافي من الانزلاق (فقدان الجر)

يحدث الانزلاق عندما تفقد الإطارات قبضتها. معرفة كيفية التعافي أمر ضروري.

### انزلاق العجلة الخلفية (التوجيه الزائد) - ينزلق الجزء الخلفي للخارج
- **السبب:** سرعة كبيرة جدًا أثناء المنعطف، أو تسارع كبير جدًا (الدفع بالعجلات الخلفية)
- **المركبة تبدو وكأنها:** الجزء الخلفي يحاول تجاوز المقدمة
- **الاسترداد:**
  1. ارفع قدمك فورًا عن دواسة الوقود
  2. **توجيه في الاتجاه الذي ينزلق فيه الجزء الخلفي** (توجيه معاكس)
  3. لا تستخدم المكابح
  4. عندما يستعيد الجزء الخلفي قبضته، قم بتسوية عجلة القيادة

**مثال:** الشرائح الخلفية لليمين. توجيه الحق نحو الانزلاق.

### انزلاق العجلة الأمامية (انخفاض التوجيه) - تفقد العجلات الأمامية قبضتها
- **السبب:** السرعة الزائدة عند الدخول في المنعطف، والكبح في المنعطف
- **تبدو السيارة كما يلي:** يستمر الجزء الأمامي في الاستقامة على الرغم من دوران العجلات
- **الاسترداد:**
  1. ارفع القدم عن دواسة الوقود
  2. التحول إلى الوضع المحايد (أو القابض لليدوي)
  3. لا تستخدم المكابح
  4. قم بالتوجيه نحو اتجاه الانزلاق (واصل التوجيه في المنعطف)
  5. عندما يستعيد الجزء الأمامي قبضته، انتقل مرة أخرى إلى وضع القيادة (أو الترس المناسب)

### انزلاق على العجلات الأربع (انزلاق جميع العجلات)
- **السبب:** الكبح بقوة شديدة على الأسطح الزلقة
- **الاسترداد:**
  1. ارفع دواسة الوقود
  2. التحول إلى الحياد
  3. حرر الفرامل للسماح للعجلات بالدوران
  4. ضخ الفرامل بلطف (لا تقفل العجلات)
  5. توجيه الاتجاه المطلوب

### منع الانزلاق
- تقليل السرعة في المطر والثلج والجليد والحصى
- الفرامل قبل المنعطفات وليس أثناء المنعطفات
- تسريع بلطف على الأسطح الزلقة
- تجنب حركات التوجيه المفاجئة

[أدخل رسمًا بيانيًا يوضح انزلاق العجلات الخلفية واتجاه التوجيه المعاكس]

## القسم السابع: إجراءات الحوادث والطوارئ

### بعد الحادث

1. **توقف فورًا** - مغادرة المكان جريمة (الضرب والهرب).

2. **التحقق من وجود إصابات** - قم بتقديم الإسعافات الأولية إذا تم تدريبك. اتصل بالإسعاف في حالة حدوث أي إصابة خطيرة.

3. **اتصل بالشرطة** - مطلوب في حالة حدوث إصابات أو أضرار جسيمة. وينبغي الإبلاغ حتى عن الأعطال الطفيفة لأغراض التأمين.

4. **لا تحرك المركبات** إلا إذا:
   - يمنعون حركة المرور بشكل كامل
   - لا توجد إصابات خطيرة
   - أضرار طفيفة فقط
   - لقد قمت بتصوير المشهد أولا

5. **تبادل المعلومات** مع السائق الآخر:
   - الاسم الكامل
   - رقم تسجيل السيارة
   - رقم رخصة القيادة
   - شركة التأمين ورقم البوليصة

6. **توثيق المشهد** (إذا كان آمنًا):
   - تصوير جميع المركبات من متعدد
زوايا ناقصة
   - صور لوحات الترخيص
   - تصوير التقاطع أو الموقع
   - الحصول على أسماء الشهود وأرقام الهواتف

### واجبك القانوني كشاهد

إذا مررت بحادث تصادم مصحوبًا بإصابات، فيجب عليك قانونًا التوقف والمساعدة حتى وصول خدمات الطوارئ. عدم القيام بذلك يعد جريمة.

### متطلبات الإبلاغ

إذا كنت متورطًا في حادث تصادم، فيجب عليك الإبلاغ عنه في غضون **48 ساعة** إلى الشرطة أو قسم الترخيص مع اسمك ورقم سيارتك ورقم الترخيص. عدم الإبلاغ يجعلك مجرمًا "فاربًا من مكان الحادث" ويعاقبك بعقوبات صارمة.

### طوارئ الأعطال (مراجعة من الوحدة 6)
1. التحرك خارج الطريق
2. أضواء الخطر مضاءة
3. مثلث عاكس 100 م (ريفي) أو 50 م (حضري) قبل السيارة
4. في الليل: أضواء وقوف السيارات مضاءة
5. لا تقف بين السيارة وحركة المرور
6. اطلب المساعدة
7. إذا كنت معطلاً ولا تستطيع الخروج: ابق في الداخل، وأضيئ أضواء الخطر، واطلب المساعدة

[أدخل صورة توضح الموضع الصحيح لمثلث التحذير على الطريق الريفي]');