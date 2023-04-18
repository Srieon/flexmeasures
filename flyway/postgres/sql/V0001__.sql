--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Debian 15.2-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- CREATE SCHEMA "public";


--
-- Name: SCHEMA "public"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA "public" IS 'standard public schema';


--
-- Name: annotation_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."annotation_type" AS ENUM (
    'alert',
    'holiday',
    'label',
    'feedback'
);


SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- Name: account; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."account" (
    "id" integer NOT NULL,
    "name" character varying(100)
);


--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."account_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."account_id_seq" OWNED BY "public"."account"."id";


--
-- Name: account_role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."account_role" (
    "id" integer NOT NULL,
    "name" character varying(80),
    "description" character varying(255)
);


--
-- Name: account_role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."account_role_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: account_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."account_role_id_seq" OWNED BY "public"."account_role"."id";


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."alembic_version" (
    "version_num" character varying(32) NOT NULL
);


--
-- Name: annotation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."annotation" (
    "id" integer NOT NULL,
    "start" timestamp with time zone NOT NULL,
    "end" timestamp with time zone NOT NULL,
    "belief_time" timestamp with time zone,
    "source_id" integer NOT NULL,
    "type" "public"."annotation_type" NOT NULL,
    "content" character varying(1024) NOT NULL
);


--
-- Name: annotation_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."annotation_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: annotation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."annotation_id_seq" OWNED BY "public"."annotation"."id";


--
-- Name: annotations_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."annotations_accounts" (
    "id" integer NOT NULL,
    "account_id" integer,
    "annotation_id" integer
);


--
-- Name: annotations_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."annotations_accounts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: annotations_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."annotations_accounts_id_seq" OWNED BY "public"."annotations_accounts"."id";


--
-- Name: annotations_assets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."annotations_assets" (
    "id" integer NOT NULL,
    "generic_asset_id" integer,
    "annotation_id" integer
);


--
-- Name: annotations_assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."annotations_assets_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: annotations_assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."annotations_assets_id_seq" OWNED BY "public"."annotations_assets"."id";


--
-- Name: annotations_sensors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."annotations_sensors" (
    "id" integer NOT NULL,
    "sensor_id" integer,
    "annotation_id" integer
);


--
-- Name: annotations_sensors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."annotations_sensors_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: annotations_sensors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."annotations_sensors_id_seq" OWNED BY "public"."annotations_sensors"."id";


--
-- Name: asset; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."asset" (
    "id" integer NOT NULL,
    "asset_type_name" character varying(80) NOT NULL,
    "name" character varying(80),
    "display_name" character varying(80),
    "capacity_in_mw" double precision NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "owner_id" integer,
    "min_soc_in_mwh" double precision,
    "max_soc_in_mwh" double precision,
    "soc_in_mwh" double precision,
    "soc_datetime" timestamp with time zone,
    "soc_udi_event_id" integer,
    "unit" character varying(80) DEFAULT ''::character varying NOT NULL,
    "market_id" integer,
    "event_resolution" interval DEFAULT '00:00:00'::interval NOT NULL,
    "knowledge_horizon_fnc" character varying(80) NOT NULL,
    "knowledge_horizon_par" "json" NOT NULL,
    "timezone" character varying(80) NOT NULL
);


--
-- Name: asset_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."asset_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."asset_id_seq" OWNED BY "public"."asset"."id";


--
-- Name: asset_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."asset_type" (
    "name" character varying(80) NOT NULL,
    "is_consumer" boolean NOT NULL,
    "is_producer" boolean NOT NULL,
    "can_curtail" boolean NOT NULL,
    "can_shift" boolean NOT NULL,
    "daily_seasonality" boolean NOT NULL,
    "weekly_seasonality" boolean NOT NULL,
    "yearly_seasonality" boolean NOT NULL,
    "display_name" character varying(80) DEFAULT ''::character varying,
    "hover_label" character varying(80)
);


--
-- Name: data_source; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."data_source" (
    "id" integer NOT NULL,
    "name" character varying(80) NOT NULL,
    "type" character varying(80),
    "user_id" integer,
    "model" character varying(80),
    "version" character varying(17)
);


--
-- Name: data_source_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."data_source_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_source_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."data_source_id_seq" OWNED BY "public"."data_source"."id";


