-- ============================================================
--  SEED DATA
--  Identity columns are GENERATED ALWAYS, so explicit ids need
--  OVERRIDING SYSTEM VALUE; the sequences are re-synced afterwards.
-- ============================================================
 
INSERT INTO stations (station_id, code, name, city, state, zone, num_platforms)
OVERRIDING SYSTEM VALUE VALUES
 (1,'NDLS','New Delhi',                  'Delhi',    'Delhi',         'NR', 16),
 (2,'CNB', 'Kanpur Central',             'Kanpur',   'Uttar Pradesh', 'NCR',10),
 (3,'ALD', 'Prayagraj Junction',         'Prayagraj','Uttar Pradesh', 'NCR',10),
 (4,'DDU', 'Pt. Deen Dayal Upadhyaya Jn','Chandauli','Uttar Pradesh', 'ECR', 8),
 (5,'PNBE','Patna Junction',             'Patna',    'Bihar',         'ECR',10),
 (6,'HWH', 'Howrah Junction',            'Howrah',   'West Bengal',   'ER', 23),
 (7,'BPL', 'Bhopal Junction',            'Bhopal',   'Madhya Pradesh','WCR', 6),
 (8,'NGP', 'Nagpur Junction',            'Nagpur',   'Maharashtra',   'CR',  8),
 (9,'BCT', 'Mumbai Central',             'Mumbai',   'Maharashtra',   'WR',  9),
 (10,'ST', 'Surat',                      'Surat',    'Gujarat',       'WR',  4),
 (11,'BRC','Vadodara Junction',          'Vadodara', 'Gujarat',       'WR',  7),
 (12,'MAS','Chennai Central',            'Chennai',  'Tamil Nadu',    'SR', 17),
 (13,'SBC','KSR Bengaluru',              'Bengaluru','Karnataka',     'SWR',10),
 (14,'JP', 'Jaipur Junction',            'Jaipur',   'Rajasthan',     'NWR', 7),
 (15,'LKO', 'Lucknow Charbagh',          'Lucknow',  'Uttar Pradesh', 'NR',  9),
 (16,'AGC','Agra Cantt',                 'Agra',     'Uttar Pradesh', 'NCR', 6),
 (17,'JHS','Jhansi Junction',            'Jhansi',   'Uttar Pradesh', 'NCR', 8),
 (18,'BSB','Varanasi Junction',          'Varanasi', 'Uttar Pradesh', 'NER', 9);
 
INSERT INTO trains (train_id, number, name, train_type, runs_on, has_pantry)
OVERRIDING SYSTEM VALUE VALUES
 (1,'12301','Howrah Rajdhani',            'RAJDHANI',    'YYYYYYY', true),
 (2,'12951','Mumbai Rajdhani',            'RAJDHANI',    'YYYYYYY', true),
 (3,'12002','Bhopal Shatabdi',            'SHATABDI',    'YYYYYYN', true),
 (4,'12621','Tamil Nadu Express',         'SUPERFAST',   'YYYYYYY', true),
 (5,'12649','Karnataka Sampark Kranti',   'SUPERFAST',   'NYNYNYN', false),
 (6,'12559','Shiv Ganga Express',         'SUPERFAST',   'YYYYYYY', true),
 (7,'54251','Kanpur-Lucknow Passenger',   'PASSENGER',   'YYYYYYY', false),
 (8,'22436','Vande Bharat Express',       'VANDE_BHARAT','YYYYYNY', true);
 
