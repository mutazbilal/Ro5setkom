from pathlib import Path
import re

# ============================================
# CONFIG
# ============================================

# Path to your DB root folder
DB_ROOT = Path(r"..\RokhsetakDB").resolve()

RUN_ALL_FILE = (DB_ROOT / "RunAll.sql").resolve()

CREATE_OUTPUT = (DB_ROOT / "CreateDatabase.sql").resolve()
SEED_OUTPUT = (DB_ROOT / "SeedDatabase.sql").resolve()
FULL_OUTPUT = (DB_ROOT / "FullDatabase.sql").resolve()
# ============================================
# DROP ALL TABLES BLOCK
# ============================================

DROP_ALL_TABLES_SQL = """
-- ============================================
-- DROP ALL TABLES
-- ============================================

DECLARE @sql NVARCHAR(MAX) = N'';

-- Drop foreign keys first
SELECT @sql += 
    'ALTER TABLE [' + s.name + '].[' + t.name + '] DROP CONSTRAINT [' + fk.name + '];' + CHAR(13)
FROM sys.foreign_keys fk
JOIN sys.tables t ON fk.parent_object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id;

EXEC sp_executesql @sql;
GO

DECLARE @sql2 NVARCHAR(MAX) = N'';

-- Drop all tables
SELECT @sql2 += 
    'DROP TABLE [' + s.name + '].[' + t.name + '];' + CHAR(13)
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id;

EXEC sp_executesql @sql2;
GO
"""

# ============================================
# HELPERS
# ============================================

def normalize_path(sqlcmd_path: str) -> Path:
    """
    Converts SQLCMD absolute paths into Path object.
    """
    sqlcmd_path = sqlcmd_path.strip().replace('"', "")
    sqlcmd_path = sqlcmd_path.replace("C:/Users/Lenovo/source/repos/Rokhsetak/", "")
    return Path(sqlcmd_path)


def extract_referenced_files(runall_content: str):
    """
    Extracts all :r referenced SQL files from RunAll.sql
    """
    pattern = r':r\s+"([^"]+)"'
    matches = re.findall(pattern, runall_content, re.IGNORECASE)

    return [normalize_path(match) for match in matches]


def read_sql_file(file_path: Path) -> str:
    """
    Reads a SQL file safely.
    """
    try:
        content = file_path.read_text(encoding="utf-8-sig")
        return content.replace("\ufeff", "").strip()
    except Exception as ex:
        return f"-- ERROR READING FILE: {file_path}\n-- {ex}"


def build_script(file_paths, title, prepend_sql=None):
    """
    Builds combined SQL script.
    """
    sections = []

    sections.append(f"-- ============================================")
    sections.append(f"-- {title}")
    sections.append(f"-- AUTO GENERATED")
    sections.append(f"-- ============================================\n")

    # Add optional SQL block at top
    if prepend_sql:
        sections.append(prepend_sql.strip())
        sections.append("\n")

    for file_path in file_paths:
        relative_path = file_path.relative_to(DB_ROOT)

        sections.append(f"\n-- ============================================")
        sections.append(f"-- FILE: {relative_path}")
        sections.append(f"-- ============================================\n")

        sections.append(read_sql_file(file_path))
        sections.append("\nGO\n")

    return "\n".join(sections)


# ============================================
# MAIN
# ============================================

def main():

    if not RUN_ALL_FILE.exists():
        print(f"RunAll.sql not found: {RUN_ALL_FILE}")
        return

    runall_content = RUN_ALL_FILE.read_text(encoding="utf-8-sig")

    referenced_files = extract_referenced_files(runall_content)
    for file in referenced_files:
        if not file.exists():
            print(f"Referenced file not found: {file}")
            return
        print(f"Found referenced file: {file}")
    create_files = []
    seed_files = []

    for file_path in referenced_files:

        # Skip query/testing scripts
        if "15_Queries" in str(file_path):
            continue

        # Separate seeds
        if "14_Seeds" in str(file_path):
            seed_files.append(file_path)
        else:
            create_files.append(file_path)

    # ============================================
    # BUILD OUTPUT FILES
    # ============================================

    create_script = build_script(
        create_files,
        "DATABASE CREATION SCRIPT",
        prepend_sql=DROP_ALL_TABLES_SQL
    )

    seed_script = build_script(
        seed_files,
        "DATABASE SEED SCRIPT"
    )
    concatenated_script = create_script + "\n\n" + seed_script

    # ============================================
    # WRITE FILES
    # ============================================

    #CREATE_OUTPUT.write_text(create_script, encoding="utf-8")
    #SEED_OUTPUT.write_text(seed_script, encoding="utf-8")
    FULL_OUTPUT.write_text(concatenated_script, encoding="utf-8")
    print("Done.")
    #print(f"Created: {CREATE_OUTPUT}")
    #print(f"Created: {SEED_OUTPUT}")
    print(f"Created: {FULL_OUTPUT}")


if __name__ == "__main__":
    main()