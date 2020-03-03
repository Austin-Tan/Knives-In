select cid, uid, sessionid, qid, dqid, q_s_id, log_q_ts, q_detail, min(log_q_ts), max(log_q_ts)
from player_quests_log
where cid = 1
and uid != '1EA827E9-D91B-BCA4-54F7-4BF7160F7467'
and uid != 'BD3557C9-3D10-3A0C-5CC7-03F4AD599437'
group by sessionid;