--
-- Name: fm_user; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fm_user" (
    "id" integer NOT NULL,
    "email" character varying(255),
    "username" character varying(255),
    "password" character varying(255),
    "last_login_at" timestamp without time zone,
    "login_count" integer,
    "active" boolean,
    "timezone" character varying(255),
    "fs_uniquifier" character varying(64) NOT NULL,
    "account_id" integer NOT NULL,
    "last_seen_at" timestamp without time zone
);


--
-- Name: fm_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."fm_user_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fm_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."fm_user_id_seq" OWNED BY "public"."fm_user"."id";


--
-- Name: generic_asset; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."generic_asset" (
    "id" integer NOT NULL,
    "name" character varying(80),
    "latitude" double precision,
    "longitude" double precision,
    "generic_asset_type_id" integer NOT NULL,
    "account_id" integer,
    "attributes" "json" NOT NULL
);


--
-- Name: generic_asset_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."generic_asset_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: generic_asset_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."generic_asset_id_seq" OWNED BY "public"."generic_asset"."id";


--
-- Name: generic_asset_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."generic_asset_type" (
    "id" integer NOT NULL,
    "name" character varying(80),
    "description" character varying(80)
);


--
-- Name: generic_asset_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."generic_asset_type_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: generic_asset_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."generic_asset_type_id_seq" OWNED BY "public"."generic_asset_type"."id";


--
-- Name: latest_task_run; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."latest_task_run" (
    "name" character varying(80) NOT NULL,
    "datetime" timestamp with time zone,
    "status" boolean
);


--
-- Name: market; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."market" (
    "id" integer NOT NULL,
    "name" character varying(80),
    "market_type_name" character varying(80) NOT NULL,
    "display_name" character varying(80) DEFAULT ''::character varying,
    "unit" character varying(80) DEFAULT ''::character varying NOT NULL,
    "event_resolution" interval DEFAULT '00:00:00'::interval NOT NULL,
    "knowledge_horizon_fnc" character varying(80) NOT NULL,
    "knowledge_horizon_par" "json" NOT NULL,
    "timezone" character varying(80) NOT NULL
);


--
-- Name: market_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."market_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: market_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."market_id_seq" OWNED BY "public"."market"."id";


--
-- Name: market_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."market_type" (
    "name" character varying(80) NOT NULL,
    "daily_seasonality" boolean NOT NULL,
    "weekly_seasonality" boolean NOT NULL,
    "yearly_seasonality" boolean NOT NULL,
    "display_name" character varying(80) DEFAULT ''::character varying
);


--
-- Name: power; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."power" (
    "datetime" timestamp with time zone NOT NULL,
    "sensor_id" integer NOT NULL,
    "value" double precision NOT NULL,
    "horizon" interval NOT NULL,
    "data_source_id" integer NOT NULL
);


--
-- Name: price; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."price" (
    "datetime" timestamp with time zone NOT NULL,
    "sensor_id" integer NOT NULL,
    "value" double precision NOT NULL,
    "horizon" interval NOT NULL,
    "data_source_id" integer NOT NULL
);


--
-- Name: role; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."role" (
    "id" integer NOT NULL,
    "name" character varying(80),
    "description" character varying(255)
);


--
-- Name: role_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."role_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."role_id_seq" OWNED BY "public"."role"."id";


--
-- Name: roles_accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."roles_accounts" (
    "id" integer NOT NULL,
    "account_id" integer,
    "role_id" integer
);


--
-- Name: roles_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."roles_accounts_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."roles_accounts_id_seq" OWNED BY "public"."roles_accounts"."id";


--
-- Name: roles_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."roles_users" (
    "id" integer NOT NULL,
    "user_id" integer,
    "role_id" integer
);


--
-- Name: roles_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."roles_users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."roles_users_id_seq" OWNED BY "public"."roles_users"."id";


--
-- Name: sensor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sensor" (
    "id" integer NOT NULL,
    "name" character varying(120) NOT NULL,
    "unit" character varying(80) NOT NULL,
    "timezone" character varying(80) NOT NULL,
    "event_resolution" interval NOT NULL,
    "knowledge_horizon_fnc" character varying(80) NOT NULL,
    "knowledge_horizon_par" "json" NOT NULL,
    "generic_asset_id" integer NOT NULL,
    "attributes" "json" NOT NULL
);


--
-- Name: sensor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."sensor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."sensor_id_seq" OWNED BY "public"."sensor"."id";


