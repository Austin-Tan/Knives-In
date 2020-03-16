select a.cid, a.uid, b.sessionid, a.qid, a.dqid, a.aid, a.qaction_seqid, a.log_ts, a.a_detail 
from player_actions_log as a left join player_quests_log as b 
on a.dqid = b.dqid
where a.cid = 3
and a.uid != '1EA827E9-D91B-BCA4-54F7-4BF7160F7467'
and a.uid != 'BD3557C9-3D10-3A0C-5CC7-03F4AD599437'
and a.uid != '8CB0F1EA-28BA-40C8-9E3B-084C897E0ADF'
and a.uid != '1F7D6917-B0E9-6835-B85C-B410299D520F'
and a.uid != 'F5061989-0654-456D-EDAC-885E87E6A259'
and a.uid != '510C13D8-62AB-D54E-F424-C742D7A9E83F'
and a.uid != 'BBEB6A2E-F54B-748E-FF0F-1FD50B9CDD47'
and a.uid != 'A0125515-A55C-8571-0C53-64AFC80953BD'
and a.uid != 'E3E1E7BA-64AF-62F6-2992-F130272EFB08';