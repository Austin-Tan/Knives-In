import csv
import sys
import json
import pdb

IN_FILE = 'results/quests.out'
OUT_FILE = 'csv/drop-off-rate-by-level-query.csv'

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

# create a map of <uid, max_level>
uid_to_best_level = {}

for uid, rows in uid_map.items():
   
   # create a map of <level instance, {level, stage, knives, time}>
   level_instance_map = {}
   for row in rows:
      dqid = row[index['dqid']]
      if not dqid in level_instance_map:
         level_instance_map[dqid] = {}
      details = json.loads(row[index['q_detail']])
      for k, v in details.items():
         level_instance_map[dqid][k] = v

   max_level = 0
   max_stage = 0
   last_level = False
   
   for k, v in level_instance_map.items():
      if 'level' in v:
         if v['level'] > max_level:
            max_level = v['level']
            max_stage = v['stage']
         elif v['level'] == max_level:
            max_stage = max(max_stage, v['stage'])
         
         if len(v) == 4 and v['level'] == 0 and v['stage'] == 2:
            last_level = True

   if not last_level:
      uid_to_best_level[uid] = '{}-{}'.format(max_level + 1, max_stage + 1)
   else:
      uid_to_best_level[uid] = '1-3'
pdb.set_trace()


# create a map of <level, number of players>
level_map = {}
for k,v in uid_to_best_level.items():
   if v not in level_map:
      level_map[v] = 0
   level_map[v] += 1

with open(OUT_FILE, 'w') as f:
   fieldsnames = ['level', 'player_count']
   writer = csv.DictWriter(f, fieldnames=fieldsnames)
   writer.writeheader()
   for key, value in sorted(level_map.items()):
      writer.writerow({'level': key, 'player_count':value})




