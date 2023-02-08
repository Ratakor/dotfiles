# A really poorly wwritten parser to convert .ics file to calendar file for when

TIMEZONE = 1 # as UTC+1
INPUT = "filename.ics"
OUTPUT = "calendar"

file = open(INPUT, "r")

if file.readline() != "BEGIN:VCALENDAR\n":
    file.close()
    exit()

line = file.readline()
locations = []
summaries = []
starts = []
ends = []

while line != "END:VCALENDAR\n":
    if line == "BEGIN:VEVENT\n":
        while line != "END:VEVENT\n":
            if line.startswith("LOCATION"):
                locations.append(line[9:].strip())
            elif line.startswith("SUMMARY"):
                summaries.append(line[8:].strip())
            elif line.startswith("DTSTART"):
                start = line.lstrip("DTSTART")
                year = ""
                month = ""
                day = ""
                hour = ""
                min = ""
                for i in range(len(start)):
                    if i >= 1 and i <= 4:
                        year += start[i]
                    elif i == 5 or i == 6:
                        month += start[i]
                    elif i == 7 or i == 8:
                        day += start[i]
                    elif i == 10:
                        hour += start[i]
                    elif i == 11:
                        if int(start[i]) + TIMEZONE > 9:
                            hour = str(int(hour[0]) + 1) + "0" # I cba do the case where H will become 25
                        else:
                            hour += str(int(start[i]) + TIMEZONE)
                    elif i == 12 or i == 13:
                        min += start[i]
                starts.append([year, month, day, hour, min])
            elif line.startswith("DTEND"):
                end = line.lstrip("DTEND")
                hour = ""
                min = ""
                for i in range(len(end)):
                    if i == 10:
                        hour += end[i]
                    elif i == 11:
                        if int(end[i]) + TIMEZONE > 9:
                            hour = str(int(hour[0]) + 1) + "0" # I cba do the case where H will become 25
                        else:
                            hour += str(int(end[i]) + TIMEZONE)
                    elif i == 12 or i == 13:
                        min += end[i]
                ends.append("{0}:{1}".format(hour, min))
            line = file.readline()
    line = file.readline()
file.close()

file = open(OUTPUT, "w")
for i in range(len(locations)):
    # yyyy mm dd, hh:hh -> hh:hh summary location
    file.write("{0} {1} {2}, {3}:{4} -> {5} {6} in {7}\n".format(starts[i][0], starts[i][1], starts[i][2], starts[i][3], starts[i][4], ends[i], summaries[i], locations[i]))

file.close()
print("All done!")
