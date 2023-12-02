CREATE TABLE "countries" -- länder
(
    id   uuid NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE
);
CREATE TABLE "cities" -- städer
(
    id      uuid NOT NULL PRIMARY KEY,
    name    text NOT NULL UNIQUE,
    country uuid NOT NULL references countries ON DELETE RESTRICT
);
CREATE INDEX ON cities (country);

CREATE TABLE "universities" -- universitet
(
    id   uuid NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE,
    city uuid NOT NULL references cities ON DELETE RESTRICT
);
CREATE TABLE "studentkar" -- studentkår
(
    id         uuid NOT NULL PRIMARY KEY,
    name       text NOT NULL UNIQUE,
    university uuid NOT NULL references universities ON DELETE RESTRICT
);
CREATE TABLE "studentkar_sektioner" -- studentkårs sektioner
(
    id         uuid NOT NULL PRIMARY KEY,
    name       text NOT NULL UNIQUE,
    studentkar uuid NOT NULL references studentkar ON DELETE RESTRICT
);
CREATE INDEX ON universities (city);
CREATE INDEX ON studentkar (university);
CREATE INDEX ON studentkar_sektioner (studentkar);

CREATE TABLE "foreningar" -- föreningar
(
    id   uuid NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE,
    city uuid NOT NULL references cities ON DELETE RESTRICT
);
CREATE TABLE "underforeningar" -- underföreningar
(
    id       uuid NOT NULL PRIMARY KEY,
    name     text NOT NULL UNIQUE,
    forening uuid NOT NULL references foreningar ON DELETE RESTRICT
);
CREATE INDEX ON foreningar (city);
CREATE INDEX ON underforeningar (forening);

CREATE TABLE "nationer" -- nationer
(
    id   uuid NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE,
    city uuid NOT NULL references cities ON DELETE RESTRICT
);
CREATE INDEX ON nationer (city);

