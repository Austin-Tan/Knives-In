import csv
import sys
import json
import pdb
from statistics import mean

IN_FILE = 'results/quests-A.out'
OUT_FILE = 'csv/time-spent-at-each-level-A.csv'

index = {
   'cid': 0,
   'uid': 1,
   'sessionid': 2,
   'qid': 3,
   'dqid': 4,
   'q-s_id': 5,
   'log_q_ts': 6,
   'q_detail': 7,
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

# create a map of <level, [time]]>
level_to_time = {}

for uid, rows in uid_map.items():

   level_instance_map = {}
   for row in rows:
      dqid = row[index['dqid']]
      if not dqid in level_instance_map:
         level_instance_map[dqid] = {}
      details = json.loads(row[index['q_detail']])
      for k, v in details.items():
         level_instance_map[dqid][k] = v
  
   # pdb.set_trace() 

   for k, v in level_instance_map.items():
      if 'level' in v and 'time' in v:
         level = v['level']
         stage = v['stage']
         time = v['time']
         if stage == 1:
            prev_time = 0

         key = (level-1)*3 + stage

         if key not in level_to_time:
            level_to_time[key] = []
         level_to_time[key].append(time - prev_time)
         
         prev_time = time

with open(OUT_FILE, 'w') as f:
   fieldsnames = ['level', 'time_spent']
   writer = csv.DictWriter(f, fieldnames=fieldsnames)
   writer.writeheader()
   for key, value in sorted(level_to_time.items()):
      for time in value:
         writer.writerow({'level': key, 'time_spent':time})