--
-- Name: timed_belief; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."timed_belief" (
    "event_start" timestamp with time zone NOT NULL,
    "belief_horizon" interval NOT NULL,
    "cumulative_probability" double precision NOT NULL,
    "event_value" double precision NOT NULL,
    "sensor_id" integer NOT NULL,
    "source_id" integer NOT NULL
);


--
-- Name: weather; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."weather" (
    "sensor_id" integer NOT NULL,
    "datetime" timestamp with time zone NOT NULL,
    "value" double precision NOT NULL,
    "horizon" interval NOT NULL,
    "data_source_id" integer NOT NULL
);


--
-- Name: weather_sensor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."weather_sensor" (
    "id" integer NOT NULL,
    "name" character varying(80),
    "weather_sensor_type_name" character varying(80) NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "unit" character varying(80) DEFAULT ''::character varying NOT NULL,
    "display_name" character varying(80) DEFAULT ''::character varying,
    "event_resolution" interval DEFAULT '00:00:00'::interval NOT NULL,
    "knowledge_horizon_fnc" character varying(80) NOT NULL,
    "knowledge_horizon_par" "json" NOT NULL,
    "timezone" character varying(80) NOT NULL
);


--
-- Name: weather_sensor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."weather_sensor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weather_sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."weather_sensor_id_seq" OWNED BY "public"."weather_sensor"."id";


--
-- Name: weather_sensor_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."weather_sensor_type" (
    "name" character varying(80) NOT NULL,
    "display_name" character varying(80) DEFAULT ''::character varying
);


--
-- Name: account id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."account" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."account_id_seq"'::"regclass");


--
-- Name: account_role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."account_role" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."account_role_id_seq"'::"regclass");


--
-- Name: annotation id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotation" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."annotation_id_seq"'::"regclass");


--
-- Name: annotations_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_accounts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."annotations_accounts_id_seq"'::"regclass");


--
-- Name: annotations_assets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_assets" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."annotations_assets_id_seq"'::"regclass");


--
-- Name: annotations_sensors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_sensors" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."annotations_sensors_id_seq"'::"regclass");


--
-- Name: asset id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."asset_id_seq"'::"regclass");


--
-- Name: data_source id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."data_source" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."data_source_id_seq"'::"regclass");


--
-- Name: fm_user id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fm_user" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."fm_user_id_seq"'::"regclass");


--
-- Name: generic_asset id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generic_asset" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."generic_asset_id_seq"'::"regclass");


--
-- Name: generic_asset_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generic_asset_type" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."generic_asset_type_id_seq"'::"regclass");


--
-- Name: market id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."market" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."market_id_seq"'::"regclass");


--
-- Name: role id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."role" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."role_id_seq"'::"regclass");


--
-- Name: roles_accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_accounts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."roles_accounts_id_seq"'::"regclass");


--
-- Name: roles_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_users" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."roles_users_id_seq"'::"regclass");


--
-- Name: sensor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sensor" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."sensor_id_seq"'::"regclass");


--
-- Name: weather_sensor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather_sensor" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."weather_sensor_id_seq"'::"regclass");


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."account" ("id", "name") VALUES (1, 'Docker Toy Account');


--
-- Data for Name: account_role; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."alembic_version" ("version_num") VALUES ('75f53d2dbfae');


--
-- Data for Name: annotation; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: annotations_accounts; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: annotations_assets; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: annotations_sensors; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: asset; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: asset_type; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: data_source; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."data_source" ("id", "name", "type", "user_id", "model", "version") VALUES (1, 'toy-user', 'user', 1, NULL, NULL);


--
-- Data for Name: fm_user; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."fm_user" ("id", "email", "username", "password", "last_login_at", "login_count", "active", "timezone", "fs_uniquifier", "account_id", "last_seen_at") VALUES (1, 'toy-user@flexmeasures.io', 'toy-user', '$2b$12$O9xdDI1DdWPRpvJnv5pymOJrTnWkRgULcBrKrqX6mFW9SFCeZiwTS', NULL, NULL, true, 'Europe/Amsterdam', '31d57366248144c4a5513834884116af', 1, NULL);


