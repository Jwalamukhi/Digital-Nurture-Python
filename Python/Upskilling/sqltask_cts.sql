CREATE DATABASE IF NOT EXISTS eventdb;
USE eventdb;
DROP TABLE IF EXISTS Resources;
DROP TABLE IF EXISTS Feedback;
DROP TABLE IF EXISTS Registrations;
DROP TABLE IF EXISTS Sessions;
DROP TABLE IF EXISTS Events;
DROP TABLE IF EXISTS Users;

CREATE TABLE Users (
    user_id  INT NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    city  VARCHAR(100) NOT NULL,
    registration_date DATE NOT NULL,
    CONSTRAINT pk_users  PRIMARY KEY (user_id),
    CONSTRAINT uq_users_email UNIQUE (email)
);
CREATE TABLE Events (
    event_id  INT  NOT NULL AUTO_INCREMENT,
    title   VARCHAR(200) NOT NULL,
    description  TEXT,
    city  VARCHAR(100) NOT NULL,
    start_date  DATETIME  NOT NULL,
    end_date DATETIME  NOT NULL,
    status ENUM('upcoming', 'completed', 'cancelled'),
    organizer_id INT,
    CONSTRAINT pk_events PRIMARY KEY (event_id),
    CONSTRAINT fk_events_organizer FOREIGN KEY (organizer_id)
REFERENCES Users(user_id)
);
CREATE TABLE Sessions (
    session_id  INT NOT NULL AUTO_INCREMENT,
    event_id INT  NOT NULL,
    title VARCHAR(200) NOT NULL,
    speaker_name VARCHAR(100) NOT NULL,
    start_time  DATETIME  NOT NULL,
    end_time   DATETIME NOT NULL,
    CONSTRAINT pk_sessions  PRIMARY KEY (session_id),
    CONSTRAINT fk_sessions_event FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
CREATE TABLE Registrations (
    registration_id  INT  NOT NULL AUTO_INCREMENT,
    user_id   INT  NOT NULL,
    event_id  INT  NOT NULL,
    registration_date DATE NOT NULL,
    CONSTRAINT pk_registrations PRIMARY KEY (registration_id),
    CONSTRAINT fk_reg_user  FOREIGN KEY (user_id)REFERENCES Users(user_id),
    CONSTRAINT fk_reg_event  FOREIGN KEY (event_id) REFERENCES Events(event_id)
);

CREATE TABLE Feedback (
    feedback_id INT  NOT NULL AUTO_INCREMENT,
    user_id  INT  NOT NULL,
    event_id INT  NOT NULL,
    rating INT,
    comments TEXT,
    feedback_date DATE NOT NULL,
    CONSTRAINT pk_feedback PRIMARY KEY (feedback_id),
    CONSTRAINT chk_feedback_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT fk_feedback_user   FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT fk_feedback_event FOREIGN KEY (event_id) REFERENCES Events(event_id)
);
CREATE TABLE Resources (
    resource_id  INT NOT NULL AUTO_INCREMENT,
    event_id  INT NOT NULL,
    resource_type ENUM('pdf', 'image', 'link'),
    resource_url VARCHAR(255) NOT NULL,
    uploaded_at  DATETIME  NOT NULL,
    CONSTRAINT pk_resources PRIMARY KEY (resource_id),
    CONSTRAINT fk_resources_event FOREIGN KEY (event_id)REFERENCES Events(event_id)
);
INSERT INTO Users (user_id, full_name, email, city, registration_date) VALUES
(1, 'Alice Johnson', 'alice@example.com',   'New York',    '2024-12-01'),
(2, 'Bob Smith',     'bob@example.com',     'Los Angeles', '2024-12-05'),
(3, 'Charlie Lee',   'charlie@example.com', 'Chicago',     '2024-12-10'),
(4, 'Diana King',    'diana@example.com',   'New York',    '2025-01-15'),
(5, 'Ethan Hunt',    'ethan@example.com',   'Los Angeles', '2025-02-01');

INSERT INTO Events (event_id, title, description, city, start_date, end_date, status, organizer_id) VALUES
(1, 'Tech Innovators Meetup',
    'A meetup for tech enthusiasts.',
    'New York',
    '2025-06-10 10:00:00', '2025-06-10 16:00:00',
    'upcoming', 1),
(2, 'AI & ML Conference',
    'Conference on AI and ML advancements.',
    'Chicago',
    '2025-05-15 09:00:00', '2025-05-15 17:00:00',
    'completed', 3),
(3, 'Frontend Development Bootcamp',
    'Hands-on training on frontend tech.',
    'Los Angeles',
    '2025-07-01 10:00:00', '2025-07-03 16:00:00',
    'upcoming', 2);
INSERT INTO Sessions (session_id, event_id, title, speaker_name, start_time, end_time) VALUES
(1, 1, 'Opening Keynote',   'Dr. Tech',      '2025-06-10 10:00:00', '2025-06-10 11:00:00'),
(2, 1, 'Future of Web Dev', 'Alice Johnson', '2025-06-10 11:15:00', '2025-06-10 12:30:00'),
(3, 2, 'AI in Healthcare',  'Charlie Lee',   '2025-05-15 09:30:00', '2025-05-15 11:00:00'),
(4, 3, 'Intro to HTML5',    'Bob Smith',     '2025-07-01 10:00:00', '2025-07-01 12:00:00');

INSERT INTO Registrations 
(registration_id, user_id, event_id, registration_date) VALUES
(1, 1, 1, '2025-05-01'),
(2, 2, 1, '2025-05-02'),
(3, 3, 2, '2025-04-30'),
(4, 4, 2, '2025-04-28'),
(5, 5, 3, '2025-06-15');

INSERT INTO Feedback (feedback_id, user_id, event_id, rating, comments, feedback_date) VALUES
(1, 3, 2, 4, 'Great insights!',   '2025-05-16'),
(2, 4, 2, 5, 'Very informative.', '2025-05-16'),
(3, 2, 1, 3, 'Could be better.',  '2025-06-11');

INSERT INTO Resources (resource_id, event_id, resource_type, resource_url, uploaded_at) VALUES
(1, 1, 'pdf',   'https://portal.com/resources/tech_meetup_agenda.pdf', '2025-05-01 10:00:00'),
(2, 2, 'image', 'https://portal.com/resources/ai_poster.jpg',          '2025-04-20 09:00:00'),
(3, 3, 'link',  'https://portal.com/resources/html5_docs',             '2025-06-25 15:00:00');


-- Q1
select u.full_name,e.title as eventtitle,e.city,e.start_date
from Users u 
join Registrations r on r.user_id=u.user_id
join Events e on e.event_id=r.event_id
where e.city=u.city and e.status='upcoming'
order by e.start_date;

-- Q2
select e.title,avg(f.rating) as avgrating, count(f.feedback_id) as totalcount
from feedback f
join events e on e.event_id=f.event_id
group by e.title,e.event_id
having count(f.feedback_id)>=10
order by avgrating desc;

-- Q3
select u.user_id,u.full_name 
from Users u
where u.user_id not in (select r.user_id from Registrations r where r.registration_date>=curdate()-interval 90 day);

-- Q4
select e.title,count(*) as session_count
from Events e
join Sessions s on e.event_id=s.event_id
where time(s.start_time) between '10:00:00' and '12:00:00'
group by e.title;

-- Q5
select u.city, count(r.user_id) as total_reg
from users u
join registrations r on r.user_id=u.user_id
group by u.city
order by total_reg desc limit 5;

-- Q6
select e.title,
sum(case when r.resource_type='pdf' then 1 else 0 end) as pdfs,
sum(case when r.resource_type='image' then 1 else 0 end) as images,
sum(case when r.resource_type='link' then 1 else 0 end) as links
from events e
left join resources r on r.event_id=e.event_id
group by e.event_id,e.title;

-- Q7
select u.user_id,u.full_name,e.title,f.rating ,f.comments
from users u join feedback f on f.user_id=u.user_id
join events e on f.event_id=e.event_id
where f.rating<3
order by f.rating asc;

-- Q8
select e.title,count(s.session_id) as totalsession,e.start_date
from events e
left join sessions s on e.event_id=s.event_id
where e.status='upcoming'
group by e.event_id,e.title,e.start_date;

-- Q9 
select u.full_name,count(e.event_id) as totalevents,e.status
from events e
join users u on e.organizer_id=u.user_id
group by e.organizer_id,u.full_name,e.status;



-- Q10
select distinct e.event_id,e.title
from events e
join registrations r on e.event_id=r.event_id
left join feedback f on f.event_id=e.event_id
where f.feedback_id is null
order by e.event_id;

-- Q11
select registration_date,count(user_id) as newusers
from users
where registration_date>=date_sub(curdate(),interval 7 day)
group by registration_date
order by registration_date;

-- Q12
select e.event_id, e.title,count(s.session_id) as total
from events e
join sessions s on s.event_id=e.event_id
group by e.event_id,e.title
having count(s.session_id)=(
select max(ss) from
(select count(session_id) as ss from sessions group by event_id)as counts);

-- Q13
select e.city , avg(f.rating) as avgrating
from events e
join feedback f on e.event_id=f.event_id
group by e.city
order by avgrating desc;

-- Q14
select e.title,count(r.registration_id) as totalreg
from events e
join registrations r on e.event_id=r.event_id
group by e.event_id,e.title
order by totalreg desc limit 3;

-- Q15
select s1.event_id,s1.title as session1 , s1.start_time as s1start,s1.end_time as s1end,s2.title as session2,
s2.start_time as s2start,s2.end_time as s2end
from sessions s1
join sessions s2 on s1.event_id=s2.event_id and s1.event_id<s2.event_id
where s1.start_time<s2.end_time and s1.end_time>s2.start_time;

-- Q16
select user_id,full_name,email,registration_date
from users
where registration_date>=curdate() - interval 30 day and user_id not in (select user_id from registrations);

-- Q17
select speaker_name , count(session_id) as totalsession
from sessions s
group by speaker_name
having count(session_id)>1;

-- Q18
select e.event_id,e.title
from events e
left join resources r on r.event_id=e.event_id
where r.resource_type is null;

-- Q19
select e.title,avg(f.rating) as avgrating,count(distinct r.registration_id) as total
from events e
left join feedback f on f.event_id=e.event_id
left join registrations r on r.event_id=e.event_id
where e.status='completed'
group by e.event_id,e.title;

-- Q20
select u.full_name,
count(distinct r.event_id) as totalevents,
count(f.feedback_id)as totalfeed
from users u
left join registrations r on r.user_id=u.user_id
left join feedback f on f.user_id=u.user_id
group by u.user_id,u.full_name;

-- Q21
select u.full_name,u.user_id ,count(f.feedback_id) as countfeed
from feedback f
join users u on u.user_id=f.user_id
group by u.user_id,u.full_name
order by countfeed desc limit 5;

-- Q22
select user_id,event_id,count(*) as registrationtot
from registrations 
group by user_id,event_id
having registrationtot>1;

-- Q23
select year(registration_date) as regyear, month(registration_date) as regmonth,count(*) as registrationcount
from registrations
where registration_date>=curdate()-interval 12 month
group by year(registration_date),month(registration_date)
order by regyear,regmonth;

-- Q24
select e.title, avg(timestampdiff(minute,s.start_time,s.end_time))as duration
from events e
join sessions s on s.event_id=e.event_id
group by e.title,e.event_id;

-- Q25
select e.event_id,e.title 
from events e
left join sessions s on s.event_id=e.event_id
where s.session_id is null;