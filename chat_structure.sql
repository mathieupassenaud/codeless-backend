CREATE SCHEMA api;
CREATE TABLE api.user (
  id              NAME      PRIMARY KEY DEFAULT current_setting('request.jwt.claim.sub', true),
  email           NAME      NOT NULL DEFAULT current_setting('request.jwt.claim.email', true),
  username        NAME      NOT NULL DEFAULT current_setting('request.jwt.claim.prefered_username', true)
);
CREATE TABLE api.channel (
  id              SERIAL           PRIMARY KEY,
  title           VARCHAR(50)      NOT NULL,
  description     TEXT             
);
CREATE TABLE api.message (
  id              SERIAL       PRIMARY KEY,
  channel_id      INTEGER      REFERENCES   api.channel(id),
  user_id         NAME         NOT NULL DEFAULT current_setting('request.jwt.claim.sub', true),
  message_time    TIMESTAMP    NOT NULL DEFAULT now(),
  body            TEXT             
);
CREATE TABLE api.subscription (
  id              SERIAL       PRIMARY KEY,
  channel_id      INTEGER,
  FOREIGN KEY (channel_id) REFERENCES api.channel(id),
  user_id         NAME         REFERENCES   api.user,
  subscriber      NAME         NOT NULL DEFAULT current_setting('request.jwt.claim.sub', true)
);

CREATE ROLE standard NOLOGIN;
GRANT USAGE ON SCHEMA api TO standard;
CREATE ROLE admin NOLOGIN;
GRANT USAGE ON SCHEMA api TO admin;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA api TO admin;
GRANT ALL ON api.subscription TO admin;
GRANT SELECT ON api.subscription TO standard;
GRANT ALL ON api.message TO standard;
GRANT ALL ON api.message TO admin;
GRANT ALL ON api.channel TO admin;
GRANT SELECT ON api.user TO admin;
GRANT INSERT ON api.user TO admin;
GRANT INSERT ON api.user TO standard;
GRANT SELECT ON api.user TO standard;

ALTER TABLE api.subscription ENABLE ROW LEVEL SECURITY;

CREATE POLICY subscription_policy ON api.subscription FOR SELECT TO standard
  USING (user_id = current_setting('request.jwt.claim.sub', true));

CREATE POLICY subscription_policy_admin ON api.subscription TO admin
  USING (true);