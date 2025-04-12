create table tourist_categories
(
    id   integer generated always as identity primary key,
    name varchar(50) not null check (name in ('vacationer', 'cargo_tourist', 'child'))
);


create table tourists
(
    id                        integer generated always as identity primary key,
    passport_number           varchar(100) unique,
    full_name                 varchar(100)                            not null,
    gender                    varchar(6) check (gender in ('male', 'female', 'other')),
    birth_date                date check (birth_date <= current_date) not null,
    accommodation_preferences varchar(200),
    category_id               integer references tourist_categories (id),
    parent_id                 integer check (parent_id is null or id <> tourists.parent_id) references tourists (id)
);
create index idx_tourists_passport on tourists (passport_number);
create index idx_tourists_name on tourists (full_name);


create table tourist_groups
(
    id             integer generated always as identity primary key,
    group_code     varchar(50) not null unique,
    departure_date date        not null,
    arrival_date   date        not null check (arrival_date > tourist_groups.departure_date)
);


create table group_members
(
    group_id   integer references tourist_groups (id),
    tourist_id integer not null references tourists (id),
    primary key (group_id, tourist_id)
);


create table country_visits
(
    tourist_id integer not null references tourists (id),
    entry_date date    not null,
    exit_date  date    not null,
    primary key (tourist_id, entry_date)
);

create type visa_status as enum ('pending', 'approved', 'rejected');
create table visa_documents
(
    document_number varchar(50) primary key,
    tourist_id      integer     not null references tourists (id),
    issue_date      date        not null,
    expiry_date     date        not null,
    visa_type       varchar(50) not null check (visa_type in ('tourist', 'business', 'child-dependent')),
    status          visa_status not null
);


create table cargo
(
    id             integer generated always as identity primary key,
    tourist_id     integer        not null references tourists (id),
    marks          varchar(100) [],
    items_count    integer        not null check (items_count >= 0),
    total_weight   numeric(10, 2) not null check (total_weight >= 0),
    packaging_cost numeric(10, 2) default 0,
    insurance_cost numeric(10, 2) default 0,
    total_cost     numeric(10, 2) generated always as (
        packaging_cost + insurance_cost
        ) stored
);


create table flights
(
    id                integer generated always as identity primary key,
    flight_number     varchar(20)    not null unique,
    departure_date    date           not null,
    arrival_date      date           not null,
    departure_airport varchar(100),
    arrival_airport   varchar(100),
    price_per_ticket  numeric(10, 2) not null
);
create index idx_flights_dates on flights (departure_date, arrival_date);


create table flight_cargo
(
    flight_id integer not null references flights (id),
    cargo_id  integer not null references cargo (id),
    unique (flight_id, cargo_id)
);


create table flight_passengers
(
    flight_id  integer not null references flights (id),
    tourist_id integer not null references tourists (id),
    seat       varchar(10),
    unique (flight_id, tourist_id)
);


create table hotels
(
    id      integer generated always as identity primary key,
    name    varchar(100) not null,
    address varchar(200),
    phone   varchar(50)
);


create table hotel_bookings
(
    id              integer generated always as identity primary key,
    hotel_id        integer        not null references hotels (id),
    room_number     varchar(20),
    price_per_night numeric(10, 2) not null,
    check_in_date   date           not null,
    check_out_date  date           not null check (check_out_date > check_in_date)
);


create table tourists_hotel_bookings
(
    tourist_id       integer references tourists (id),
    hotel_booking_id integer references hotel_bookings (id),
    unique (tourist_id, hotel_booking_id)
);


create table excursions
(
    id             integer generated always as identity primary key,
    title          varchar(100)   not null,
    description    text,
    excursion_date date           not null,
    price          numeric(10, 2) not null check (price >= 0),
    agency_name    varchar(100)
);
create index dx_excursions_date on excursions (excursion_date);

create table excursion_participants
(
    tourist_id   integer not null references tourists (id),
    excursion_id integer not null references excursions (id),
    unique (tourist_id, excursion_id)
);


create table expenses
(
    tourist_id  integer      not null references tourists (id),
    expense     numeric(10, 2) default 0,
    description varchar(100) not null
);

create table financial_reports
(
    id                integer generated always as identity primary key,
    report_date       date not null,
    tourist_group     integer references tourist_groups (id),
    hotel_expense     numeric(10, 2) default 0,
    flight_expense    numeric(10, 2) default 0,
    excursion_expense numeric(10, 2) default 0,
    other_expense     numeric(10, 2) default 0,
    total_expense     numeric(10, 2) generated always as (
        hotel_expense + flight_expense + excursion_expense + other_expense
        ) stored
);
