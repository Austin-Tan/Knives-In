select a.cid, a.uid, b.sessionid, a.qid, a.dqid, a.aid, a.qaction_seqid, a.log_ts, a.a_detail 
from player_actions_log as a left join player_quests_log as b 
on a.dqid = b.dqid
where (a.cid = 7 or a.cid = 8)
and (a.aid = 4 or a.aid = 5);