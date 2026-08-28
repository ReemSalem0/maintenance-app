# RideKeeper *(working title)*

A cross-platform maintenance-management (CMMS) app built with Flutter and Firebase. It lets teams track equipment status and log maintenance work in real time, with role based access control and full English/Hebrew (RTL) support. 

It's being designed with ride/equipment maintenance tracking as the initial use case, but built to generalize to other industries (facilities, manufacturing, etc.) rather than being tied to specific domain.

This started as a hands-on way to learn app development and Firebase, built from the ground up with no prior Flutter or Firebase experience.

## Project Status: In Development 

This app is actively being built and is not yet feature complete. Core functionality works and is in daily use for testing, but attachments, search polish and automated testing are still in progress.

**Done:**
- Email/password login with role based account
- Admin only crew provisioning, email-based password setup for new accounts
- Ride management: create, view, edit status, real-time sync across devices
- Crew management: create, view, edit role, real-time sync
- Maintenance record logging, tied to specific rides, with full history view
- Search/filter on ride and crew lists
- Firestore security rules enforcing role permissions server-side
- Full English and Hebrew localization, including right-to-left layout support

**In progress/planned:**
- Photo and document attachment on maintenance records (Firebase Storage)
- Automated testing
- iOS support
- ...and more, new needs keep coming up as the app gets used and tested, so this list will keep growing

## Tech Stack

- **Frontend:** Flutter/Dart
- **Backend:** Firebase (Authentication, Cloud Firestore, Firebase Storage)
- **Localization:** Flutter's `intl`/ARB-based i18n system

## Why this project

I built RideKeeper to learn mobile app development and Firebase from the ground up, while solving a real world problem. Along the way this involved designing role based security rules from scratch, handling real-time data sync and implementing full bilingual support with right-to-left layout, areas I had no prior experience with when I started.

---

*A more detailed setup/installation guide will be added once the app reaches a stable release.*