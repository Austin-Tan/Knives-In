import csv
import sys
import json
import pdb

IN_FILE = 'results/quests.out'
OUT_FILE = 'csv/number-of-plays-per-level.csv'

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

# create a map of <level, <number of plays, count>>
plays_per_level_map = {}

for uid, rows in uid_map.items():

   level_instance_map = {}
   for row in rows:
      dqid = row[index['dqid']]
      if not dqid in level_instance_map:
         level_instance_map[dqid] = {}
      details = json.loads(row[index['q_detail']])
      for k, v in details.items():
         level_instance_map[dqid][k] = v
   
   count_map = {}
   for k, v in level_instance_map.items():
      if 'level' in v and 'time' in v:
         level = v['level']
         stage = v['stage']
         key = (level-1)*3 + stage

         if key not in count_map:
            count_map[key] = 0
         count_map[key] += 1

   for k, v in count_map.items():
      if k not in plays_per_level_map:
         plays_per_level_map[k] = {}
      if v not in plays_per_level_map[k]:
         plays_per_level_map[k][v] = 0
      plays_per_level_map[k][v] += 1
pdb.set_trace()
         

with open(OUT_FILE, 'w') as f:
   fieldsnames = ['level', 'number-of-plays', 'count']
   writer = csv.DictWriter(f, fieldnames=fieldsnames)
   writer.writeheader()
   for level, count_map in sorted(plays_per_level_map.items()):
      for k,v in sorted(count_map.items()):
         writer.writerow({'level': level, 'number-of-plays': k, 'count':v})



