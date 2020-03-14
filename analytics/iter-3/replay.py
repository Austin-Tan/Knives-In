import csv
import sys
import json
import pdb
from collections import defaultdict

IN_FILE_A = 'results/quests-B.out'
OUT_FILE = 'csv/replay-after-completed-B.csv'

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

# read .out file, create a map of <uid, session, details>
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
      if uid in uid_map:
         continue

      if uid not in data_map:
         data_map[uid] = {}
      if sessionid not in data_map[uid]:
         data_map[uid][sessionid] = []
      data_map[uid][sessionid].append(line)

replay_map = {}
for uid, session_map in data_map.items():
   player_map = {}
   for sessionid, details in session_map.items():
      for line in details:
         q_s_id = line[index['q_s_id']]
         q_detail = line[index['q_detail']]
         if q_detail == 'q_detail':
            continue
         q_detail = json.loads(line[index['q_detail']])
         if q_s_id == '1':
            if 'replayCount' in q_detail:
               level = int(q_detail['level'])
               stage = int(q_detail['stage'])
               count = int(q_detail['replayCount'])
               if q_detail['hasCompleted'] == True and q_detail['replayCount'] != '0':
                  level_str = float('{}.{}'.format(level, stage))
                  if level_str not in player_map:
                     player_map[level_str] = 0
                  player_map[level_str] = max(player_map[level_str], count)
                  if count == 0:
                     pdb.set_trace()
   for key, value in player_map.items():
      if key not in replay_map:
         replay_map[key] = {}
      if value not in replay_map[key]:
         replay_map[key][value] = 0
      replay_map[key][value] += 1
   # pdb.set_trace()
   


   
pdb.set_trace()



with open(OUT_FILE, 'w') as f:
   fieldsnames = ['level', 'num-replays', 'num-players']
   writer = csv.DictWriter(f, fieldnames=fieldsnames)
   writer.writeheader()
   for level, replays in sorted(replay_map.items()):
      for replay, count in sorted(replays.items()):
         writer.writerow({'level': level, 'num-replays': replay, 'num-players': count})



