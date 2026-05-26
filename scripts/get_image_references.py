# Input and output file paths
input_file = "learning_modules/quizzes.txt"
output_file = "lines_with_img.txt"

# Read the input file and extract lines containing "img"
with open(input_file, "r", encoding="utf-8") as infile:
    matching_lines = [line for line in infile if "img" in line]

# Save matching lines to a new file
with open(output_file, "w", encoding="utf-8") as outfile:
    outfile.writelines(matching_lines)

print(f"Found {len(matching_lines)} lines containing 'img'.")
print(f"Saved results to: {output_file}")