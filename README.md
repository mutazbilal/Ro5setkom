# Rokhsetak

**A Centralized Digital Platform for Driver License Candidates and Driving Mentors**

Rokhsetak (رخصتك — "your license") is a bilingual (Arabic/English) web platform that guides trainees through the entire Jordanian driver-licensing journey — from theoretical learning and quizzes to mentor discovery, booking, and progress tracking — while giving mentors a structured channel for their services and administrators full operational visibility.

Graduation Project — Faculty of Information Technology, The World Islamic Sciences and Education University (WISE), Semester II, 2025/2026.

![.NET](https://img.shields.io/badge/ASP.NET_Core-MVCS-512BD4?logo=dotnet&logoColor=white)
![EF Core](https://img.shields.io/badge/Entity_Framework_Core-DB--First-blue)
![SQL Server](https://img.shields.io/badge/Database-SQL_Server-CC2927?logo=microsoftsqlserver&logoColor=white)
![C#](https://img.shields.io/badge/Language-C%23-239120?logo=csharp&logoColor=white)
![Status](https://img.shields.io/badge/Status-Graduation_Prototype-yellow)

---

## Overview

Obtaining a driver's license in Jordan currently means juggling driving schools, government portals, and informal advice from friends and instructors, with no single source of guidance in the applicant's native language. A pre-project survey of 40 recent/current applicants found that most began the process without a clear understanding of what it involved, relied heavily on word-of-mouth, and leaned on rote memorization rather than genuine understanding of traffic laws.

Rokhsetak addresses this by bringing the whole journey — theory, mentorship, scheduling, and progress — into a single, structured, Arabic-first platform.

## Objectives

- Provide a centralized platform that guides users through the entire licensing process in a structured, user-friendly way.
- Deliver structured theoretical and practical learning resources that build a genuine understanding of traffic laws and driving skills.
- Enable efficient trainee–mentor interaction through booking, communication, and performance tracking.
- Improve user experience and outcomes through progress tracking, recommendations, and system-assisted guidance.

## Key Features

**Trainees**
- Registration with simulated government ID verification and autofill of locked personal details
- License-type selection (Motorcycle / Automatic Car / Manual Car) with per-type progress tracking
- Bilingual (AR/EN) learning modules and lessons, gated by pass/fail quizzes
- Mock theory exam drawn from module quiz pools, required before booking the real theory test
- Mentor discovery and filtering by city, rating, price, and vehicle type
- Session booking with double-booking protection, cancellation/reschedule (24h notice), and calendar view
- In-app messaging with mentors, tied to an active booking
- Ratings and reviews after each session

**Mentors**
- Separate credential-based registration with document upload and admin approval workflow
- Weekly availability management via a scheduling grid
- Dashboard showing bookings, trainee progress, and quiz results
- Session confirmation, rescheduling, completion marking, and completion certificates
- Feedback and notes per trainee session

**Administrators**
- Mentor application review and approval/rejection, with verification badges
- User, mentor, booking, and content management with system logs
- Usage analytics: mentor performance (rating, completion rate, avg. time-to-license), trainee drop-off rates
- Ability to block exam dates (e.g., national holidays) without cancelling existing bookings

**Platform-wide**
- Role-based access control (Trainee / Mentor / Admin)
- Arabic (default) and English UI with RTL/LTR support
- Notifications for bookings, quizzes, session materials, and government exam updates
- Audit logging of critical admin actions
- Server-side validation and database-level data integrity constraints

## System Architecture

Rokhsetak follows an **MVCS (Model–View–Controller–Service)** pattern — MVC extended with a dedicated Service layer that isolates business logic from Controllers, keeping the codebase easier to test and maintain as it grows.

The system is organized into five core modules:

| Module | Responsibility |
|---|---|
| **Trainee Dashboard** | Current licensing stage, upcoming sessions/exams, progress overview |
| **Mentor Dashboard** | Bookings, availability management, trainee interactions |
| **Admin Panel** | Mentor approvals, user moderation, exam-date blocking |
| **Booking System** | Mentor discovery, availability, and session confirmation between trainees and mentors |
| **Learning Module** | Lessons, quizzes, and theoretical progress tracking, integrated with the trainee dashboard |

## Tech Stack

| Layer | Technology |
|---|---|
| Backend | ASP.NET Core (MVCS architecture) |
| ORM / Data Access | Entity Framework Core (database-first) |
| Database | Microsoft SQL Server |
| Frontend | Custom CSS (no UI framework), Razor Views |
| Authentication | Cookie-based sessions, BCrypt password hashing (no ASP.NET Identity) |
| Localization | Arabic (default) / English via dedicated translation tables, RTL/LTR support |
| Testing | Unit, integration, system, and user-acceptance testing; coverage via Coverlet + ReportGenerator |

## Database Design

The schema was modeled with an Entity-Relationship Diagram covering users, mentors, bookings, learning modules, quizzes, and exam appointments, then normalized to reduce redundancy and improve consistency. Multilingual content (modules, lessons, quizzes, questions, and answer options) is served through dedicated translation tables rather than duplicated per-language rows, so new languages can be added without schema changes.

## Testing & Quality

A four-tier strategy was applied across all four sprints: **unit → integration → system → user acceptance**, each catching a different class of defect.

| Suite | Line Coverage | Branch Coverage |
|---|---|---|
| Unit | 52.2% | 13.4% |
| Integration | 34.5% | 13.1% |

Testing effort was concentrated on business-critical paths — authentication, scheduling, progression, and evaluation — rather than the aggregate percentage. The unit suite alone surfaced twelve defects (including a database `UNIQUE` constraint issue) before they reached production, and integration testing caught a missing Arabic-localization case on the trainee dashboard that unit tests had missed. System testing against a fully deployed instance with a real SQL Server database validated the core end-to-end workflows.

## Team

| Name |
|---|
| Moath Yaser Fathi Freihat |
| Mutaz Bilal Othman Al-Farahneh |
| Abd-Alrahman Omar Ibrahim Obied |

**Supervisor:** Dr. Moath Altarawneh

## Development Methodology

Built with **Agile Scrum** across four monthly sprints (February–May 2026):

1. **Sprint 1 — Foundation:** requirements, ERD, ASP.NET Core/EF Core setup, authentication & role-based access
2. **Sprint 2 — Dashboards:** trainee/mentor dashboards, profile management, bilingual RTL/LTR layout
3. **Sprint 3 — Learning:** modules, lessons, quiz engine, multilingual translation tables
4. **Sprint 4 — Booking & Integration:** mentor availability, booking workflow, schema fixes, end-to-end integration

Backlog was tracked in Jira; GitHub Projects linked backlog items to branches, PRs, and commits.

## Limitations

This is a graduation-project prototype, not a production system:

- Government integration (ID verification, exam scheduling, license status) is **simulated**, not connected to a live API
- Notifications are single-channel (email); payment/billing and a driving-specific AI assistant were out of scope
- Physical exam execution, driving-center operations, and vehicle telemetry are not covered
- Evaluated with a limited user set in a controlled environment — not yet load-tested at scale

## Future Work

- Replace simulated government integration with a live API contract
- Native/hybrid mobile app for push notifications and offline learning content
- Multi-channel notifications (SMS, push)
- Retrieval-augmented AI assistant over existing modules/quiz/progress data
- Payment gateway, billing, and cohort-level admin analytics
- Large-scale empirical evaluation of the non-functional requirements
- Longer-term: live mentor-led sessions, driving-center partnerships, vehicle telemetry integration

## Acknowledgements

Developed under the supervision of **Dr. Moath Altarawneh**, Faculty of Information Technology, The World Islamic Sciences and Education University.

## License

Academic graduation project — WISE University, Faculty of Information Technology, 2025/2026.
