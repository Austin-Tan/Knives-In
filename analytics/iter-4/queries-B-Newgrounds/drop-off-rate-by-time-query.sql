select cid, uid, sessionid, qid, dqid, q_s_id, log_q_ts, q_detail, min(log_q_ts), max(log_q_ts)
from player_quests_log
where cid = 8
group by sessionid;
