CREATE VIEW api.user_subscription AS SELECT sub.channel_id, sub.user_id, chan.title, chan.description FROM api.subscription sub JOIN api.channel chan ON sub.channel_id=chan.id;
GRANT SELECT on api.user_subscription TO standard;

CREATE VIEW api.user_messages AS SELECT mes.message_time, mes.body, sub.channel_id, sub.user_id, chan.title, chan.description FROM api.message mes JOIN api.channel chan ON mes.channel_id=chan.id JOIN api.subscription sub ON sub.channel_id=chan.id order by mes.message_time DESC;
GRANT SELECT on api.user_messages TO standard;