--
-- Data for Name: generic_asset; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."generic_asset" ("id", "name", "latitude", "longitude", "generic_asset_type_id", "account_id", "attributes") VALUES (1, 'toy-solar', 52.374, 4.88969, 1, 1, '{}');
INSERT INTO "public"."generic_asset" ("id", "name", "latitude", "longitude", "generic_asset_type_id", "account_id", "attributes") VALUES (2, 'toy-building', 52.374, 4.88969, 6, 1, '{}');
INSERT INTO "public"."generic_asset" ("id", "name", "latitude", "longitude", "generic_asset_type_id", "account_id", "attributes") VALUES (4, 'NL transmission zone', NULL, NULL, 7, NULL, '{}');
INSERT INTO "public"."generic_asset" ("id", "name", "latitude", "longitude", "generic_asset_type_id", "account_id", "attributes") VALUES (3, 'toy-battery', 52.374, 4.88969, 5, 1, '{"capacity_in_mw": 0.5, "min_soc_in_mwh": 0.05, "max_soc_in_mwh": 0.45, "sensors_to_show": [3, 2]}');


--
-- Data for Name: generic_asset_type; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."generic_asset_type" ("id", "name", "description") VALUES (1, 'solar', 'solar panel(s)');
INSERT INTO "public"."generic_asset_type" ("id", "name", "description") VALUES (2, 'wind', 'wind turbine');
INSERT INTO "public"."generic_asset_type" ("id", "name", "description") VALUES (3, 'one-way_evse', 'uni-directional Electric Vehicle Supply Equipment');
INSERT INTO "public"."generic_asset_type" ("id", "name", "description") VALUES (4, 'two-way_evse', 'bi-directional Electric Vehicle Supply Equipment');
INSERT INTO "public"."generic_asset_type" ("id", "name", "description") VALUES (5, 'battery', 'stationary battery');
INSERT INTO "public"."generic_asset_type" ("id", "name", "description") VALUES (6, 'building', 'building');
INSERT INTO "public"."generic_asset_type" ("id", "name", "description") VALUES (7, 'transmission zone', 'A grid regulated & balanced as a whole, usually a national grid.');


--
-- Data for Name: latest_task_run; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: market; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: market_type; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: power; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: price; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."role" ("id", "name", "description") VALUES (1, 'account-admin', NULL);


--
-- Data for Name: roles_accounts; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: roles_users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."roles_users" ("id", "user_id", "role_id") VALUES (1, 1, 1);


--
-- Data for Name: sensor; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO "public"."sensor" ("id", "name", "unit", "timezone", "event_resolution", "knowledge_horizon_fnc", "knowledge_horizon_par", "generic_asset_id", "attributes") VALUES (2, 'discharging', 'MW', 'Europe/Amsterdam', '00:15:00', 'ex_post', '{"ex_post_horizon": "P0D"}', 3, '{}');
INSERT INTO "public"."sensor" ("id", "name", "unit", "timezone", "event_resolution", "knowledge_horizon_fnc", "knowledge_horizon_par", "generic_asset_id", "attributes") VALUES (3, 'Day ahead prices', 'EUR/MWh', 'Europe/Amsterdam', '01:00:00', 'x_days_ago_at_y_oclock', '{"x": 1, "y": 12, "z": "Europe/Paris"}', 4, '{}');


--
-- Data for Name: timed_belief; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: weather; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: weather_sensor; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Data for Name: weather_sensor_type; Type: TABLE DATA; Schema: public; Owner: -
--



--
-- Name: account_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."account_id_seq"', 1, true);


--
-- Name: account_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."account_role_id_seq"', 1, false);


--
-- Name: annotation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."annotation_id_seq"', 1, false);


--
-- Name: annotations_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."annotations_accounts_id_seq"', 1, false);


--
-- Name: annotations_assets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."annotations_assets_id_seq"', 1, false);


--
-- Name: annotations_sensors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."annotations_sensors_id_seq"', 1, false);


--
-- Name: asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."asset_id_seq"', 1, false);


--
-- Name: data_source_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."data_source_id_seq"', 1, true);


--
-- Name: fm_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."fm_user_id_seq"', 1, true);


--
-- Name: generic_asset_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."generic_asset_id_seq"', 4, true);


--
-- Name: generic_asset_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."generic_asset_type_id_seq"', 7, true);


--
-- Name: market_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."market_id_seq"', 1, false);


--
-- Name: role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."role_id_seq"', 1, true);


--
-- Name: roles_accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."roles_accounts_id_seq"', 1, false);


