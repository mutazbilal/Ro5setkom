import os
import re
from pathlib import Path
from collections import defaultdict

def extract_sql_files_from_runall(runall_path):
    """Extract all :r referenced file paths from RunAll.sql"""
    referenced_files = set()
    
    with open(runall_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Pattern to match :r "path" or :r 'path'
    pattern = r':r\s+["\']([^"\']+)["\']'
    matches = re.findall(pattern, content, re.IGNORECASE)
    
    for match in matches:
        # Normalize path separators
        normalized = os.path.normpath(match)
        referenced_files.add(normalized)
    
    return referenced_files

def get_actual_sql_files(root_folder):
    """Get all .sql files in the folder structure"""
    actual_files = set()
    root_path = Path(root_folder)
    
    for sql_file in root_path.rglob("*.sql"):
        # Skip RunAll.sql itself and FullDatabase.sql
        if sql_file.name not in ['RunAll.sql', 'FullDatabase.sql']:
            # Store as absolute path for comparison
            actual_files.add(str(sql_file.absolute()))
    
    return actual_files

def normalize_paths_for_comparison(referenced_files, actual_files, root_folder):
    """Create mappings for comparison considering relative paths"""
    root_abs = Path(root_folder).absolute()
    
    referenced_normalized = set()
    actual_normalized = set()
    
    # Normalize referenced files (they might be absolute or relative)
    for ref_path in referenced_files:
        # Try to make it absolute relative to the current directory or root_folder
        if os.path.isabs(ref_path):
            referenced_normalized.add(os.path.normpath(ref_path))
        else:
            # Try relative to root_folder
            candidate = root_abs / ref_path
            if candidate.exists() or any(actual.startswith(str(candidate)) for actual in actual_files):
                referenced_normalized.add(str(candidate.absolute()))
            else:
                # Keep as original for reporting
                referenced_normalized.add(ref_path)
    
    # Normalize actual files
    for actual_path in actual_files:
        actual_normalized.add(os.path.normpath(actual_path))
    
    return referenced_normalized, actual_normalized

def find_missing_files(referenced_files, actual_files):
    """Find files in RunAll.sql but not in folder structure"""
    missing = []
    
    for ref_file in referenced_files:
        found = False
        
        # Check if this referenced file exists in actual files
        for actual_file in actual_files:
            if ref_file.lower() == actual_file.lower():
                found = True
                break
            # Also check if the actual file ends with the referenced relative path
            if actual_file.lower().endswith(ref_file.lower()):
                found = True
                break
        
        if not found:
            missing.append(ref_file)
    
    return missing

def find_extra_files(referenced_files, actual_files, root_folder):
    """Find files in folder structure but not referenced in RunAll.sql"""
    extra = []
    root_abs = Path(root_folder).absolute()
    
    for actual_file in actual_files:
        # Skip special files
        if 'RunAll.sql' in actual_file or 'FullDatabase.sql' in actual_file:
            continue
            
        found = False
        
        # Try to find if this actual file is referenced (possibly with different path format)
        actual_rel = Path(actual_file).relative_to(root_abs) if root_abs in Path(actual_file).parents else Path(actual_file)
        
        for ref_file in referenced_files:
            # Check if referenced path ends with the relative path
            if str(actual_rel).lower() in ref_file.lower() or ref_file.lower().endswith(str(actual_rel).lower()):
                found = True
                break
            # Check if the filenames match
            if Path(actual_file).name.lower() == Path(ref_file).name.lower():
                found = True
                break
        
        if not found:
            extra.append(actual_file)
    
    return extra

def analyze_runall_structure(runall_path):
    """Analyze the structure of RunAll.sql to see what's included"""
    sections = defaultdict(list)
    current_section = "Unknown"
    
    with open(runall_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    for line in lines:
        if line.strip().startswith('-- ============================================'):
            continue
        if line.strip().startswith('--') and 'RUNNING' in line.upper():
            current_section = line.strip().strip('-').strip()
        elif ':r' in line:
            match = re.search(r':r\s+["\']([^"\']+)["\']', line)
            if match:
                sections[current_section].append(match.group(1))
    
    return sections

def main():
    # Configuration
    root_folder = "../RokhsetakDB"
    runall_file = os.path.join(root_folder, "RunAll.sql")
    
    print("=" * 80)
    print("RUNALL.SQL vs FOLDER STRUCTURE COMPARISON")
    print("=" * 80)
    print(f"Root folder: {root_folder}")
    print(f"RunAll.sql file: {runall_file}")
    print()
    
    # Check if RunAll.sql exists
    if not os.path.exists(runall_file):
        print(f"ERROR: RunAll.sql not found at {runall_file}")
        return
    
    # Extract referenced files from RunAll.sql
    print("Extracting referenced files from RunAll.sql...")
    referenced_files = extract_sql_files_from_runall(runall_file)
    print(f"Found {len(referenced_files)} referenced files")
    
    # Get actual SQL files from folder structure
    print("Scanning actual folder structure...")
    actual_files = get_actual_sql_files(root_folder)
    print(f"Found {len(actual_files)} SQL files in folder structure")
    print()
    
    # Analyze RunAll.sql structure
    print("Analyzing RunAll.sql structure...")
    sections = analyze_runall_structure(runall_file)
    print(f"Found {len(sections)} sections in RunAll.sql")
    for section, files in sections.items():
        print(f"  {section}: {len(files)} files")
    print()
    
    # Normalize paths for comparison
    referenced_norm, actual_norm = normalize_paths_for_comparison(referenced_files, actual_files, root_folder)
    
    # Find mismatches
    print("=" * 80)
    print("MISMATCH ANALYSIS")
    print("=" * 80)
    
    missing_from_folder = find_missing_files(referenced_norm, actual_norm)
    extra_in_folder = find_extra_files(referenced_norm, actual_norm, root_folder)
    
    # Report missing files (in RunAll.sql but not in folder)
    if missing_from_folder:
        print(f"\n❌ FILES IN RunAll.sql BUT NOT IN FOLDER STRUCTURE ({len(missing_from_folder)} files):")
        print("-" * 80)
        for i, file in enumerate(sorted(missing_from_folder), 1):
            print(f"{i}. {file}")
    else:
        print("\n✅ All files referenced in RunAll.sql exist in the folder structure!")
    
    # Report extra files (in folder but not in RunAll.sql)
    if extra_in_folder:
        print(f"\n📁 FILES IN FOLDER STRUCTURE BUT NOT REFERENCED IN RunAll.sql ({len(extra_in_folder)} files):")
        print("-" * 80)
        for i, file in enumerate(sorted(extra_in_folder), 1):
            # Show relative path for readability
            try:
                rel_path = Path(file).relative_to(Path(root_folder))
                print(f"{i}. {rel_path}")
            except:
                print(f"{i}. {file}")
    else:
        print("\n✅ All SQL files in the folder structure are referenced in RunAll.sql!")
    
    # Summary
    print("\n" + "=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print(f"Total files referenced in RunAll.sql: {len(referenced_files)}")
    print(f"Total SQL files in folder structure: {len(actual_files)}")
    print(f"Files missing from folder: {len(missing_from_folder)}")
    print(f"Files not referenced: {len(extra_in_folder)}")
    
    # Check for ordering issues
    print("\n" + "=" * 80)
    print("ORDERING AND DEPENDENCY NOTES")
    print("=" * 80)
    print("Note: RunAll.sql executes files in a specific order for dependency management.")
    print("The following directories are executed in this order:")
    
    ordered_dirs = [
        "00_Database",
        "01_Lookups", 
        "02_Government",
        "03_Core",
        "04_RoleProfiles",
        "06_Mentor",
        "08_Scheduling",
        "07_Learning",
        "09_Messaging",
        "10_AI",
        "11_Notifications",
        "12_Security",
        "13_Indexes",
        "05_FK_Patches",
        "14_Seeds"
    ]
    
    for i, dir_name in enumerate(ordered_dirs, 1):
        status = "✓" if dir_name in str(sections) else "✗"
        print(f"  {i}. {status} {dir_name}")
    
    print("\n" + "=" * 80)
    print("TO VERIFY THE RESULTS MANUALLY:")
    print("=" * 80)
    print("1. Check RunAll.sql for any commented out :r commands")
    print("2. Verify that all file paths in RunAll.sql use correct case (Windows is case-insensitive)")
    print("3. Check for any SQL files that should be excluded intentionally")
    print("4. Review the FK Patches section - these are run after main tables")
    print("5. Ensure 05_FK_Patches appears after all table creation scripts")
    
if __name__ == "__main__":
    main()