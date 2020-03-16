import csv
import sys
import json
import pdb

IN_FILE_A = 'results/quests-A-Newgrounds.out'
OUT_FILE = 'csv/drop-off-rate-by-level-A-Newgrounds.csv'

index = {
   'cid': 0,
   'uid': 1,
   'sessionid': 2,
   'qid': 3,
   'dqid': 4,
   'q_s_id': 5,
   'log_q_ts': 6,
   'q_detail': 7,
}

uid_map = ['068AA512-6ECD-FECD-D30B-CAE7AABAAE1F', 'B1BAC639-852F-7370-3E5E-17BDA7660112', 'D037BE34-E685-DB40-130C-4C698EC77FB3', 'F87383F7-8519-F38C-7473-6A70C94CE26E', 'B538B8C8-CAE8-DAD9-6033-9A2CC312647A', 'B0153A3A-1778-AE57-8645-9E2C1C016863', '9845EB68-B0C3-0ABC-108B-2D7100EE2F98', '43633440-46EF-90B7-D0DD-464FD5FD40F7', '5BEBF43F-5D10-20A2-A983-66B087D488B9', '9992471F-9D73-047D-8C5F-6552AE127FCB', 'C59C98A6-5A0A-4CE1-A74B-37D09580BA38', '599329B2-868B-44BA-8CDD-70689D800017', '609A095A-8C26-B942-DA79-96AED57AE406', '417DC9F4-60BF-75C3-E936-C67ED2ABCD4B', '99B6D71F-1EDC-C8DF-D5D7-9B5311145F94', '3BBB48E6-4AAF-7958-0F68-569DEFF5F9DA', '9A2EA5EE-8E33-B9B8-B76C-7FA0739F0C17']

# read .out file, create a map of <uid, session, >
data_map = {}
with open(IN_FILE_A, 'r') as f:
   file = csv.reader(f, dialect=csv.excel_tab)

   for line in file:
      # pdb.set_trace()
      uid = line[index['uid']]
      sessionid = line[index['sessionid']]

      # header row
      if uid == 'uid':
         continue
      # if uid in uid_map:
      #    continue

      if uid not in data_map:
         data_map[uid] = {}
      if sessionid not in data_map[uid]:
         data_map[uid][sessionid] = []
      data_map[uid][sessionid].append(line)

# create a map of <uid, max_level>
uid_to_best_level = {}

for uid, sessions in data_map.items():

   # create a map of <level instance, {level, stage, knives, time}>
   level_instance_map = {}
   for session, rows in sessions.items():
      for row in rows:
         dqid = row[index['qid']]
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
         
   uid_to_best_level[uid] = float('{}.{}'.format(max_level, max_stage))

# create a map of <level, number of players>
level_map = {}
for k,v in uid_to_best_level.items():
   if v not in level_map:
      level_map[v] = 0
   level_map[v] += 1

drop_off = {}
prev = 0
for key, value in sorted(level_map.items(), reverse=True):
   drop_off[key] = value + prev
   prev += value

with open(OUT_FILE, 'w') as f:
   fieldsnames = ['level', 'player_count']
   writer = csv.DictWriter(f, fieldnames=fieldsnames)
   writer.writeheader()
   for key, value in sorted(drop_off.items()):
      writer.writerow({'level': key, 'player_count':value})



