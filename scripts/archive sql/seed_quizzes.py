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
# SPLIT INTO QUIZ SECTIONS FIRST
# so question-level quiz_id fields don't bleed into the quiz regex
# =============================
quiz_sections = re.split(r"(?=## Quiz \d+)", data)
quiz_sections = [s.strip() for s in quiz_sections if s.strip()]

# =============================
# PATTERNS (scoped, no DOTALL bleed)
# =============================
quiz_header_pattern = re.compile(
    r"quiz_id:\s*(\d+).*?"
    r"module_id:\s*(\d+).*?"
    r"is_mock_exam:\s*(\d+).*?"
    r"license_type_id:\s*(NULL|\d+).*?"
    r"title:\s*\"(.*?)\".*?"
    r"passing_score:\s*(\d+)",
    re.DOTALL
)

question_pattern = re.compile(
    r"question_id:\s*(\d+)\s*\n"   # only match question_id at the start of its own block
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

# =============================
# COLLECT SQL ROWS
# =============================
quiz_base_rows,     quiz_trans_rows     = [], []
question_base_rows, question_trans_rows = [], []
option_base_rows,   option_trans_rows   = [], []

for section in quiz_sections:
    # --- Quiz header (one per section, guaranteed) ---
    quiz_match = quiz_header_pattern.search(section)
    if not quiz_match:
        print(f"⚠️  Could not parse quiz header in section:\n{section[:80]}")
        continue

    quiz_id, module_id, is_mock, license_type, title, score = quiz_match.groups()
    license_value = "NULL" if license_type == "NULL" else license_type

    print(f"✅ Quiz {quiz_id}: {title}")

    quiz_base_rows.append(
        f"INSERT INTO Learning.Quizzes (quiz_id, module_id, is_mock_exam, license_type_id, passing_score) "
        f"VALUES ({quiz_id}, {module_id}, {is_mock}, {license_value}, {score});"
    )
    quiz_trans_rows.append(
        f"INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) "
        f"VALUES ({quiz_id}, 'en', N'{escape_sql(title)}');"
    )
    quiz_trans_rows.append(
        f"INSERT INTO Learning.QuizTranslations (quiz_id, language_code, title) "
        f"VALUES ({quiz_id}, 'ar', N'{escape_sql(translate(title))}');"
    )

    # --- Questions (only within this section) ---
    for q_match in question_pattern.finditer(section):
        question_id, q_quiz_id, text = q_match.groups()
        print(f"   ❓ Question {question_id}")

        question_base_rows.append(
            f"INSERT INTO Learning.QuizQuestions (question_id, quiz_id) "
            f"VALUES ({question_id}, {q_quiz_id});"
        )
        question_trans_rows.append(
            f"INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) "
            f"VALUES ({question_id}, 'en', N'{escape_sql(text)}');"
        )
        question_trans_rows.append(
            f"INSERT INTO Learning.QuestionTranslations (question_id, language_code, question_text) "
            f"VALUES ({question_id}, 'ar', N'{escape_sql(translate(text))}');"
        )

    # --- Options (only within this section) ---
    for o_match in option_pattern.finditer(section):
        option_id, question_id, text, is_correct = o_match.groups()

        option_base_rows.append(
            f"INSERT INTO Learning.QuestionOptions (option_id, question_id, is_correct) "
            f"VALUES ({option_id}, {question_id}, {is_correct});"
        )
        option_trans_rows.append(
            f"INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) "
            f"VALUES ({option_id}, 'en', N'{escape_sql(text)}');"
        )
        option_trans_rows.append(
            f"INSERT INTO Learning.OptionTranslations (option_id, language_code, option_text) "
            f"VALUES ({option_id}, 'ar', N'{escape_sql(translate(text))}');"
        )


# =============================
# WRITE SINGLE OUTPUT FILE
# =============================
def identity_block(table: str, rows: list[str]) -> str:
    return "\n".join([
        f"SET IDENTITY_INSERT {table} ON;",
        *rows,
        f"SET IDENTITY_INSERT {table} OFF;",
    ])


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

print(f"\n✅ Done — {len(quiz_base_rows)} quizzes, {len(question_base_rows)} questions, {len(option_base_rows)} options")
print(f"📄 Output: {OUTPUT_FILE}")