-- Lowest group in any hierarchy, typically a klubbmästeri or klubb, (e.g. TMEIT, DISK KM, NKM, IN-sektionen's ITK)
CREATE TYPE namnd_type AS ENUM ('klubbmasteri', 'festeri', 'namnd');
CREATE TABLE "namnder" -- nämnder
(
    id                 uuid       NOT NULL PRIMARY KEY,
    name               text       NOT NULL UNIQUE,
    type               namnd_type NULL,

    -- Parent organizations
    city               uuid       NULL references cities ON DELETE RESTRICT,
    university         uuid       NULL references universities ON DELETE RESTRICT,
    studentkar         uuid       NULL references studentkar ON DELETE RESTRICT,
    studentkar_sektion uuid       NULL references studentkar_sektioner ON DELETE RESTRICT,
    forening           uuid       NULL references foreningar ON DELETE RESTRICT,
    underforening      uuid       NULL references underforeningar ON DELETE RESTRICT,
    nation             uuid       NULL references nationer ON DELETE RESTRICT,
    CHECK (  -- Only one parent organization in hierarchy allowed. code reference: https://stackoverflow.com/a/55223096
            num_nonnulls(
                    city,
                    university,
                    studentkar,
                    studentkar_sektion,
                    forening,
                    underforening,
                    nation) = 1
        )
);
CREATE INDEX ON namnder (city);
CREATE INDEX ON namnder (university);
CREATE INDEX ON namnder (studentkar);
CREATE INDEX ON namnder (studentkar_sektion);
CREATE INDEX ON namnder (forening);
CREATE INDEX ON namnder (underforening);
CREATE INDEX ON namnder (nation);

-- lowest group in hierarchy that issued a patch or ran an event
-- usually a nämnd, but the patch/event may be connected to a higher hierarchy, like KTH logo patches.
-- The patch/event may even be organized by an individual person outside of a nämnd/hierarchy.
-- (e.g. a person from Göteborg making a patch would set city="Göteborg",
-- indie utlandsfester like Skiweek Vemdalen would instead set country="Sweden")
CREATE TABLE "organizers" -- patch/event organizer
(
    id                 uuid NOT NULL PRIMARY KEY,

    -- Having unique prevents having multiple identical organizers in this table
    -- two null values are distinct and don't violate unique in Postgresql
    -- Unique also makes sure that we index these columns for fast lookup
    -- https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-UNIQUE-CONSTRAINTS
    country            uuid NULL UNIQUE references countries ON DELETE RESTRICT,
    city               uuid NULL UNIQUE references cities ON DELETE RESTRICT,
    university         uuid NULL UNIQUE references universities ON DELETE RESTRICT,
    studentkar         uuid NULL UNIQUE references studentkar ON DELETE RESTRICT,
    studentkar_sektion uuid NULL UNIQUE references studentkar_sektioner ON DELETE RESTRICT,
    forening           uuid NULL UNIQUE references foreningar ON DELETE RESTRICT,
    underforening      uuid NULL UNIQUE references underforeningar ON DELETE RESTRICT,
    nation             uuid NULL UNIQUE references nationer ON DELETE RESTRICT,
    namnd              uuid NULL UNIQUE references namnder ON DELETE RESTRICT,
    -- Only one organizer allowed
    -- code reference https://stackoverflow.com/a/55223096
    CHECK (
            num_nonnulls(
                    country,
                    city,
                    university,
                    studentkar,
                    studentkar_sektion,
                    forening,
                    underforening,
                    nation,
                    namnd) = 1
        )
);

CREATE TABLE "events"
(
    id           uuid NOT NULL PRIMARY KEY,
    name         text NOT NULL UNIQUE,
    organizer    uuid NOT NULL references organizers,
    parent_event uuid NULL references events
);
CREATE TABLE "event_occurrences"
(
    id         uuid NOT NULL PRIMARY KEY,
    name       text NOT NULL UNIQUE,
    event      uuid NOT NULL references events ON DELETE RESTRICT,
    start_date date NOT NULL,
    end_date   date NULL
);
CREATE INDEX ON events (organizer);
CREATE INDEX ON events (parent_event);
CREATE INDEX ON event_occurrences (event);
CREATE INDEX ON event_occurrences (start_date);

CREATE TYPE patch_reason AS ENUM ('dryck', 'event', 'other');
CREATE TABLE "patches"
(
    id           uuid         NOT NULL PRIMARY KEY,
    name         text         NOT NULL UNIQUE,
    release_date date         NULL,

    organizer    uuid         NOT NULL references organizers ON DELETE RESTRICT,

    reason       patch_reason NOT NULL,

    -- Link patch to event, if and only if it is an event patch
    event        uuid         NULL references event_occurrences ON DELETE RESTRICT,
    CHECK (
            (reason = 'event' AND event IS NOT NULL)
            OR (reason != 'event' AND event IS NULL)
        )
);
CREATE INDEX ON patches (release_date);
CREATE INDEX ON patches (organizer);
CREATE INDEX ON patches (reason);
CREATE INDEX ON patches (event);

CREATE TABLE "patch_pictures"
(
    id uuid NOT NULL PRIMARY KEY,
    patch uuid NOT NULL references patches ON DELETE CASCADE
);
CREATE INDEX ON patch_pictures (patch);

CREATE TABLE "patch_tags"
(
    id   uuid NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE
);
CREATE TABLE "patch_tags_relations"
(
    patch uuid NOT NULL references patches ON DELETE CASCADE,
    tag   uuid NOT NULL references patch_tags ON DELETE CASCADE,
    PRIMARY KEY (patch, tag)
);


CREATE TABLE "patch_artists"
(
    id   uuid NOT NULL PRIMARY KEY,
    name text NOT NULL UNIQUE
);
CREATE TABLE "patch_artists_relations"
(
    patch  uuid NOT NULL references patches ON DELETE CASCADE,
    artist uuid NOT NULL references patch_artists ON DELETE CASCADE,
    PRIMARY KEY (patch, artist)
);