--
-- Name: roles_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."roles_users_id_seq"', 1, true);


--
-- Name: sensor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."sensor_id_seq"', 3, true);


--
-- Name: weather_sensor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."weather_sensor_id_seq"', 1, false);


--
-- Name: account account_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."account"
    ADD CONSTRAINT "account_name_key" UNIQUE ("name");


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."account"
    ADD CONSTRAINT "account_pkey" PRIMARY KEY ("id");


--
-- Name: account_role account_role_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."account_role"
    ADD CONSTRAINT "account_role_name_key" UNIQUE ("name");


--
-- Name: account_role account_role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."account_role"
    ADD CONSTRAINT "account_role_pkey" PRIMARY KEY ("id");


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."alembic_version"
    ADD CONSTRAINT "alembic_version_pkc" PRIMARY KEY ("version_num");


--
-- Name: annotation annotation_content_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotation"
    ADD CONSTRAINT "annotation_content_key" UNIQUE ("content", "start", "belief_time", "source_id", "type");


--
-- Name: annotation annotation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotation"
    ADD CONSTRAINT "annotation_pkey" PRIMARY KEY ("id");


--
-- Name: annotations_accounts annotations_accounts_annotation_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_accounts"
    ADD CONSTRAINT "annotations_accounts_annotation_id_key" UNIQUE ("annotation_id", "account_id");


--
-- Name: annotations_accounts annotations_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_accounts"
    ADD CONSTRAINT "annotations_accounts_pkey" PRIMARY KEY ("id");


--
-- Name: annotations_assets annotations_assets_annotation_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_assets"
    ADD CONSTRAINT "annotations_assets_annotation_id_key" UNIQUE ("annotation_id", "generic_asset_id");


--
-- Name: annotations_assets annotations_assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_assets"
    ADD CONSTRAINT "annotations_assets_pkey" PRIMARY KEY ("id");


--
-- Name: annotations_sensors annotations_sensors_annotation_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_sensors"
    ADD CONSTRAINT "annotations_sensors_annotation_id_key" UNIQUE ("annotation_id", "sensor_id");


--
-- Name: annotations_sensors annotations_sensors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_sensors"
    ADD CONSTRAINT "annotations_sensors_pkey" PRIMARY KEY ("id");


--
-- Name: asset asset_display_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset"
    ADD CONSTRAINT "asset_display_name_key" UNIQUE ("display_name");


--
-- Name: asset asset_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset"
    ADD CONSTRAINT "asset_name_key" UNIQUE ("name");


--
-- Name: asset asset_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset"
    ADD CONSTRAINT "asset_pkey" PRIMARY KEY ("id");


--
-- Name: asset_type asset_type_display_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset_type"
    ADD CONSTRAINT "asset_type_display_name_key" UNIQUE ("display_name");


--
-- Name: asset_type asset_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset_type"
    ADD CONSTRAINT "asset_type_pkey" PRIMARY KEY ("name");


--
-- Name: roles_users bvp_roles_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_users"
    ADD CONSTRAINT "bvp_roles_users_pkey" PRIMARY KEY ("id");


--
-- Name: data_source data_source_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."data_source"
    ADD CONSTRAINT "data_source_name_key" UNIQUE ("name", "user_id", "model", "version");


--
-- Name: data_source data_source_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."data_source"
    ADD CONSTRAINT "data_source_user_id_key" UNIQUE ("user_id");


--
-- Name: data_source data_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."data_source"
    ADD CONSTRAINT "data_sources_pkey" PRIMARY KEY ("id");


--
-- Name: fm_user fm_user_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fm_user"
    ADD CONSTRAINT "fm_user_email_key" UNIQUE ("email");


--
-- Name: fm_user fm_user_fs_uniquifier_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fm_user"
    ADD CONSTRAINT "fm_user_fs_uniquifier_key" UNIQUE ("fs_uniquifier");


--
-- Name: fm_user fm_user_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fm_user"
    ADD CONSTRAINT "fm_user_pkey" PRIMARY KEY ("id");


--
-- Name: fm_user fm_user_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fm_user"
    ADD CONSTRAINT "fm_user_username_key" UNIQUE ("username");


--
-- Name: generic_asset generic_asset_name_account_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generic_asset"
    ADD CONSTRAINT "generic_asset_name_account_id_key" UNIQUE ("name", "account_id");


