import re
from deep_translator import GoogleTranslator

# =============================
# CONFIG
# =============================
INPUT_FILE  = "learning_modules/learning_modules type-text.txt"
OUTPUT_FILE = "../RokhsetakDB/14_Seeds/03_seed_modules.sql"

MAX_CHUNK_SIZE = 4000

translator = GoogleTranslator(source='auto', target='ar')


# =============================
# HELPERS
# =============================
def translate_preserving_images(text: str) -> str:
    lines = text.splitlines()

    chunks = []
    current_chunk = []

    def flush_chunk():
        if not current_chunk:
            return

        chunk_text = "\n".join(current_chunk)

        try:
            translated = translator.translate(chunk_text)
            if translated is None:
                translated = chunk_text
        except Exception:
            print("⚠️ chunk translation failed, using original")
            translated = chunk_text

        chunks.append(translated)
        current_chunk.clear()

    for line in lines:
        stripped = line.strip()

        # keep image lines untouched AND flush current chunk first
        if "{{img" in stripped:
            flush_chunk()
            chunks.append(line)
            continue

        # keep empty lines as separators (flush chunk first)
        if not stripped:
            flush_chunk()
            chunks.append(line)
            continue

        current_chunk.append(line)

    flush_chunk()
    return "\n".join(chunks)


def escape_sql(text: str) -> str:
    return text.replace("'", "''")


def translate(text: str) -> str:
    try:
        return translator.translate(text)
    except Exception:
        return text


def translate_large(text: str) -> str:
    chunks = [text[i:i + MAX_CHUNK_SIZE] for i in range(0, len(text), MAX_CHUNK_SIZE)]
    translated = []
    for chunk in chunks:
        try:
            translated.append(translator.translate(chunk))
        except Exception:
            print("⚠️  Translation failed for chunk, using original.")
            translated.append(chunk)
    return "\n".join(translated)


def identity_block(table: str, rows: list) -> str:
    if not rows:
        return f"-- (no rows for {table})"
    return "\n".join([
        f"SET IDENTITY_INSERT {table} ON;",
        *rows,
        f"SET IDENTITY_INSERT {table} OFF;",
    ])


# =============================
# READ FILE
# =============================
with open(INPUT_FILE, "r", encoding="utf-8-sig") as f:
    data = f.read()


# =============================
# PATTERNS
# =============================
module_header_pattern = re.compile(
    r"\*\*module_id:\*\*\s*(\d+)\s*\n"
    r"\*\*license_type_id:\*\*\s*(\d+)\s*\n"
    r"\*\*title:\*\*\s*\"(.*?)\"\s*\n"
    r"\*\*description:\*\*\s*\"(.*?)\"\s*\n"
    r"\*\*content_type:\*\*\s*\"(.*?)\"\s*\n"
    r"\*\*phase:\*\*\s*\"(.*?)\"\s*\n"
    r"\*\*order_index:\*\*\s*(\d+)\s*\n"
    r"\*\*prerequisite_module_id:\*\*\s*(NULL|\d+)"
)

module_content_pattern = re.compile(
    r"### Module Content.*?"
    r"\*\*content_id:\*\*\s*(\d+).*?"
    r"\*\*text_content:\*\*\s*\"\"\"\n(.*?)\n\"\"\"",
    re.DOTALL
)


# =============================
# PARSE — split on --- first so
# each section has exactly one module
# =============================
print("\n📦 Parsing modules...")

module_base_rows,         module_trans_rows    = [], []
module_content_base_rows, module_content_trans = [], []

sections = [s.strip() for s in re.split(r"\n---\n", data) if s.strip()]

for section in sections:
    m = module_header_pattern.search(section)
    if not m:
        print(f"⚠️  Skipping section (no module header):\n{section[:60]}")
        continue

    module_id, license_type_id, title, description, content_type, phase, order_index, prerequisite = m.groups()
    prerequisite_value = "NULL" if prerequisite == "NULL" else prerequisite

    print(f"  ✅ Module {module_id}: {title}")

    # LearningModules base
    module_base_rows.append(
        f"INSERT INTO Learning.LearningModules (module_id, license_type_id, phase, order_index, prerequisite_module_id) "
        f"VALUES ({module_id}, {license_type_id}, '{phase}', {order_index}, {prerequisite_value});"
    )

    # ModuleTranslations
    module_trans_rows.append(
        f"INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) "
        f"VALUES ({module_id}, 'en', N'{escape_sql(title)}', N'{escape_sql(description)}');"
    )
    module_trans_rows.append(
        f"INSERT INTO Learning.ModuleTranslations (module_id, language_code, title, description) "
        f"VALUES ({module_id}, 'ar', N'{escape_sql(translate(title))}', N'{escape_sql(translate(description))}');"
    )

    # ModuleContents + translations (if present)
    c = module_content_pattern.search(section)
    if c:
        content_id, content = c.groups()
        content = content.strip()

        print(f"     📄 Content {content_id} — translating...")

        module_content_base_rows.append(
            f"INSERT INTO Learning.ModuleContents (content_id, module_id, content_type, video_url) "
            f"VALUES ({content_id}, {module_id}, 'text', NULL);"
        )
        module_content_trans.append(
            f"INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) "
            f"VALUES ({content_id}, 'en', N'{escape_sql(content)}');"
        )
        ar_content = translate_preserving_images(content)
        module_content_trans.append(
            f"INSERT INTO Learning.ModuleContentTranslations (content_id, language_code, text_content) "
            f"VALUES ({content_id}, 'ar', N'{escape_sql(ar_content)}');"
        )
    else:
        print(f"     ⚠️  No text content found for module {module_id}")


# =============================
# WRITE OUTPUT
# =============================
print("\n💾 Writing output...")

blocks = [
    "-- =============================================",
    "-- Auto-generated seed file — modules",
    "-- =============================================",
    "",
    "-- LearningModules (base)",
    identity_block("Learning.LearningModules", module_base_rows),
    "",
    "-- ModuleTranslations",
    "\n".join(module_trans_rows),
    "",
    "-- ModuleContents (base)",
    identity_block("Learning.ModuleContents", module_content_base_rows),
    "",
    "-- ModuleContentTranslations",
    "\n".join(module_content_trans),
]

with open(OUTPUT_FILE, "w", encoding="utf-8-sig") as f:
    f.write("\n".join(blocks))

print(f"""
✅ Done — output: {OUTPUT_FILE}
   Modules:       {len(module_base_rows)} base | {len(module_trans_rows)} translations
   Content blocks:{len(module_content_base_rows)} base | {len(module_content_trans)} translations
""")