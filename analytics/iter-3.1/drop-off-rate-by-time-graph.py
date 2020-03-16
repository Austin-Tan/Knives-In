import csv
import sys
import pdb

IN_FILE = 'results/drop-off-rate-by-time-A.out'
OUT_FILE = 'csv/drop-off-rate-by-time-A.csv'
index = {
   'cid': 0,
   'uid': 1,
   'sessionid': 2,
   'qid': 3,
   'dqid': 4,
   'q-s_id': 5,
   'log_q_ts': 6,
   'q_detail': 7,
   'min_time': 8,
   'max_time': 9
}

uid_map = {}

# read .out file, create a map of <uid, rows>
with open(IN_FILE, 'r') as f:
   file = csv.reader(f, dialect=csv.excel_tab)

   for line in file:
      uid = line[index['uid']]
      if uid == 'uid':
         continue
      if not uid in uid_map:
         uid_map[uid] = []
      uid_map[uid].append(line)

# create a map of <uid, best time>
uid_to_best_time = {}
upper_bound = -1
for uid, rows in uid_map.items():
   max_length = 1000000000000
   for row in rows:
        max_length = min(max_length, int(row[index['max_time']]) - int(row[index['min_time']]))

   uid_to_best_time[uid] = max_length
   upper_bound = max(upper_bound, max_length)

# create a map of <time, number of players>
time_map = {}
for time in range(0, upper_bound, 10):
   count = 0
   for k, v in uid_to_best_time.items():
      if v > time:
         count += 1
   time_map[time] = count

with open(OUT_FILE, 'w') as f:
   fieldsnames = ['time', 'player_count']
   writer = csv.DictWriter(f, fieldnames=fieldsnames)
   writer.writeheader()
   for key, value in time_map.items():
      writer.writerow({'time': key, 'player_count':value})
   # print('{},{}'.format(time, count))




