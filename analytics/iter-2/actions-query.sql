select a.cid, a.uid, b.sessionid, a.qid, a.dqid, a.aid, a.qaction_seq_id, a.log_ts, a.a_details from player_actions_log as a left join player_quests_log as b on a.dqid = b.dqid;
