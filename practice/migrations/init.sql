
CREATE TABLE stations (
    station_id      integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    code text NOT NULL UNIQUE
    CHECK (code = upper(code) AND length(code) BETWEEN 2 AND 5),
    name            text     NOT NULL,
    city            text     NOT NULL,
    state           text     NOT NULL,
    zone            text     NOT NULL,   -- NR, WR, SR, ER, ...
    num_platforms   smallint NOT NULL CHECK (num_platforms > 0)
);
 
-- ------------------------------------------------------------
-- 2. trains
--    runs_on is a 7-char Mon..Sun mask, e.g. 'YYYYYYN' = not on Sunday.
--    A real system would model this better; here it buys you string-function practice.
-- ------------------------------------------------------------
CREATE TABLE trains (
    train_id        integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    number          char(5)  NOT NULL UNIQUE CHECK (number ~ '^[0-9]{5}$'),
    name            text     NOT NULL,
    train_type      text     NOT NULL
    CHECK (train_type IN ('PASSENGER','EXPRESS','SUPERFAST',
    'RAJDHANI','SHATABDI','VANDE_BHARAT')),
    runs_on   char(7)  NOT NULL CHECK (runs_on ~ '^[YN]{7}$'),
    has_pantry boolean  NOT NULL DEFAULT false
);
 
-- ------------------------------------------------------------
-- 3. train_stops  -- the route. Composite PK, self-joinable, ordered.
--    day_offset: 0 = same day as origin departure, 1 = next day, ...
-- ------------------------------------------------------------
CREATE TABLE train_stops (
    train_id        integer  NOT NULL REFERENCES trains ON DELETE CASCADE,
    stop_seq        smallint NOT NULL CHECK (stop_seq > 0),
    station_id      integer  NOT NULL REFERENCES stations,
    arrival_time    time,                  -- NULL at the origin
    departure_time  time,                  -- NULL at the terminus
    day_offset      smallint NOT NULL DEFAULT 0 CHECK (day_offset BETWEEN 0 AND 5),
    distance_km     integer  NOT NULL CHECK (distance_km >= 0),
    PRIMARY KEY (train_id, stop_seq),
    UNIQUE (train_id, station_id),         -- a train visits a station at most once
    UNIQUE (train_id, distance_km),        -- distances strictly increase along the route
    CHECK (arrival_time IS NOT NULL OR departure_time IS NOT NULL)
);
 
-- ------------------------------------------------------------
-- 4. passengers
-- ------------------------------------------------------------
CREATE TABLE passengers (
    passenger_id    integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    full_name       text        NOT NULL,
    email           text        UNIQUE,                -- deliberately nullable
    phone           text        NOT NULL CHECK (phone ~ '^[0-9]{10}$'),
    date_of_birth   date        NOT NULL CHECK (date_of_birth > DATE '1900-01-01'),
    gender          char(1)     NOT NULL CHECK (gender IN ('M','F','O')),
    city            text,
    created_at      timestamptz NOT NULL DEFAULT now()
);
 
-- ------------------------------------------------------------
-- 5. bookings  -- the fact table: every aggregate you write lands here
-- ------------------------------------------------------------
CREATE TABLE bookings (
    booking_id      bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    pnr             char(10)    NOT NULL UNIQUE CHECK (pnr ~ '^[0-9]{10}$'),
    passenger_id    integer     NOT NULL REFERENCES passengers,
    train_id        integer     NOT NULL REFERENCES trains,
    from_station_id integer     NOT NULL REFERENCES stations,
    to_station_id   integer     NOT NULL REFERENCES stations,
    journey_date    date        NOT NULL,
    booked_at       timestamptz NOT NULL DEFAULT now(),
    travel_class    text        NOT NULL
    CHECK (travel_class IN ('1A','2A','3A','SL','CC','2S')),
    seat_no         text,
    status          text        NOT NULL
    CHECK (status IN ('CONFIRMED','RAC','WAITLIST','CANCELLED')),
    fare            numeric(8,2) NOT NULL CHECK (fare >= 0),
    CHECK (from_station_id <> to_station_id),
    -- a waitlisted ticket has no berth yet; a confirmed one must have exactly one
    CHECK ((status = 'WAITLIST') = (seat_no IS NULL))
);