INSERT INTO train_stops (train_id, stop_seq, station_id, arrival_time, departure_time, day_offset, distance_km) VALUES
 -- 12301 New Delhi -> Howrah
 (1,1, 1, NULL,    '16:55', 0,    0),
 (1,2, 2,'21:25',  '21:30', 0,  440),
 (1,3, 3,'23:20',  '23:25', 0,  633),
 (1,4, 4,'01:25',  '01:35', 1,  792),
 (1,5, 6,'09:55',   NULL,   1, 1447),
 -- 12951 New Delhi -> Mumbai Central
 (2,1, 1, NULL,    '16:25', 0,    0),
 (2,2,11,'05:35',  '05:40', 1, 1152),
 (2,3,10,'07:10',  '07:12', 1, 1281),
 (2,4, 9,'08:35',   NULL,   1, 1384),
 -- 12002 New Delhi -> Bhopal (Shatabdi)
 (3,1, 1, NULL,    '06:00', 0,    0),
 (3,2,16,'07:57',  '07:59', 0,  195),
 (3,3,17,'09:47',  '09:52', 0,  414),
 (3,4, 7,'13:33',   NULL,   0,  702),
 -- 12621 New Delhi -> Chennai Central
 (4,1, 1, NULL,    '22:30', 0,    0),
 (4,2,17,'02:33',  '02:38', 1,  414),
 (4,3, 7,'05:30',  '05:40', 1,  702),
 (4,4, 8,'11:05',  '11:15', 1, 1092),
 (4,5,12,'07:10',   NULL,   2, 2182),
 -- 12649 New Delhi -> Bengaluru
 (5,1, 1, NULL,    '20:50', 0,    0),
 (5,2,17,'01:43',  '01:48', 1,  414),
 (5,3, 7,'04:45',  '04:50', 1,  702),
 (5,4, 8,'10:20',  '10:30', 1, 1092),
 (5,5,13,'09:15',   NULL,   2, 2365),
 -- 12559 New Delhi -> Varanasi
 (6,1, 1, NULL,    '20:00', 0,    0),
 (6,2, 2,'01:40',  '01:45', 1,  440),
 (6,3, 3,'03:55',  '04:05', 1,  633),
 (6,4,18,'07:00',   NULL,   1,  764),
 -- 54251 Kanpur -> Lucknow
 (7,1, 2, NULL,    '06:15', 0,    0),
 (7,2,15,'08:40',   NULL,   0,   74),
 -- 22436 New Delhi -> Varanasi (Vande Bharat, same corridor as 12559)
 (8,1, 1, NULL,    '06:00', 0,    0),
 (8,2, 2,'09:38',  '09:40', 0,  440),
 (8,3, 3,'11:23',  '11:25', 0,  633),
 (8,4,18,'14:00',   NULL,   0,  764);
 
INSERT INTO passengers (passenger_id, full_name, email, phone, date_of_birth, gender, city, created_at)
OVERRIDING SYSTEM VALUE VALUES
 (1, 'Ananya Sharma',   'ananya.sharma@example.com', '9810011001','1994-03-12','F','Delhi',    '2023-01-14 09:12+05:30'),
 (2, 'Rohit Verma',     'rohit.verma@example.com',   '9810011002','1988-07-25','M','Delhi',    '2023-01-14 09:20+05:30'),
 (3, 'Meera Iyer',      'meera.iyer@example.com',    '9840011003','2001-11-02','F','Chennai',  '2023-04-02 17:45+05:30'),
 (4, 'Sandeep Nair',     NULL,                       '9840011004','1975-05-19','M','Kochi',    '2023-05-21 11:03+05:30'),
 (5, 'Priya Chatterjee','priya.c@example.com',       '9830011005','1997-09-30','F','Kolkata',  '2023-06-11 08:33+05:30'),
 (6, 'Imran Qureshi',   'imran.q@example.com',       '9820011006','1992-12-08','M','Mumbai',   '2023-06-30 14:27+05:30'),
 (7, 'Kavya Reddy',     'kavya.reddy@example.com',   '9866011007','2005-02-17','F','Hyderabad','2023-08-19 19:50+05:30'),
 (8, 'Arjun Mehta',      NULL,                       '9870011008','1983-08-04','M','Pune',     '2023-09-05 07:15+05:30'),
 (9, 'Neha Gupta',      'neha.gupta@example.com',    '9811011009','1999-04-21','F','Kanpur',   '2023-11-27 22:02+05:30'),
 (10,'Vikram Singh',    'vikram.singh@example.com',  '9812011010','1968-01-09','M','Jaipur',   '2024-01-08 10:41+05:30'),
 (11,'Sneha Joshi',     'sneha.joshi@example.com',   '9822011011','1996-10-14','F','Nagpur',   '2024-02-16 15:19+05:30'),
 (12,'Rahul Bose',      'rahul.bose@example.com',    '9831011012','1990-06-06','M','Howrah',   '2024-03-03 12:00+05:30'),
 (13,'Fatima Sheikh',    NULL,                       '9845011013','2008-09-23','F','Bengaluru','2024-05-29 09:58+05:30'),
 (14,'Deepak Rawat',    'deepak.rawat@example.com',  '9814011014','1979-02-28','M','Lucknow',  '2024-07-12 18:36+05:30'),
 (15,'Tanya Malhotra',  'tanya.m@example.com',       '9815011015','2003-12-31','F','Delhi',    '2024-09-01 06:24+05:30');
 
