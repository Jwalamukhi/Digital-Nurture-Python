# ANSI SQL Using MySQL — Module 1

SQL exercises based on an Event Management System schema, written and executed in MySQL Workbench.
Covers joins, aggregations, subqueries, date functions, and analytical queries across 25 real-world style problems.

---

## Files

- sqltask_cts.sql — Database setup (schema + sample data) with Q1 and Q2
- SQL-15questions — Q1 to Q15 with queries and output screenshots
- SQL-10questions — Q16 to Q25 with queries and output screenshots

---

## Database

**Database name:** eventdb

**Tables:** Users, Events, Sessions, Registrations, Feedback, Resources

---

## Exercises

1. User Upcoming Events — Show all upcoming events a user is registered for in their city, sorted by date.
2. Top Rated Events — Events with the highest average rating, with at least 10 feedback submissions.
3. Inactive Users — Users who have not registered for any events in the last 90 days.
4. Peak Session Hours — Count sessions scheduled between 10 AM and 12 PM for each event.
5. Most Active Cities — Top 5 cities with the highest number of user registrations.
6. Event Resource Summary — Number of PDFs, images, and links uploaded per event.
7. Low Feedback Alerts — Users who gave a rating below 3, with comments and event names.
8. Sessions per Upcoming Event — All upcoming events with their session count.
9. Organizer Event Summary — Number of events per organizer broken down by status.
10. Feedback Gap — Events that had registrations but received no feedback.
11. Daily New User Count — Number of users who registered each day in the last 7 days.
12. Event with Maximum Sessions — Event(s) with the highest number of sessions.
13. Average Rating per City — Average feedback rating of events conducted in each city.
14. Most Registered Events — Top 3 events by total number of user registrations.
15. Event Session Time Conflict — Overlapping sessions within the same event.
16. Unregistered Active Users — Users who signed up in the last 30 days but haven't registered for any events.
17. Multi-Session Speakers — Speakers handling more than one session across all events.
18. Resource Availability Check — Events that do not have any resources uploaded.
19. Completed Events with Feedback Summary — Total registrations and average rating for completed events.
20. User Engagement Index — Events registered and feedbacks submitted per user.
21. Top Feedback Providers — Top 5 users by number of feedback entries submitted.
22. Duplicate Registrations Check — Detect users registered more than once for the same event.
23. Registration Trends — Month-wise registration count over the past 12 months.
24. Average Session Duration per Event — Average session duration in minutes per event.
25. Events Without Sessions — All events that have no sessions scheduled.

---

## Tools Used

- MySQL 8.0
- MySQL Workbench

---

Name - Jwalamukhi S

BE Computer Science and Engineering
