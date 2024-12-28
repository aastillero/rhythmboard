CREATE TABLE pi_panel_info (jobPanelId INTEGER PRIMARY KEY, jobPanelTime VARCHAR(20), jobPanelDate VARCHAR(20), jobSession VARCHAR(20));
CREATE TABLE pi_heat (heatId INTEGER PRIMARY KEY, heatName VARCHAR(20), sessionKey INTEGER, heatTime VARCHAR(20),heatDate VARCHAR(20), heatDance VARCHAR(100), heatDesc VARCHAR(100),heatStatus INTEGER, panelId INTEGER);
CREATE TABLE pi_sub_heat (subHeatId INTEGER PRIMARY KEY, sequenceId INTEGER, subHeatType VARCHAR(20), subHeatDance VARCHAR(20), subHeatLevel VARCHAR(20), subHeatAge VARCHAR(20), heatId INTEGER, FOREIGN KEY(heatId) REFERENCES pi_heat(heatId) ON DELETE CASCADE);
CREATE TABLE pi_entry (entryId INTEGER PRIMARY KEY, entryKey VARCHAR(20), entryType INTEGER,primaryEntry VARCHAR(5), entryStatus INTEGER, peopleId INTEGER, heatId INTEGER, subHeatId INTEGER, onDeck INTEGER, onFloor INTEGER,entryStarted INTEGER);
CREATE TABLE pi_couple (coupleId INTEGER PRIMARY KEY, entryKey VARCHAR(20),personId1 INTEGER, personId2 INTEGER,coupleCategory VARCHAR(10), uploadId INTEGER, isScratched INTEGER, booked INTEGER, danced INTEGER, future, INTEGER, total INTEGER);
CREATE TABLE pi_person (personId INTEGER PRIMARY KEY, personKey INTEGER, firstName TEXT, lastName TEXT, gender VARCHAR(6), personType VARCHAR(6), studioId INTEGER, studioKey VARCHAR(20), nickName VARCHAR(20),memberNumber VARCHAR(6) ,competitorNumber VARCHAR(6),uploadId INTEGER);
CREATE TABLE pi_people (peopleId INTEGER PRIMARY KEY, peopleKey INTEGER, peopleName TEXT, judgeNumber VARCHAR(20), uploadId INTEGER);
CREATE TABLE pi_assignment (assignemenId INTEGER PRIMARY KEY AUTOINCREMENT, peopleId INTEGER, panelId INTEGER, role VARCHAR(20), time VARCHAR(20), panelDate VARCHAR(20), session INTEGER);
CREATE TABLE pi_studio(studioId INTEGER PRIMARY KEY, studioKey INTEGER, studioName VARCHAR(50));


CREATE TABLE heat_started (heat_id INTEGER PRIMARY KEY, is_started INTEGER);
CREATE TABLE couple_on_deck (entry_id INTEGER PRIMARY KEY, on_value INTEGER);
CREATE TABLE couple_on_floor (entry_id INTEGER PRIMARY KEY, on_value INTEGER);

CREATE TABLE judge (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, gender VARCHAR(6), initials TEXT);
CREATE TABLE person (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, gender VARCHAR(6), initials TEXT, user_roles TEXT);
CREATE TABLE contact_us (id INTEGER PRIMARY KEY, full_name TEXT, phone VARCHAR(20), to_email VARCHAR(30), best_email VARCHAR(30), event_website TEXT);
CREATE TABLE heat_info (id INTEGER PRIMARY KEY, judge_id INTEGER, heat_number VARCHAR(8), heat_title VARCHAR(20), assigned_couple VARCHAR(20), critique_sheet_type INTEGER, heat_order INTEGER);
CREATE TABLE heat_local (id INTEGER PRIMARY KEY, judge_id INTEGER, heat_number VARCHAR(8), heat_title VARCHAR(20), assigned_couple VARCHAR(20), critique_sheet_type INTEGER, heat_order INTEGER);
CREATE TABLE heat_critique (critiqueId INTEGER PRIMARY KEY, entryId INTEGER, peopleId INTEGER,heatId INTEGER ,technique INTEGER, music INTEGER, partnering INTEGER, presentation INTEGER, weLoveTcPosture INTEGER, weLoveTcFootwork INTEGER, weLoveTcTiming INTEGER, weLoveAcFloorcraft INTEGER, weLoveAcPartnering INTEGER, weLoveAcShowmanship INTEGER, keepImproveTcPosture INTEGER, keepImproveTcFootwork INTEGER, keepImproveTcTiming INTEGER, keepImproveAcFloorcraft INTEGER, keepImproveAcPartnering INTEGER, keepImproveAcShowmanship INTEGER, feedback INTEGER, initial, INTEGER, done INTEGER, formType INTEGER,updateDate TEXT);