--
-- Name: generic_asset generic_asset_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generic_asset"
    ADD CONSTRAINT "generic_asset_pkey" PRIMARY KEY ("id");


--
-- Name: generic_asset_type generic_asset_type_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generic_asset_type"
    ADD CONSTRAINT "generic_asset_type_name_key" UNIQUE ("name");


--
-- Name: generic_asset_type generic_asset_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generic_asset_type"
    ADD CONSTRAINT "generic_asset_type_pkey" PRIMARY KEY ("id");


--
-- Name: latest_task_run latest_task_run_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."latest_task_run"
    ADD CONSTRAINT "latest_task_run_pkey" PRIMARY KEY ("name");


--
-- Name: market market_display_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."market"
    ADD CONSTRAINT "market_display_name_key" UNIQUE ("display_name");


--
-- Name: market market_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."market"
    ADD CONSTRAINT "market_name_key" UNIQUE ("name");


--
-- Name: market market_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."market"
    ADD CONSTRAINT "market_pkey" PRIMARY KEY ("id");


--
-- Name: market_type market_type_display_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."market_type"
    ADD CONSTRAINT "market_type_display_name_key" UNIQUE ("display_name");


--
-- Name: market_type market_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."market_type"
    ADD CONSTRAINT "market_type_pkey" PRIMARY KEY ("name");


--
-- Name: power power_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."power"
    ADD CONSTRAINT "power_pkey" PRIMARY KEY ("datetime", "sensor_id", "horizon", "data_source_id");


--
-- Name: price price_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."price"
    ADD CONSTRAINT "price_pkey" PRIMARY KEY ("datetime", "sensor_id", "horizon", "data_source_id");


--
-- Name: role role_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."role"
    ADD CONSTRAINT "role_name_key" UNIQUE ("name");


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."role"
    ADD CONSTRAINT "role_pkey" PRIMARY KEY ("id");


--
-- Name: roles_accounts roles_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_accounts"
    ADD CONSTRAINT "roles_accounts_pkey" PRIMARY KEY ("id");


--
-- Name: roles_accounts roles_accounts_role_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_accounts"
    ADD CONSTRAINT "roles_accounts_role_id_key" UNIQUE ("role_id", "account_id");


--
-- Name: roles_users roles_users_role_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_users"
    ADD CONSTRAINT "roles_users_role_id_key" UNIQUE ("role_id", "user_id");


--
-- Name: sensor sensor_name_generic_asset_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sensor"
    ADD CONSTRAINT "sensor_name_generic_asset_id_key" UNIQUE ("name", "generic_asset_id");


--
-- Name: sensor sensor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sensor"
    ADD CONSTRAINT "sensor_pkey" PRIMARY KEY ("id");


--
-- Name: timed_belief timed_belief_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."timed_belief"
    ADD CONSTRAINT "timed_belief_pkey" PRIMARY KEY ("event_start", "belief_horizon", "cumulative_probability", "sensor_id", "source_id");


--
-- Name: weather weather_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather"
    ADD CONSTRAINT "weather_pkey" PRIMARY KEY ("datetime", "sensor_id", "horizon", "data_source_id");


--
-- Name: weather_sensor weather_sensor_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather_sensor"
    ADD CONSTRAINT "weather_sensor_name_key" UNIQUE ("name");


--
-- Name: weather_sensor weather_sensor_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather_sensor"
    ADD CONSTRAINT "weather_sensor_pkey" PRIMARY KEY ("id");


--
-- Name: weather_sensor_type weather_sensor_type_display_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather_sensor_type"
    ADD CONSTRAINT "weather_sensor_type_display_name_key" UNIQUE ("display_name");


--
-- Name: weather_sensor weather_sensor_type_name_latitude_longitude_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather_sensor"
    ADD CONSTRAINT "weather_sensor_type_name_latitude_longitude_key" UNIQUE ("weather_sensor_type_name", "latitude", "longitude");


--
-- Name: weather_sensor_type weather_sensor_type_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather_sensor_type"
    ADD CONSTRAINT "weather_sensor_type_pkey" PRIMARY KEY ("name");


--
-- Name: asset_type_can_curtail_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "asset_type_can_curtail_idx" ON "public"."asset_type" USING "btree" ("can_curtail");


--
-- Name: asset_type_can_shift_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "asset_type_can_shift_idx" ON "public"."asset_type" USING "btree" ("can_shift");


