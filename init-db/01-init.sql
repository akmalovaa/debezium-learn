CREATE USER debezium WITH REPLICATION PASSWORD 'debezium';
GRANT CONNECT ON DATABASE testdb TO debezium;
GRANT USAGE ON SCHEMA public TO debezium;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO debezium;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO debezium;

GRANT CREATE ON DATABASE testdb TO debezium;
ALTER USER debezium WITH SUPERUSER;

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50),
    message_text VARCHAR(5000),
    send_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE heartbeat (
    id INTEGER PRIMARY KEY DEFAULT 1,
    ts TIMESTAMPTZ DEFAULT NOW()
);

INSERT INTO heartbeat (id, ts) VALUES (1, NOW());

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

INSERT INTO messages (username, message_text) VALUES 
    ('Pupa', 'Hello everyone! How are you doing?'),
    ('Lupa', 'Great weather today'),
    ('Kek', 'Does anyone know when the meeting is?'),
    ('Cheburek', 'Thanks for help with the project'),
    ('Oleg', 'See you tomorrow at work');


GRANT SELECT ON messages TO debezium;
GRANT SELECT ON heartbeat TO debezium;

-- Creating Debezium publication
CREATE PUBLICATION debezium_pub FOR TABLE public.messages, public.heartbeat;
