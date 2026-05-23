INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Introduction to Driving Responsibilities',
    N'Overview of driver responsibilities, legal requirements, and basic road safety principles',
    'theoretical',
    1,
    NULL,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Jordanian License Categories and Requirements',
    N'Explanation of Jordanian license categories, age requirements, and application documents',
    'theoretical',
    2,
    1,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Medical and Theoretical Examination Process',
    N'Steps to obtain a license: medical exam, theoretical test, and practical test',
    'theoretical',
    3,
    2,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Road Lines and Markings – Part 1 (Mandatory Lines)',
    N'Understanding solid lines, stop lines, yield lines, and their legal meanings',
    'theoretical',
    4,
    NULL,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Road Lines and Markings – Part 2 (Warning Lines and Symbols)',
    N'Broken lines, pedestrian crossings, bike lanes, arrows, words, and numbers',
    'theoretical',
    5,
    4,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Traffic Signs – Warning Signs (Part 1)',
    N'Warning signs: shape, colors, and meaning of common hazard signs',
    'theoretical',
    6,
    NULL,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Traffic Signs – Warning Signs (Part 2)',
    N'Slippery road, falling rocks, tunnel, railway crossing, roundabout, priority signs',
    'theoretical',
    7,
    6,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Traffic Signs – Priority Signs',
    N'Yield, stop, main road, and oncoming traffic priority signs',
    'theoretical',
    8,
    7,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Traffic Signs – Prohibition Signs',
    N'No entry, no motor vehicles, no turn, weight and size restrictions',
    'theoretical',
    9,
    8,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Traffic Signs – Mandatory (Command) and Informational Signs',
    N'Mandatory direction signs and informational guide signs',
    'theoretical',
    10,
    9,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Right-of-Way Rules at Intersections',
    N'General priority rules: right-hand rule, main road, roundabout, T-junction, emergency vehicles',
    'theoretical',
    11,
    10,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Lane Discipline and Turning Rules',
    N'Keep right, lane selection, signaling, and proper turning procedures',
    'theoretical',
    12,
    11,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Overtaking Rules and Prohibitions',
    N'Safe overtaking procedure, prohibited overtaking situations, and responsibilities of both drivers',
    'theoretical',
    13,
    12,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Speed Limits in Jordan',
    N'Maximum and minimum speed limits for different road types and vehicle categories',
    'theoretical',
    14,
    11,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Stopping, Parking, and Overtaking in Special Cases',
    N'Legal definitions of stopping vs. parking, prohibited locations, parallel parking, and emergency stopping',
    'theoretical',
    15,
    13,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Alcohol, Drugs, and Medications',
    N'Effects of alcohol, drugs, and certain medications on driving ability and legal consequences',
    'theoretical',
    16,
    1,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Driver Fatigue and Concentration',
    N'How tiredness affects driving, signs of fatigue, and concentration techniques',
    'theoretical',
    17,
    16,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Difficult Driving Conditions',
    N'Night, fog, rain, snow, ice, strong wind, and dust storms',
    'theoretical',
    18,
    17,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'hicle Safety Equipment – Seatbelts, Airbags, and Headrests',
    N'Purpose and correct use of seatbelts, airbags, and headrests',
    'theoretical',
    19,
    18,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'First Aid Basics – Fractures',
    N'Types of fractures, signs, and first aid procedures for closed and open fractures',
    'theoretical',
    20,
    NULL,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'First Aid Basics – Burns and Bleeding',
    N'Degrees of burns, first aid for each, and how to control bleeding',
    'theoretical',
    21,
    20,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Following Distance – Two-Second and Three-Second Rule',
    N'Safe following distance calculation in dry and wet conditions',
    'theoretical',
    22,
    17,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Accident Procedures and Breakdown Handling',
    N'What to do after an accident, reporting requirements, and emergency breakdown steps',
    'theoretical',
    23,
    22,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Traffic Violations and Penalties (Major Offenses)',
    N'Serious traffic violations and corresponding legal penalties',
    'theoretical',
    24,
    23,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Traffic Violations – Speeding and Points System',
    N'Speed violation fines and how the points system works',
    'theoretical',
    25,
    24,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    1,
    N'Practical Driving Basics (Automatic Transmission)',
    N'Pre-drive checklist, startup, basic control, and stopping for automatic vehicles',
    'practical',
    1,
    3,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    2,
    N'Practical Driving Basics (Manual Transmission)',
    N'Clutch control, gear selection, hill starts, and smooth driving for manual vehicles',
    'practical',
    1,
    3,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    3,
    N'Motorcycle Preparation and Protective Gear',
    N'Essential safety equipment and pre-ride checks for motorcycles and scooters',
    'theoretical',
    1,
    NULL,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    3,
    N'Motorcycle Lane Positioning and Visibility',
    N'How to choose the safest lane position to stay visible and avoid hazards',
    'practical',
    2,
    28,
    1
);

INSERT INTO Learning.LearningModules (
    license_type_id,
    title,
    description,
    phase,
    order_index,
    prerequisite_module_id,
    language_english
)
VALUES (
    3,
    N'Motorcycle Emergency Braking and Swerving',
    N'Techniques for sudden stops and quick direction changes to avoid crashes',
    'practical',
    3,
    29,
    1
);