import re
from deep_translator import GoogleTranslator

INPUT_FILE = "C:/Users/Lenovo/Documents/02 Programming/ro5setkom/learning_modules/learning_modules type-text.txt"

OUTPUT_BASE = "sql/module_contents_base.sql"
OUTPUT_TRANSLATIONS = "sql/module_content_translations.sql"

translator = GoogleTranslator(source='auto', target='ar')

MAX_CHUNK_SIZE = 4000


def escape_sql(text):
    return text.replace("'", "''")


def chunk_text(text, size):
    return [text[i:i + size] for i in range(0, len(text), size)]


def translate_large_text(text):
    chunks = chunk_text(text, MAX_CHUNK_SIZE)
    translated_chunks = []

    for chunk in chunks:
        try:
            translated_chunks.append(translator.translate(chunk))
        except Exception:
            print("⚠️ Translation failed for chunk, using original.")
            translated_chunks.append(chunk)

    return "\n".join(translated_chunks)


# === READ FILE ===
with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = f.read()


# === REGEX ===
pattern = re.compile(
    r"\*\*module_id:\*\* (\d+).*?"
    r"\*\*text_content:\*\*\s*\"\"\"\n(.*?)\n\"\"\"",
    re.DOTALL
)

matches = pattern.findall(data)

base_sql = []
translation_sql = []

for module_id, content in matches:
    content = content.strip()

    # -------------------------
    # 1. BASE TABLE INSERT
    # -------------------------
    base_sql.append(f"""
INSERT INTO Learning.ModuleContents (
    module_id,
    content_type,
    video_url
)
VALUES (
    {module_id},
    'text',
    NULL
);
""".strip())

    # -------------------------
    # 2. ENGLISH TRANSLATION
    # -------------------------
    en_content = escape_sql(content)

    translation_sql.append(f"""
INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    {module_id},  -- assumes sequential execution
    'en',
    N'{en_content}'
);
""".strip())

    # -------------------------
    # 3. ARABIC TRANSLATION
    # -------------------------
    print(f"Translating module {module_id}...")

    ar_content = translate_large_text(content)
    ar_content = escape_sql(ar_content)

    translation_sql.append(f"""
INSERT INTO Learning.ModuleContentTranslations (
    content_id,
    language_code,
    text_content
)
VALUES (
    {module_id},  -- using module_id for simplicity, adjust if needed
    'ar',
    N'{ar_content}'
);
""".strip())


# === WRITE FILES ===
with open(OUTPUT_BASE, "w", encoding="utf-8") as f:
    f.write("\n\n".join(base_sql))

with open(OUTPUT_TRANSLATIONS, "w", encoding="utf-8") as f:
    f.write("\n\n".join(translation_sql))


print(f"Generated {len(base_sql)} base inserts")
print(f"Generated {len(translation_sql)} translation inserts")