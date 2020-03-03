select a.cid, a.uid, b.sessionid, a.qid, a.dqid, a.aid, a.qaction_seqid, a.log_ts, a.a_detail 
from player_actions_log as a left join player_quests_log as b 
on a.dqid = b.dqid
where a.cid = 2
or a.cid = -3
and a.uid != '1EA827E9-D91B-BCA4-54F7-4BF7160F7467'
and a.uid != 'BD3557C9-3D10-3A0C-5CC7-03F4AD599437';
