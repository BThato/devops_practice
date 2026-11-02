# log_analyzer.py

# 1. Initialize counters
count_200 = 0
count_404 = 0
count_500 = 0

# 2. Open and read the log file
try:
    with open("logs/access.log", "r") as file:
        for line in file:
            if "200" in line:
                count_200 += 1
            elif "404" in line:
                count_404 += 1
            elif "500" in line:
                count_500 += 1

    # 3. Write the summary report
    with open("report.txt", "w") as report:
        report.write("--- LOG ANALYSIS REPORT ---\n")
        report.write(f"Total 200 OK: {count_200}\n")
        report.write(f"Total 404 Not Found: {count_404}\n")
        report.write(f"Total 500 Errors: {count_500}\n")
    
    print("Report generated successfully as 'report.txt'!")

except FileNotFoundError:
    print("Error: access.log was not found.")
