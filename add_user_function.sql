CREATE FUNCTION api.add_user_if_not_exists() RETURNS VOID AS 
$$
     INSERT INTO api.user VALUES (current_setting('request.jwt.claim.sub', true), current_setting('request.jwt.claim.email', true), current_setting('request.jwt.claim.preferred_username', true) ) ON CONFLICT DO NOTHING;
$$ LANGUAGE SQL STRICT;

REVOKE ALL PRIVILEGES ON FUNCTION api.add_user_if_not_exists FROM PUBLIC;
GRANT EXECUTE ON FUNCTION api.add_user_if_not_exists TO standard;
GRANT EXECUTE ON FUNCTION api.add_user_if_not_exists TO admin;