CREATE TABLE job_panel_data (id INTEGER PRIMARY KEY, panel_order INTEGER, heat_start INTEGER, heat_end INTEGER, time_start VARCHAR(20), time_end VARCHAR(20));
CREATE TABLE person_data (id INTEGER PRIMARY KEY, job_panel_data_id INTEGER, first_name TEXT, last_name TEXT, gender VARCHAR(6), initials TEXT, user_roles TEXT, FOREIGN KEY(job_panel_data_id) REFERENCES job_panel_data(id) ON DELETE CASCADE);
CREATE TABLE heat_data (id INTEGER PRIMARY KEY, job_panel_data_id INTEGER, heat_number VARCHAR(8), heat_title VARCHAR(20), time_start VARCHAR(20), critique_sheet_type INTEGER, heat_order INTEGER, is_started INTEGER, FOREIGN KEY(job_panel_data_id) REFERENCES job_panel_data(id) ON DELETE CASCADE);
CREATE TABLE sub_heat_data (id INTEGER PRIMARY KEY, heat_data_id INTEGER, sub_title VARCHAR(20), subHeatdance VARCHAR(20), FOREIGN KEY(heat_data_id) REFERENCES heat_data(id) ON DELETE CASCADE);
CREATE TABLE heat_couple (id INTEGER PRIMARY KEY, sub_heat_id INTEGER, participant1 INTEGER, participant2 INTEGER, couple_tag VARCHAR(20), couple_level VARCHAR(20), age_category VARCHAR(20), studio VARCHAR(50), on_deck INTEGER, on_floor INTEGER, is_scratched INTEGER);
CREATE TABLE couple_person (id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, gender VARCHAR(6), level VARCHAR(20), age INTEGER);
CREATE TABLE proficiency_ranking(id INTEGER PRIMARY KEY, heat_id INTEGER, sub_heat_id INTEGER, couple_id INTEGER, score_type INTEGER, score_value INTEGER)

INSERT INTO person (id, first_name, last_name, gender, user_roles) VALUES (1, 'Sammy', 'Field', 'Female', 'JUDGE');
INSERT INTO person (id, first_name, last_name, gender, user_roles) VALUES (2, 'John', 'Smith', 'Male', 'EMCEE');
INSERT INTO person (id, first_name, last_name, gender, user_roles) VALUES (3, 'Ken', 'Olson', 'Female', 'CHAIRMAN_OF_JUDGES');
INSERT INTO person (id, first_name, last_name, gender, user_roles) VALUES (4, 'John', 'Doe', 'Male', 'SCRUTINEER');
INSERT INTO person (id, first_name, last_name, gender, user_roles) VALUES (5, 'Maria', 'Folson', 'Male', 'DECK_CAPTAIN');

INSERT INTO heat_info (judge_id, heat_number, heat_order, heat_title, assigned_couple, critique_sheet_type) VALUES (1, '351', 1, 'Waltz', '256|327', 2);

INSERT INTO heat_info (judge_id, heat_number, heat_order, heat_title, assigned_couple, critique_sheet_type) VALUES (1, '352', 2, 'Foxtrot', '316|308', 1);

INSERT INTO heat_info (judge_id, heat_number, heat_order, heat_title, assigned_couple, critique_sheet_type) VALUES (1, '353', 3, 'Waltz', '216|208', 2);

INSERT INTO heat_info (judge_id, heat_number, heat_order, heat_title, assigned_couple, critique_sheet_type) VALUES (1, '354', 4, 'Tango', '112|222', 1);
