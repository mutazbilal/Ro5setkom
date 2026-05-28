input_file = "../RokhsetakDB/14_Seeds/03_seed_modules.sql"
output_file = "filtered.sql"

# Keywords to match (case-insensitive)
keywords = ("insert into", "set identity")

with open(input_file, "r", encoding="utf-8") as infile, \
     open(output_file, "w", encoding="utf-8") as outfile:

    for line in infile:
        stripped = line.lstrip().lower()

        if stripped.startswith(keywords):
            outfile.write(line)

print(f"Filtered lines written to: {output_file}")