--
-- Name: power_datetime_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "power_datetime_idx" ON "public"."power" USING "btree" ("datetime");


--
-- Name: power_sensor_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "power_sensor_id_idx" ON "public"."power" USING "btree" ("sensor_id");


--
-- Name: price_datetime_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "price_datetime_idx" ON "public"."price" USING "btree" ("datetime");


--
-- Name: price_sensor_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "price_sensor_id_idx" ON "public"."price" USING "btree" ("sensor_id");


--
-- Name: timed_belief_event_start_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "timed_belief_event_start_idx" ON "public"."timed_belief" USING "btree" ("event_start");


--
-- Name: timed_belief_sensor_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "timed_belief_sensor_id_idx" ON "public"."timed_belief" USING "btree" ("sensor_id");


--
-- Name: weather_datetime_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "weather_datetime_idx" ON "public"."weather" USING "btree" ("datetime");


--
-- Name: weather_sensor_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "weather_sensor_id_idx" ON "public"."weather" USING "btree" ("sensor_id");


--
-- Name: annotation annotation_source_id_data_source_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotation"
    ADD CONSTRAINT "annotation_source_id_data_source_fkey" FOREIGN KEY ("source_id") REFERENCES "public"."data_source"("id");


--
-- Name: annotations_accounts annotations_accounts_account_id_account_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_accounts"
    ADD CONSTRAINT "annotations_accounts_account_id_account_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."account"("id");


--
-- Name: annotations_accounts annotations_accounts_annotation_id_annotation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_accounts"
    ADD CONSTRAINT "annotations_accounts_annotation_id_annotation_fkey" FOREIGN KEY ("annotation_id") REFERENCES "public"."annotation"("id");


--
-- Name: annotations_assets annotations_assets_annotation_id_annotation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_assets"
    ADD CONSTRAINT "annotations_assets_annotation_id_annotation_fkey" FOREIGN KEY ("annotation_id") REFERENCES "public"."annotation"("id");


--
-- Name: annotations_assets annotations_assets_generic_asset_id_generic_asset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_assets"
    ADD CONSTRAINT "annotations_assets_generic_asset_id_generic_asset_fkey" FOREIGN KEY ("generic_asset_id") REFERENCES "public"."generic_asset"("id");


--
-- Name: annotations_sensors annotations_sensors_annotation_id_annotation_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_sensors"
    ADD CONSTRAINT "annotations_sensors_annotation_id_annotation_fkey" FOREIGN KEY ("annotation_id") REFERENCES "public"."annotation"("id");


--
-- Name: annotations_sensors annotations_sensors_sensor_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."annotations_sensors"
    ADD CONSTRAINT "annotations_sensors_sensor_id_sensor_fkey" FOREIGN KEY ("sensor_id") REFERENCES "public"."sensor"("id");


--
-- Name: asset asset_asset_type_name_asset_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset"
    ADD CONSTRAINT "asset_asset_type_name_asset_type_fkey" FOREIGN KEY ("asset_type_name") REFERENCES "public"."asset_type"("name");


--
-- Name: asset asset_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset"
    ADD CONSTRAINT "asset_id_sensor_fkey" FOREIGN KEY ("id") REFERENCES "public"."sensor"("id") ON DELETE CASCADE;


--
-- Name: asset asset_market_id_market_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset"
    ADD CONSTRAINT "asset_market_id_market_fkey" FOREIGN KEY ("market_id") REFERENCES "public"."market"("id");


--
-- Name: asset asset_owner_id_bvp_users_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."asset"
    ADD CONSTRAINT "asset_owner_id_bvp_users_fkey" FOREIGN KEY ("owner_id") REFERENCES "public"."fm_user"("id") ON DELETE CASCADE;


--
-- Name: roles_users bvp_roles_users_role_id_bvp_roles_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_users"
    ADD CONSTRAINT "bvp_roles_users_role_id_bvp_roles_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."role"("id");


--
-- Name: roles_users bvp_roles_users_user_id_bvp_users_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_users"
    ADD CONSTRAINT "bvp_roles_users_user_id_bvp_users_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."fm_user"("id");


--
-- Name: data_source data_sources_user_id_bvp_users_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."data_source"
    ADD CONSTRAINT "data_sources_user_id_bvp_users_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."fm_user"("id");


