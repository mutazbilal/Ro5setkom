SET IDENTITY_INSERT Learning.LearningModules ON;
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id, progress_scope) VALUES (1, NULL, 'theoretical', 1, NULL, 'global');
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id, progress_scope) VALUES (2, NULL, 'theoretical', 2, 1, 'global');
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id, progress_scope) VALUES (3, NULL, 'theoretical', 3, 2, 'global');
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id, progress_scope) VALUES (4, NULL, 'theoretical', 4, 3, 'global');
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id, progress_scope) VALUES (5, NULL, 'theoretical', 5, 4, 'global');
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id, progress_scope) VALUES (6, 1, 'theoretical', 6, 5, 'per_license');
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id, progress_scope) VALUES (7, 2, 'theoretical', 7, 6, 'per_license');
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id, progress_scope) VALUES (8, 3, 'theoretical', 8, 7, 'per_license');
SET IDENTITY_INSERT Learning.LearningModules OFF;
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (1, 'en', N'Introduction to Driving Responsibilities and Legal Framework', N'Comprehensive overview of driver responsibilities, legal requirements, license categories, medical fitness, and the examination process in Jordan');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (1, 'ar', N'مقدمة لمسؤوليات القيادة والإطار القانوني', N'نظرة شاملة عن مسؤوليات السائق، والمتطلبات القانونية، وفئات الترخيص، واللياقة الطبية، وعملية الفحص في الأردن');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (2, 'en', N'Road Markings: Lines, Symbols, and Their Meanings', N'Complete guide to understanding mandatory lines, warning lines, pedestrian crossings, lane arrows, and road symbols');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (2, 'ar', N'علامات الطريق: الخطوط والرموز ومعانيها', N'الدليل الكامل لفهم الخطوط الإلزامية، وخطوط التحذير، ومعابر المشاة، وسهام الحارات، ورموز الطريق');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (3, 'en', N'Traffic Signs Complete Guide – Warning, Priority, Prohibition, and Mandatory Signs', N'Comprehensive coverage of all traffic sign categories with shapes, colors, meanings, and proper responses');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (3, 'ar', N'الدليل الكامل لإشارات المرور - الإشارات التحذيرية والأولوية والحظر والإشارات الإلزامية', N'تغطية شاملة لجميع فئات إشارات المرور بالأشكال والألوان والمعاني والاستجابات المناسبة');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (4, 'en', N'Right-of-Way Rules at Intersections and Roundabouts', N'Complete guide to priority rules including right-hand rule, main road authority, roundabout navigation, T-junctions, and emergency vehicles');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (4, 'ar', N'قواعد حق الطريق عند التقاطعات والدوارات', N'دليل كامل لقواعد الأولوية بما في ذلك قاعدة اليد اليمنى، وسلطة الطريق الرئيسية، والملاحة الدائرية، وتقاطعات T، ومركبات الطوارئ');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (5, 'en', N'Lane Discipline, Turning, and Overtaking', N'Proper lane positioning, turning procedures at intersections, U-turn rules, roundabout navigation, and safe overtaking techniques');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (5, 'ar', N'الانضباط في المسار، والانعطاف، والتجاوز', N'تحديد موقع المسار الصحيح، وإجراءات الانعطاف عند التقاطعات، وقواعد الدوران على شكل حرف U، والملاحة في الدوارات، وتقنيات التجاوز الآمنة');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (6, 'en', N'Speed Limits, Following Distance, and Stopping Safely', N'Maximum and minimum speed limits by road type, two-second and three-second following rules, stopping distances, and emergency braking');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (6, 'ar', N'حدود السرعة ومسافة التتبع والتوقف الآمن', N'حدود السرعة القصوى والدنيا حسب نوع الطريق، وقواعد اتباع الثانية والثلاث ثواني، ومسافات التوقف، وفرامل الطوارئ');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (7, 'en', N'Alcohol, Drugs, Fatigue, and Safe Driving Fitness', N'Effects of alcohol, medications, and fatigue on driving ability; legal consequences; and concentration techniques');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (7, 'ar', N'الكحول والمخدرات والتعب ولياقة القيادة الآمنة', N'آثار الكحول والأدوية والتعب على القدرة على القيادة. العواقب القانونية؛ وتقنيات التركيز');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (8, 'en', N'Difficult Driving Conditions – Night, Weather, and Emergencies', N'Techniques for driving safely at night, in fog, rain, snow, ice, strong wind, and managing skids and emergencies');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (8, 'ar', N'ظروف القيادة الصعبة - الليل والطقس وحالات الطوارئ', N'تقنيات القيادة بأمان ليلاً، في الضباب والمطر والثلج والجليد والرياح القوية، وإدارة الانزلاقات وحالات الطوارئ');
SET IDENTITY_INSERT Learning.ModuleContents ON;
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (1, 1, 'text');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (2, 2, 'text');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (3, 3, 'text');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (4, 4, 'text');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (5, 5, 'text');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (6, 6, 'text');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (7, 7, 'text');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (8, 8, 'text');
SET IDENTITY_INSERT Learning.ModuleContents OFF;
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (1, 'en', N'# Introduction to Driving Responsibilities and Legal Framework
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (1, 'ar', N'# مقدمة لمسؤوليات القيادة والإطار القانوني
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (2, 'en', N'# Road Markings: Lines, Symbols, and Their Meanings
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (2, 'ar', N'# علامات الطريق: الخطوط والرموز ومعانيها
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (3, 'en', N'# Traffic Signs Complete Guide – Warning, Priority, Prohibition, and Mandatory Signs
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (3, 'ar', N'# الدليل الكامل لإشارات المرور - الإشارات التحذيرية والأولوية والحظر والإشارات الإلزامية
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (4, 'en', N'# Right-of-Way Rules at Intersections and Roundabouts
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (4, 'ar', N'#قواعد حق المرور عند التقاطعات والدوارات
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (5, 'en', N'# Lane Discipline, Turning, and Overtaking
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (5, 'ar', N'# انضباط المسار والانعطاف والتجاوز
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (6, 'en', N'# Speed Limits, Following Distance, and Stopping Safely
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (6, 'ar', N'# حدود السرعة ومسافة التتبع والتوقف الآمن
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (7, 'en', N'# Alcohol, Drugs, Fatigue, and Safe Driving Fitness
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (7, 'ar', N'# الكحول والمخدرات والتعب ولياقة القيادة الآمنة
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (8, 'en', N'# Difficult Driving Conditions – Night, Weather, and Emergencies
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) VALUES (8, 'ar', N'# ظروف القيادة الصعبة - الليل، الطقس، وحالات الطوارئ
SET IDENTITY_INSERT Learning.LearningModules ON;
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (9, 1, 'practical', 1, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (10, 1, 'practical', 2, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (11, 1, 'practical', 3, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (12, 2, 'practical', 1, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (13, 2, 'practical', 2, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (14, 2, 'practical', 3, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (15, 3, 'practical', 1, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (16, 3, 'practical', 2, NULL);
INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) VALUES (17, 3, 'practical', 3, NULL);
SET IDENTITY_INSERT Learning.LearningModules OFF;
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (9, 'en', N'Basic Vehicle Controls & Automatic Transmission Handling', N'Starting, stopping, steering control, and automatic transmission basics in a closed area.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (9, 'ar', N'التحكم الأساسي بالمركبة وناقل الحركة الأوتوماتيكي', N'بدء الحركة، التوقف، التحكم بالتوجيه، وأساسيات ناقل الحركة الأوتوماتيكي في منطقة مغلقة.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (10, 'en', N'Urban Driving & Intersections (Automatic)', N'Navigating city traffic, lane changes, roundabouts, and right-of-way in real conditions.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (10, 'ar', N'القيادة في المدينة والتقاطعات (أوتوماتيك)', N'القيادة في حركة المرور بالمدينة، تغيير المسارب، الدوارات، وحق المرور في ظروف حقيقية.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (11, 'en', N'Highway & Emergency Maneuvers (Automatic)', N'Highway merging, safe following distance, emergency braking, and skid prevention.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (11, 'ar', N'الطريق السريع والمناورات الطارئة (أوتوماتيك)', N'الاندماج على الطريق السريع، مسافة التتبع الآمنة، الفرملة الطارئة، ومنع الانزلاق.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (12, 'en', N'Clutch Control & Manual Transmission Basics', N'Finding bite point, moving off smoothly, gear changes, and stopping without stalling.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (12, 'ar', N'التحكم بالقابض وناقل الحركة اليدوي الأساسي', N'إيجاد نقطة التعشيق، الانطلاق بسلاسة، تغيير التروس، والتوقف دون توقف المحرك.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (13, 'en', N'Hill Starts & Gear Selection (Manual)', N'Hill starts with handbrake, clutch control on inclines, and selecting correct gear for speed.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (13, 'ar', N'انطلاقات التل واختيار الترس (يدوي)', N'انطلاقات التل باستخدام فرامل اليد، التحكم بالقابض على المرتفعات، واختيار الترس المناسب للسرعة.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (14, 'en', N'Advanced Manual Handling & Rev Matching', N'Downshifting, rev matching, engine braking, and smooth stopping techniques.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (14, 'ar', N'التحكم المتقدم في ناقل الحركة اليدوي ومطابقة اللفات', N'خفض التروس، مطابقة اللفات، فرملة المحرك، وتقنيات التوقف السلس.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (15, 'en', N'Balance & Low-Speed Motorcycle Control', N'Mounting, dismounting, balancing, figure-eights, and slow-riding exercises.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (15, 'ar', N'التوازن والتحكم بالدراجة النارية بسرعة منخفضة', N'ركوب وإنزال الدراجة، التوازن، تمارين الرقم ثمانية، والقيادة البطيئة.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (16, 'en', N'Cornering & Emergency Braking (Motorcycle)', N'Proper cornering lines, counter-steering, emergency front/rear braking, and swerving.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (16, 'ar', N'المنعطفات والفرملة الطارئة (دراجة نارية)', N'خطوط المنعطفات الصحيحة، التوجيه المعاكس، الفرملة الطارئة بالأمام/الخلف، والمراوغة.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (17, 'en', N'Obstacle Avoidance & Real Traffic Scenarios', N'Avoiding potholes, debris, car doors, and practicing in light city traffic.');
INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) VALUES (17, 'ar', N'تجنب العوائق وسيناريوهات حركة المرور الحقيقية', N'تجنب الحفر، الحطام، أبواب السيارات، والتدرب في حركة مرور خفيفة بالمدينة.');
SET IDENTITY_INSERT Learning.ModuleContents ON;
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (9, 9, 'video');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (10, 10, 'video');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (11, 11, 'video');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (12, 12, 'video');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (13, 13, 'video');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (14, 14, 'video');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (15, 15, 'video');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (16, 16, 'video');
INSERT INTO Learning.ModuleContents (content_id, module_id, content_type) VALUES (17, 17, 'video');
SET IDENTITY_INSERT Learning.ModuleContents OFF;
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (9, 'en', N'https://www.youtube.com/embed/watch?v=kTZCinivLco&t=2s');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (9, 'ar', N'https://www.youtube.com/embed/watch?v=DpA_eJR5MIw');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (10, 'en', N'https://www.youtube.com/embed/watch?v=4av7-79Uum4');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (10, 'ar', N'https://www.youtube.com/embed/watch?v=Exjzd3zSq-I');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (11, 'en', N'https://www.youtube.com/embed/watch?v=GCeXFeHpm1I');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (11, 'ar', N'https://www.youtube.com/embed/watch?v=uGpSVsb6b44');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (12, 'en', N'https://www.youtube.com/embed/watch?v=pXXPknNhx30');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (12, 'ar', N'https://www.youtube.com/embed/watch?v=yA3DmwhoS9o');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (13, 'en', N'https://www.youtube.com/embed/watch?v=UTrj-pe20e8');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (13, 'ar', N'https://www.youtube.com/embed/watch?v=HqpdyfZwO0U');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (14, 'en', N'https://www.youtube.com/embed/watch?v=-RnPUq2yut4');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (14, 'ar', N'https://www.youtube.com/embed/watch?v=CizcRB1VG2U');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (15, 'en', N'https://www.youtube.com/embed/watch?v=bm1Xynt0QuE');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (15, 'ar', N'https://www.youtube.com/embed/watch?v=qh8c6gpji8Y');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (16, 'en', N'https://www.youtube.com/embed/watch?v=HxJPOQ_4L18');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (16, 'ar', N'https://www.youtube.com/embed/watch?v=l1SycZf2IPI');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (17, 'en', N'https://www.youtube.com/embed/watch?v=Z55kS9uzTXk');
INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, video_url) VALUES (17, 'ar', N'https://www.youtube.com/embed/watch?v=pufX4YjQ0uU');