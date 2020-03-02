CREATE DATABASE example;

CREATE SCHEMA api;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE api.roles_example (
  uuid    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_time    TIMESTAMP NOT NULL DEFAULT now(),
  message_body    TEXT
);

CREATE ROLE web_anon NOLOGIN;
GRANT USAGE ON SCHEMA api TO web_anon;
grant select on api.roles_example to web_anon;

CREATE ROLE standard NOLOGIN;
GRANT USAGE ON SCHEMA api TO standard;
GRANT ALL ON api.roles_example TO standard;

CREATE TABLE api.users_example (
  uuid    UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  message_time    TIMESTAMP NOT NULL DEFAULT now(),
  user_from       NAME      NOT NULL DEFAULT current_setting('request.jwt.claim.sub', true),
  role            NAME      NOT NULL DEFAULT current_user,
  message_body    TEXT
);

GRANT ALL ON api.users_example TO standard;

ALTER TABLE api.users_example ENABLE ROW LEVEL SECURITY;

CREATE POLICY users_example_policy ON api.users_example
  USING (user_from = current_setting('request.jwt.claim.sub', true))
  WITH CHECK (user_from = current_setting('request.jwt.claim.sub', true));