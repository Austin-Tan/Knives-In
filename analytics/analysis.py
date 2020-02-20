import csv
import sys
import pdb

UID_INDEX = 3
uid_map = {}

file = csv.reader(sys.stdin, dialect=csv.excel)
for line in file:
   # print(line)
   # pdb.set_trace()
   uid = line[UID_INDEX]
   if uid == 'uid':
      continue
   if not uid in uid_map:
      uid_map[uid] = []
   uid_map[uid].append(line)

session_to_time = {}
returns_arr = []

for key, value in uid_map.items():
   start_time = ''
   end_time = ''
   session_map = {}


   for data in value:
      session_id = data[18]
      if not session_id in session_map:
         session_map[session_id] = []
      session_map[session_id].append(data)

   # print(session_map.keys())
   returns = len(session_map)
   returns_arr.append(returns)

   for k, v in session_map.items():
      start_time = min([int(line[2]) for line in v])
      end_time = max([int(line[2]) for line in v])
      duration = int(end_time) - int(start_time)
      session_to_time[k] = duration

time_map = {}
for time in range(0, 575, 10):
   count = 0
   for k, v in session_to_time.items():
      if v > time:
         count += 1
   time_map[time] = count
   print('{},{}'.format(time, count))

# return_map = {}
# for time in range(0, 20, 1):
#    count = 0
#    for v in returns_arr:
#       if v == time:
#          count += 1
#    return_map[time] = count
#    print('{},{}'.format(time, count))

   



