select cid, uid, sessionid, qid, dqid, q_s_id, log_q_ts, q_detail, min(log_q_ts), max(log_q_ts)
from player_quests_log
where cid = 3 
and uid != '1EA827E9-D91B-BCA4-54F7-4BF7160F7467'
and uid != 'BD3557C9-3D10-3A0C-5CC7-03F4AD599437'
and uid != '8CB0F1EA-28BA-40C8-9E3B-084C897E0ADF'
and uid != '1F7D6917-B0E9-6835-B85C-B410299D520F'
and uid != 'F5061989-0654-456D-EDAC-885E87E6A259'
and uid != '510C13D8-62AB-D54E-F424-C742D7A9E83F'
and uid != 'BBEB6A2E-F54B-748E-FF0F-1FD50B9CDD47'
and uid != 'A0125515-A55C-8571-0C53-64AFC80953BD'
and uid != 'E3E1E7BA-64AF-62F6-2992-F130272EFB08'
group by sessionid;
