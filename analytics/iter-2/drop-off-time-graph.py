import csv
import sys
import pdb

index = {
   'cid': 0,
   'uid': 1,
   'sessionid': 2,
   'qid': 3,
   'dqid': 4,
   'q-s_id': 5,
   'log_q_ts': 6,
   'q_detail': 7
}

file = csv.reader(sys.stdin, dialect=csv.excel)

uid_map = {}
for line in file:
   uid = line[index['uid']]
   if uid == 'uid':
      continue
   if not uid in uid_map:
      uid_map[uid] = []
   uid_map[uid].append(line)

session_to_time = {}
for key, value in uid_map.items():
   start_time = ''
   end_time = ''
   session_map = {}

   for data in value:
      session_id = data[index['sessionid']]
      if not session_id in session_map:
         session_map[session_id] = []
      session_map[session_id].append(data)

   for k, v in session_map.items():
      start_time = min([int(line[index['log_q_ts']]) for line in v])
      end_time = max([int(line[index['log_q_ts']]) for line in v])
      duration = int(end_time) - int(start_time)
      session_to_time[k] = duration

time_map = {}
for time in range(0, 600, 10):
   count = 0
   for k, v in session_to_time.items():
      if v > time:
         count += 1
   time_map[time] = count
   print('{},{}'.format(time, count))