INSERT INTO bookings (pnr, passenger_id, train_id, from_station_id, to_station_id, journey_date, booked_at, travel_class, seat_no, status, fare) VALUES
 ('2409010001', 1,1, 1, 6,'2026-09-01','2026-08-12 10:14+05:30','3A','B2-34','CONFIRMED',2450.00),
 ('2409010002', 2,1, 1, 6,'2026-09-01','2026-08-12 10:20+05:30','3A','B2-35','CONFIRMED',2450.00),
 ('2409010003', 9,1, 1, 2,'2026-09-01','2026-08-20 18:02+05:30','2A','A1-12','CONFIRMED',1680.00),
 ('2409010004', 4,2, 1, 9,'2026-09-01','2026-07-30 09:00+05:30','1A','H1-04','CONFIRMED',5310.00),
 ('2409010005', 6,2, 1,11,'2026-09-01','2026-08-25 21:45+05:30','3A', NULL,  'WAITLIST',2210.00),
 ('2409010006',15,6, 1,18,'2026-09-01','2026-08-27 13:05+05:30','SL','S3-14','CONFIRMED', 465.00),
 ('2409020001',10,3, 1, 7,'2026-09-02','2026-08-28 07:30+05:30','CC','C3-45','CONFIRMED',1225.00),
 ('2409020002',11,3, 1,16,'2026-09-02','2026-08-29 12:10+05:30','CC','C1-18','CONFIRMED', 720.00),
 ('2409020003', 3,4, 1,12,'2026-09-02','2026-06-15 08:05+05:30','SL','S7-56','CONFIRMED', 885.00),
 ('2409020004', 8,4, 1, 8,'2026-09-02','2026-06-16 08:30+05:30','SL','S7-57','CANCELLED', 610.00),
 ('2409020005',13,5, 1,13,'2026-09-02','2026-07-02 19:20+05:30','3A','B1-22','CONFIRMED',2065.00),
 ('2409020006',12,1, 3, 6,'2026-09-02','2026-08-30 23:11+05:30','2A','A2-07','CONFIRMED',1990.00),
 ('2409030001', 1,8, 1,18,'2026-09-03','2026-08-31 06:40+05:30','CC','C5-11','CONFIRMED',1580.00),
 ('2409030002', 2,8, 1,18,'2026-09-03','2026-08-31 06:42+05:30','CC','C5-12','CONFIRMED',1580.00),
 ('2409030003', 5,1, 1, 4,'2026-09-03','2026-08-14 16:28+05:30','3A','B4-09','RAC',      1870.00),
 ('2409030004', 7,6, 2,18,'2026-09-03','2026-09-01 20:55+05:30','SL','S5-31','CONFIRMED', 285.00),
 ('2409030005',14,7, 2,15,'2026-09-03','2026-09-03 05:40+05:30','2S','D1-44','CONFIRMED',  45.00),
 ('2409040001', 9,6, 1, 3,'2026-09-04','2026-08-05 11:11+05:30','SL', NULL,  'WAITLIST', 380.00),
 ('2409040002', 3,4, 7,12,'2026-09-04','2026-07-19 09:47+05:30','3A','B3-21','CONFIRMED',1640.00),
 ('2409040003', 6,2, 1, 9,'2026-09-04','2026-08-02 14:33+05:30','2A','A1-05','CONFIRMED',3395.00),
 ('2409040004',10,2, 1, 9,'2026-09-04','2026-08-02 14:36+05:30','2A','A1-06','CANCELLED',3395.00),
 ('2409050001',15,3, 1, 7,'2026-09-05','2026-09-01 08:19+05:30','CC','C2-33','CONFIRMED',1225.00),
 ('2409050002',11,5, 7,13,'2026-09-05','2026-06-28 17:02+05:30','SL','S2-18','CONFIRMED', 720.00),
 ('2409050003', 4,1, 1, 6,'2026-09-05','2026-06-30 10:00+05:30','1A','H1-02','CONFIRMED',4820.00),
 ('2409050004',12,1, 1, 6,'2026-09-05','2026-07-01 09:05+05:30','3A','B1-14','CONFIRMED',2450.00),
 ('2409060001', 8,4, 1,12,'2026-09-06','2026-05-30 06:55+05:30','2A','A1-22','CONFIRMED',2310.00),
 ('2409060002',13,5, 1,13,'2026-09-06','2026-07-04 21:38+05:30','SL', NULL,  'WAITLIST', 845.00),
 ('2409060003', 1,7, 2,15,'2026-09-06','2026-09-05 19:12+05:30','2S','D2-09','CONFIRMED',  45.00),
 ('2409070001', 5,8, 1, 2,'2026-09-07','2026-09-02 10:26+05:30','CC','C1-27','CONFIRMED', 985.00),
 ('2409070002', 7,8, 1, 2,'2026-09-07','2026-09-02 10:29+05:30','CC','C1-28','CONFIRMED', 985.00),
 ('2409070003', 2,1, 2, 6,'2026-09-07','2026-08-18 23:47+05:30','3A','B2-18','CONFIRMED',2110.00),
 ('2409080001',14,6, 1,18,'2026-09-08','2026-08-21 07:03+05:30','SL','S1-63','CONFIRMED', 465.00),
 ('2409080002', 9,6, 1,18,'2026-09-08','2026-08-21 07:06+05:30','SL','S1-64','RAC',       465.00),
 ('2409080003',10,3, 1,17,'2026-09-08','2026-09-06 15:50+05:30','CC','C4-02','CONFIRMED', 940.00),
 ('2409090001', 3,4, 1, 8,'2026-09-09','2026-06-11 12:41+05:30','3A','B2-44','CONFIRMED',1290.00),
 ('2409090002',12,2,11, 9,'2026-09-09','2026-08-09 16:14+05:30','3A','B3-03','CONFIRMED', 640.00),
 ('2409090003', 6,2, 1,10,'2026-09-09','2026-08-10 09:22+05:30','1A','H1-01','CANCELLED',4980.00),
 ('2409100001',15,1, 1, 6,'2026-09-10','2026-07-15 18:58+05:30','2A','A1-31','CONFIRMED',3770.00),
 ('2409100002',11,5, 1, 8,'2026-09-10','2026-07-16 08:44+05:30','3A','B1-09','CONFIRMED',1510.00),
 ('2409100003', 4,3, 1, 7,'2026-09-10','2026-09-07 11:35+05:30','CC','C1-05','CONFIRMED',1225.00),
 ('2409120001', 1,8, 1,18,'2026-09-12','2026-09-08 09:01+05:30','CC','C3-19','CONFIRMED',1580.00),
 ('2409120002', 5,8, 3,18,'2026-09-12','2026-09-08 09:04+05:30','CC','C3-20','CONFIRMED', 520.00),
 ('2409150001', 8,4, 1,12,'2026-09-15','2026-04-20 07:12+05:30','SL','S9-11','CONFIRMED', 885.00),
 ('2409150002',13,4, 1,12,'2026-09-15','2026-04-20 07:15+05:30','SL','S9-12','CONFIRMED', 885.00),
 ('2409180001', 7,1, 1, 6,'2026-09-18','2026-08-31 13:29+05:30','3A', NULL,  'WAITLIST',2450.00),
 ('2409200001', 2,5, 1,13,'2026-09-20','2026-07-25 20:07+05:30','2A','A1-16','CONFIRMED',3480.00);
 
-- Re-sync identity sequences after the explicit-id inserts.
SELECT setval(pg_get_serial_sequence('stations',  'station_id'),   (SELECT max(station_id)   FROM stations));
SELECT setval(pg_get_serial_sequence('trains',    'train_id'),     (SELECT max(train_id)     FROM trains));
SELECT setval(pg_get_serial_sequence('passengers','passenger_id'), (SELECT max(passenger_id) FROM passengers));
 
COMMIT;