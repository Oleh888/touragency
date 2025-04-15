/*
 * Основна таблиця інформації про туристів.
 * Для дітей вказується батько (parent_id).
 */
create table tourists
(
    id                        integer generated always as identity primary key,
    passport_number           varchar(100) unique,
    full_name                 varchar(100)                            not null,
    gender                    varchar(6) check (gender in ('male', 'female', 'other')),
    birth_date                date check (birth_date <= current_date) not null,
    accommodation_preferences varchar(200),
    category                  varchar(50)                             not null check (category in ('vacationer', 'cargo_tourist', 'child')),
    parent_id                 integer references tourists (id) on delete set null check (parent_id is null or parent_id <> id)
);
create index idx_tourists_passport on tourists (passport_number);
create index idx_tourists_name on tourists (full_name);

/*
 * Таблиця туристичних груп.
 */
create table tourist_groups
(
    id             integer generated always as identity primary key,
    departure_date date not null,
    arrival_date   date not null check (arrival_date > departure_date)
);

/*
 * Таблиця зв'язків між групами та туристами.
 * Кожен турист може належати до однієї або кількох груп.
 */
create table group_members
(
    group_id   integer references tourist_groups (id) on delete cascade,
    tourist_id integer not null references tourists (id) on delete cascade,
    primary key (group_id, tourist_id)
);

/* Тип для статусів віз: очікує, схвалено, відхилено */
create type visa_status as enum ('pending', 'approved', 'rejected');

/*
 * Візові документи туристів.
 * Містить інформацію про видані візи, їх тип та термін дії.
 */
create table visa_documents
(
    document_number varchar(50) primary key,
    tourist_id      integer     not null references tourists (id) on delete cascade,
    issue_date      date        not null,
    expiry_date     date        not null,
    visa_type       varchar(50) not null,
    status          visa_status not null
);

/*
 * Історія відвідувань країни туристами.
 * Фіксує дати в'їзду та виїзду для кожного туриста.
 */
create table country_visits
(
    tourist_id  integer     not null references tourists (id) on delete cascade,
    entry_date  date        not null,
    exit_date   date        not null check (entry_date < country_visits.exit_date),
    visa_number varchar(50) not null references visa_documents (document_number) on delete cascade,
    primary key (tourist_id, entry_date)
);

/*
 * Інформація про вантажі туристів.
 * Включає маркування, вагу, кількість місць та вартість послуг.
 */
create table cargo
(
    id             integer generated always as identity primary key,
    tourist_id     integer        not null references tourists (id) on delete cascade,
    marks          varchar(100) [],
    items_count    integer        not null check (items_count >= 0),
    total_weight   numeric(10, 2) not null check (total_weight >= 0),
    packaging_cost numeric(10, 2) default 0,
    insurance_cost numeric(10, 2) default 0,
    total_cost     numeric(10, 2) generated always as (packaging_cost + insurance_cost) stored
);

/*
 * Таблиця рейсів.
 * Містить інформацію про перельоти, аеропорти та вартість квитків.
 */
create table flights
(
    id                integer generated always as identity primary key,
    flight_number     varchar(20)    not null unique,
    departure_date    date           not null,
    arrival_date      date           not null check (arrival_date >= flights.departure_date),
    departure_airport varchar(100),
    arrival_airport   varchar(100),
    price_per_ticket  numeric(10, 2) not null
);
create index idx_flights_dates on flights (departure_date, arrival_date);

/*
 * Зв'язок між рейсами та вантажами.
 * Визначає, які вантажі перевозяться якими рейсами.
 */
create table flight_cargo
(
    flight_id integer not null references flights (id) on delete cascade,
    cargo_id  integer not null references cargo (id) on delete cascade,
    unique (flight_id, cargo_id)
);

/*
 * Пасажири рейсів.
 * Визначає, які туристи летять якими рейсами та їхні місця.
 */
create table flight_passengers
(
    flight_id  integer     not null references flights (id) on delete cascade,
    tourist_id integer     not null references tourists (id) on delete cascade,
    seat       varchar(10) not null,
    primary key (flight_id, tourist_id)
);

/*
 * Довідник готелів.
 * Містить контактну інформацію та адреси готелів.
 */
create table hotels
(
    id      integer generated always as identity primary key,
    name    varchar(100) not null unique,
    address varchar(200),
    phone   varchar(50)
);

/*
 * Бронювання готелів.
 * Містить інформацію про номери, ціни та дати заселення.
 */
create table hotel_bookings
(
    id              integer generated always as identity primary key,
    hotel_id        integer        not null references hotels (id) on delete cascade,
    room_number     varchar(20),
    price_per_night numeric(10, 2) not null,
    check_in_date   date           not null,
    check_out_date  date           not null check (check_out_date > check_in_date)
);

/*
 * Зв'язок між туристами та їх бронюваннями готелів.
 */
create table tourists_hotel_bookings
(
    tourist_id       integer references tourists (id) on delete cascade,
    hotel_booking_id integer references hotel_bookings (id) on delete cascade,
    primary key (tourist_id, hotel_booking_id)
);

/*
 * Каталог екскурсій.
 * Містить опис, дати проведення, ціни та інформацію про організаторів.
 */
create table excursions
(
    id             integer generated always as identity primary key,
    title          varchar(100)   not null,
    description    text,
    excursion_date date           not null,
    price          numeric(10, 2) not null check (price >= 0),
    agency_name    varchar(100)
);
create index idx_excursions_date on excursions (excursion_date);

/*
 * Учасники екскурсій.
 * Визначає, які туристи беруть участь у яких екскурсіях.
 */
create table excursion_participants
(
    tourist_id   integer not null references tourists (id) on delete cascade,
    excursion_id integer not null references excursions (id) on delete cascade,
    unique (tourist_id, excursion_id)
);

/*
 * Витрати, пов'язані з туристами.
 * Фіксує додаткові витрати з описом їх призначення.
 */
create table expenses
(
    id          integer generated always as identity primary key,
    tourist_id  integer      not null references tourists (id) on delete cascade,
    expense     numeric(10, 2) default 0,
    description varchar(100) not null
);

/*
 * Фінансові звіти представництва.
 * Агрегує всі витрати за групами туристів за певний період.
 */
create table financial_reports
(
    id                INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    report_date       DATE NOT NULL,
    tourist_group     INTEGER REFERENCES tourist_groups (id) on delete cascade,
    category          VARCHAR(50) CHECK (category IN ('vacationer', 'cargo_tourist', 'child', 'total')),
    hotel_expense     NUMERIC(10, 2) DEFAULT 0,
    flight_expense    NUMERIC(10, 2) DEFAULT 0,
    excursion_expense NUMERIC(10, 2) DEFAULT 0,
    other_expense     NUMERIC(10, 2) DEFAULT 0,
    total_expense     NUMERIC(10, 2) GENERATED ALWAYS AS (
        hotel_expense + flight_expense + excursion_expense + other_expense
        ) STORED,
    UNIQUE (tourist_group, category)
);
