CREATE TYPE gear_type AS ENUM ('container', 'rope', 'carabiner', 'acsender', 'decsender', 'harness', 'sling', 'ahd', 'pulley_set', 'patient_transport', 'rope_clamp', 'fall_arrester');

CREATE TABLE gear(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    gear_type gear_type,
    parent_id INTEGER,
    track_usage BOOLEAN
);

CREATE TABLE activity (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    gear_type_required gear_type[], -- Array of ENUM values
    parent_id INTEGER
);

CREATE TABLE gear_usage (
  id SERIAL PRIMARY KEY,
  created_at timestamp with time zone not null default now(),
  gear_id INTEGER not null,
  activity_id INTEGER not null,
  user_id INTEGER not null
);

INSERT INTO activity (name, gear_type_required, parent_id) VALUES 
('Operation', null, null),
('Training', null, null);

INSERT INTO activity (name, gear_type_required, parent_id) VALUES 
('Passing a knot on ascend', ARRAY['rope','carabiner','acsender','rope_clamp','harness']::gear_type[], 2),
('Passing a knot on descend', ARRAY['rope','carabiner','decsender','rope_clamp','harness']::gear_type[], 2),
('Pick-off on ascend', ARRAY['rope','carabiner','acsender','decsender','rope_clamp','harness']::gear_type[], 2),
('Passing a knot on descend', ARRAY['rope','carabiner','decsender','rope_clamp','harness']::gear_type[], 2),
('General rope mobility', ARRAY['rope','carabiner','acsender','decsender','rope_clamp','harness']::gear_type[], 2),
('Edge transition', ARRAY['rope','carabiner','acsender','decsender','rope_clamp','harness']::gear_type[], 2),
('Tripod setup', ARRAY['rope','carabiner','ahd','sling']::gear_type[], 2),
('Litter setup', ARRAY['rope','carabiner','patient_transport','pulley_set','sling']::gear_type[], 2);

INSERT INTO gear (name, gear_type, parent_id, track_usage) VALUES 
('Bag #1', 'container'::gear_type, 0, false),
('Bag #2', 'container'::gear_type, 0, false),
('Bag #3', 'container'::gear_type, 0, false),
('Bag #4', 'container'::gear_type, 0, false),
('Gear Sling #1', 'container'::gear_type, 0, false),
('Box #1', 'container'::gear_type, 0, false);

INSERT INTO gear (name, gear_type, parent_id, track_usage) VALUES 
('50m Rope', 'rope'::gear_type, 1, true),
('CMC Clutch', 'decsender'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 1, true),
('Petzl ID', 'decsender'::gear_type, 1, true),
('Petzl Hand Grab', 'acsender'::gear_type, 1, true),
('Leg Loop', 'acsender'::gear_type, 1, true),
('Full Body Harness', 'harness'::gear_type, 1, true);

INSERT INTO gear (name, gear_type, parent_id, track_usage) VALUES 
('50m Rope', 'rope'::gear_type, 1, true),
('CMC Clutch', 'decsender'::gear_type, 1, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 2, true),
('Petzl ID', 'decsender'::gear_type, 2, true),
('Petzl Hand Grab', 'acsender'::gear_type, 2, true),
('Leg Loop', 'acsender'::gear_type, 2, true),
('Full Body Harness', 'harness'::gear_type, 2, true);

INSERT INTO gear (name, gear_type, parent_id, track_usage) VALUES 
('50m Rope', 'rope'::gear_type, 3, true),
('CMC Clutch', 'decsender'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 3, true),
('Petzl ID', 'decsender'::gear_type, 3, true),
('Petzl Hand Grab', 'acsender'::gear_type, 3, true),
('Leg Loop', 'acsender'::gear_type, 3, true),
('Full Body Harness', 'harness'::gear_type, 3, true),
('50m Rope', 'rope'::gear_type, 4, true),
('CMC Clutch', 'decsender'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl AMD Carabiner', 'carabiner'::gear_type, 4, true),
('Petzl ID', 'decsender'::gear_type, 4, true),
('Petzl Hand Grab', 'acsender'::gear_type, 4, true),
('Leg Loop', 'acsender'::gear_type, 4, true),
('Full Body Harness', 'harness'::gear_type, 4, true);