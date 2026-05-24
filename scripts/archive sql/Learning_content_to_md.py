import os
import re
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet

# === CONFIG ===
INPUT_FILE = "C:/Users/Lenovo/Documents/02 Programming/ro5setkom/learning_modules/learning_modules type-text.txt"  # your DeepSeek output
OUTPUT_DIR = "output_modules"

os.makedirs(OUTPUT_DIR, exist_ok=True)
os.makedirs(os.path.join(OUTPUT_DIR, "text"), exist_ok=True)
os.makedirs(os.path.join(OUTPUT_DIR, "pdf"), exist_ok=True)

# === READ FILE ===
with open(INPUT_FILE, "r", encoding="utf-8") as f:
    data = f.read()

# === REGEX TO EXTRACT MODULES ===
pattern = re.compile(
    r"\*\*module_id:\*\* (\d+).*?"
    r"\*\*title:\*\* \"(.*?)\".*?"
    r"\*\*text_content:\*\*\s*\"\"\"\n(.*?)\n\"\"\"",
    re.DOTALL
)

modules = pattern.findall(data)

print(f"Found {len(modules)} modules")

# === PDF STYLE ===
styles = getSampleStyleSheet()

for module_id, title, content in modules:
    safe_title = re.sub(r'[^\w\s-]', '', title).replace(" ", "_")

    # === SAVE TXT ===
    txt_path = os.path.join(OUTPUT_DIR, "text", f"{module_id}_{safe_title}.txt")
    with open(txt_path, "w", encoding="utf-8") as f:
        f.write(content.strip())


    print(f"Saved: {txt_path}")

print("Done.")