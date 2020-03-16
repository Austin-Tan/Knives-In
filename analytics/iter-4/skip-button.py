import csv
import sys
import json
import pdb

IN_FILE_A = 'results/skip-button.out'
OUT_FILE = 'csv/skip-button.csv'

index = {
   'cid': 0,
   'uid': 1,
   'sessionid': 2,
   'qid': 3,
   'dqid': 4,
   'aid': 5,
   'q_s_id': 6,
   'log_q_ts': 7,
   'q_detail': 8,
}


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

      if uid not in data_map:
         data_map[uid] = {}
      if sessionid not in data_map[uid]:
         data_map[uid][sessionid] = []
      data_map[uid][sessionid].append(line)

# create a map of levels to {skipoffered, skipaccepted}
result_map = {}

for uid, sessions in data_map.items():

   # create a map of <level instance, {details}>
   level_instance_map = {}
   for session, rows in sessions.items():
      for row in rows:
         dqid = row[index['qid']]
         if not dqid in level_instance_map:
            level_instance_map[dqid] = {}
         details = json.loads(row[index['q_detail']])
         # pdb.set_trace()
         for k, v in details.items():
            level_instance_map[dqid][k] = v

   max_level = 0
   max_stage = 0
   last_level = False
   
   for k, v in level_instance_map.items():
      level = v['level']
      stage = v['stage']
      level_str = '{}.{}'.format(level, stage)
      if level_str not in result_map:
         result_map[level_str] = {'accepted':0, 'offered':0}
      # skip_offered = v['skipOffered']

      # pdb.set_trace()
      if 'skipped' in v:
         result_map[level_str]['accepted'] += 1
      else:
         result_map[level_str]['offered'] += 1
pdb.set_trace()

# # create a map of <level, number of players>
# level_map = {}
# for k,v in uid_to_best_level.items():
#    if v not in level_map:
#       level_map[v] = 0
#    level_map[v] += 1

# drop_off = {}
# prev = 0
# for key, value in sorted(result_map.items(), reverse=True):
#    drop_off[key] = value + prev
#    prev += value

with open(OUT_FILE, 'w') as f:
   fieldsnames = ['level', 'skip_offered', 'skip_accepted']
   writer = csv.DictWriter(f, fieldnames=fieldsnames)
   writer.writeheader()
   for key, value in sorted(result_map.items()):
      writer.writerow({'level': key, 'skip_offered':value['offered'], 'skip_accepted':value['accepted']})



