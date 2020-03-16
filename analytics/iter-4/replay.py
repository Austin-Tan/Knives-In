import csv
import sys
import json
import pdb
from collections import defaultdict

IN_FILE_A = 'results/quests-B-Newgrounds.out'
OUT_FILE = 'csv/replay-after-completed-B-Newgrounds.csv'

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



