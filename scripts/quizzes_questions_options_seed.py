import re
from deep_translator import GoogleTranslator

INPUT_FILE = "C:/Users/Lenovo/Documents/02 Programming/ro5setkom/learning_modules/quizzes.txt"
OUTPUT_FILE = "sql/seed_all_quizzes_questions_options.sql"

translator = GoogleTranslator(source='auto', target='ar')


def escape_sql(text):
    return text.replace("'", "''")


def translate(text):
    try:
        return translator.translate(text)
    except Exception:
        return text


with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = f.read()

# =============================
# REGEX
# =============================
quiz_pattern = re.compile(
    r"quiz_id:\s*(\d+).*?"
    r"module_id:\s*(\d+).*?"
    r"is_mock_exam:\s*(\d+).*?"
    r"license_type_id:\s*(NULL|\d+).*?"
    r"title:\s*\"(.*?)\".*?"
    r"passing_score:\s*(\d+)",
    re.DOTALL
)

question_pattern = re.compile(
    r"question_id:\s*(\d+).*?"
    r"quiz_id:\s*(\d+).*?"
    r"question_text:\s*\"(.*?)\"",
    re.DOTALL
)

option_pattern = re.compile(
    r"option_id:\s*(\d+).*?"
    r"question_id:\s*(\d+).*?"
    r"option_text:\s*\"(.*?)\".*?"
    r"is_correct:\s*(\d)",
    re.DOTALL
)

quizzes   = quiz_pattern.findall(data)
questions = question_pattern.findall(data)
options   = option_pattern.findall(data)

print(f"📊 Found {len(quizzes)} quizzes")
print(f"📊 Found {len(questions)} questions")
print(f"📊 Found {len(options)} options")

# =============================
# COLLECT SQL BLOCKS
# =============================

# Each dict holds { base: [...], trans: [...] } per table
quiz_base_rows,     quiz_trans_rows     = [], []
question_base_rows, question_trans_rows = [], []
option_base_rows,   option_trans_rows   = [], []

# --- Quizzes ---
for i, q in enumerate(quizzes, 1):
    print(f"➡️  Quiz {i}/{len(quizzes)}")
    quiz_id, module_id, is_mock, license_type, title, score = q
    license_value = "NULL" if license_type == "NULL" else license_type

    quiz_base_rows.append(
        f"INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) "
        f"VALUES ({quiz_id}, {module_id}, {is_mock}, {license_value}, {score});"
    )

    quiz_trans_rows.append(
        f"INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) "
        f"VALUES ({quiz_id}, 'en', N'{escape_sql(title)}');"
    )

    ar_title = escape_sql(translate(title))
    quiz_trans_rows.append(
        f"INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) "
        f"VALUES ({quiz_id}, 'ar', N'{ar_title}');"
    )

# --- Questions ---
for i, q in enumerate(questions, 1):
    print(f"➡️  Question {i}/{len(questions)}")
    question_id, quiz_id, text = q

    question_base_rows.append(
        f"INSERT INTO Learning.QuizQuestions (question_id, quiz_id) "
        f"VALUES ({question_id}, {quiz_id});"
    )

    question_trans_rows.append(
        f"INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) "
        f"VALUES ({question_id}, 'en', N'{escape_sql(text)}');"
    )

    ar_text = escape_sql(translate(text))
    question_trans_rows.append(
        f"INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) "
        f"VALUES ({question_id}, 'ar', N'{ar_text}');"
    )

# --- Options ---
for i, o in enumerate(options, 1):
    print(f"➡️  Option {i}/{len(options)}")
    option_id, question_id, text, is_correct = o

    option_base_rows.append(
        f"INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) "
        f"VALUES ({option_id}, {question_id}, {is_correct});"
    )

    option_trans_rows.append(
        f"INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) "
        f"VALUES ({option_id}, 'en', N'{escape_sql(text)}');"
    )

    ar_text = escape_sql(translate(text))
    option_trans_rows.append(
        f"INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) "
        f"VALUES ({option_id}, 'ar', N'{ar_text}');"
    )


# =============================
# WRITE SINGLE OUTPUT FILE
# =============================

def identity_block(table: str, rows: list[str]) -> str:
    """Wrap INSERT rows with IDENTITY_INSERT ON/OFF for tables that have an identity PK."""
    lines = [
        f"SET IDENTITY_INSERT {table} ON;",
        *rows,
        f"SET IDENTITY_INSERT {table} OFF;",
    ]
    return "\n".join(lines)


sections = [
    "-- =============================================",
    "-- Auto-generated seed file",
    "-- =============================================",
    "",

    "-- Quizzes (base)",
    identity_block("Learning.Quizzes", quiz_base_rows),
    "",

    "-- Quiz translations",
    "\n".join(quiz_trans_rows),
    "",

    "-- Questions (base)",
    identity_block("Learning.QuizQuestions", question_base_rows),
    "",

    "-- Question translations",
    "\n".join(question_trans_rows),
    "",

    "-- Options (base)",
    identity_block("Learning.QuestionOptions", option_base_rows),
    "",

    "-- Option translations",
    "\n".join(option_trans_rows),
]

with open(OUTPUT_FILE, "w", encoding="utf-8") as f:
    f.write("\n".join(sections))

print(f"✅ Done — single seed file written to: {OUTPUT_FILE}")