--
-- Name: fm_user fm_user_account_id_account_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fm_user"
    ADD CONSTRAINT "fm_user_account_id_account_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."account"("id");


--
-- Name: generic_asset generic_asset_account_id_account_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generic_asset"
    ADD CONSTRAINT "generic_asset_account_id_account_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."account"("id") ON DELETE CASCADE;


--
-- Name: generic_asset generic_asset_generic_asset_type_id_generic_asset_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."generic_asset"
    ADD CONSTRAINT "generic_asset_generic_asset_type_id_generic_asset_type_fkey" FOREIGN KEY ("generic_asset_type_id") REFERENCES "public"."generic_asset_type"("id");


--
-- Name: market market_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."market"
    ADD CONSTRAINT "market_id_sensor_fkey" FOREIGN KEY ("id") REFERENCES "public"."sensor"("id");


--
-- Name: market market_market_type_name_market_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."market"
    ADD CONSTRAINT "market_market_type_name_market_type_fkey" FOREIGN KEY ("market_type_name") REFERENCES "public"."market_type"("name");


--
-- Name: power power_data_source_data_sources_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."power"
    ADD CONSTRAINT "power_data_source_data_sources_fkey" FOREIGN KEY ("data_source_id") REFERENCES "public"."data_source"("id");


--
-- Name: power power_sensor_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."power"
    ADD CONSTRAINT "power_sensor_id_sensor_fkey" FOREIGN KEY ("sensor_id") REFERENCES "public"."sensor"("id") ON DELETE CASCADE;


--
-- Name: price price_data_source_data_sources_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."price"
    ADD CONSTRAINT "price_data_source_data_sources_fkey" FOREIGN KEY ("data_source_id") REFERENCES "public"."data_source"("id");


--
-- Name: price price_sensor_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."price"
    ADD CONSTRAINT "price_sensor_id_sensor_fkey" FOREIGN KEY ("sensor_id") REFERENCES "public"."sensor"("id");


--
-- Name: roles_accounts roles_accounts_account_id_account_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_accounts"
    ADD CONSTRAINT "roles_accounts_account_id_account_fkey" FOREIGN KEY ("account_id") REFERENCES "public"."account"("id");


--
-- Name: roles_accounts roles_accounts_role_id_account_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles_accounts"
    ADD CONSTRAINT "roles_accounts_role_id_account_role_fkey" FOREIGN KEY ("role_id") REFERENCES "public"."account_role"("id");


--
-- Name: sensor sensor_generic_asset_id_generic_asset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sensor"
    ADD CONSTRAINT "sensor_generic_asset_id_generic_asset_fkey" FOREIGN KEY ("generic_asset_id") REFERENCES "public"."generic_asset"("id") ON DELETE CASCADE;


--
-- Name: timed_belief timed_belief_sensor_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."timed_belief"
    ADD CONSTRAINT "timed_belief_sensor_id_sensor_fkey" FOREIGN KEY ("sensor_id") REFERENCES "public"."sensor"("id") ON DELETE CASCADE;


--
-- Name: timed_belief timed_belief_source_id_source_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."timed_belief"
    ADD CONSTRAINT "timed_belief_source_id_source_fkey" FOREIGN KEY ("source_id") REFERENCES "public"."data_source"("id") ON DELETE CASCADE;


--
-- Name: weather weather_data_source_data_sources_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather"
    ADD CONSTRAINT "weather_data_source_data_sources_fkey" FOREIGN KEY ("data_source_id") REFERENCES "public"."data_source"("id");


--
-- Name: weather_sensor weather_sensor_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather_sensor"
    ADD CONSTRAINT "weather_sensor_id_sensor_fkey" FOREIGN KEY ("id") REFERENCES "public"."sensor"("id");


--
-- Name: weather weather_sensor_id_sensor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather"
    ADD CONSTRAINT "weather_sensor_id_sensor_fkey" FOREIGN KEY ("sensor_id") REFERENCES "public"."sensor"("id");


--
-- Name: weather_sensor weather_sensor_weather_sensor_type_name_weather_sensor__1390; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."weather_sensor"
    ADD CONSTRAINT "weather_sensor_weather_sensor_type_name_weather_sensor__1390" FOREIGN KEY ("weather_sensor_type_name") REFERENCES "public"."weather_sensor_type"("name");


--
-- PostgreSQL database dump complete
--

