import csv
import sys
import json
import pdb

IN_FILE = 'results/quests.out'
OUT_FILE = 'csv/return-rate.csv'

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

# create a map of <number of return, count>
return_count = {}

for uid, rows in uid_map.items():

   session_id_set = set()
   for row in rows:
      session = row[index['sessionid']]
      session_id_set.add(session)
   # for k,v in session_map.values():
   count = len(session_id_set)
   if count not in return_count:
      return_count[count] = 0
   return_count[count] += 1

pdb.set_trace()

with open(OUT_FILE, 'w') as f:
   fieldsnames = ['number of returns', 'players']
   writer = csv.DictWriter(f, fieldnames=fieldsnames)
   writer.writeheader()
   for key, value in sorted(return_count.items()):
      writer.writerow({'number of returns': key, 'players':value})



