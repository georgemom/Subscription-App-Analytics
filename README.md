# Subscription App Analytics: Advanced SQL Project

Analyze onboarding, retention, payments, refunds, and an A/B assignment in a
synthetic subscription app. The project is designed for **GitHub Codespaces**
and uses **SQLite** and Python's standard library. It needs no packages and no
external data download.

## Start in Codespaces

1. Extract the project ZIP and upload its contents to a new GitHub repository.
   Keep the `data`, `queries`, `scripts`, and `solutions` folders together.
2. From the repository page choose **Code > Codespaces > Create codespace**.
3. In the Codespace terminal run:

   ```bash
   python3 scripts/run_query.py queries/00_explore.sql
   python3 scripts/run_query.py solutions/01_audit.sql
   ```

4. Open `WORKBOOK.md`, solve one task in its matching `queries/` file, then run:

   ```bash
   python3 scripts/run_query.py queries/02_cohorts.sql
   ```

The query runner shows at most 30 rows. Add `--all` to show every row. Run one
SQL statement per file. Empty task files prompt you to write the query.

The database is already included at `data/subscription_app.sqlite`. To recreate
the *same* synthetic data from seed 20261004, run
`python3 scripts/generate_data.py`. This overwrites the bundled database; it
does not change your SQL files.

## Business question

Which acquisition channels bring users who activate, retain, and pay? How do
onboarding outcomes differ between randomized variants A and B? How much money
was collected after refunds? Write a short memo in `REPORT_TEMPLATE.md` using
the output from your own queries.

## Tables and row units

| Table | One row represents | Primary key | Important link |
| --- | --- | --- | --- |
| `users` | one signup | `user_id` | parent of most tables |
| `experiment_assignments` | one assignment per user | `user_id` | `user_id -> users.user_id` |
| `events` | one logged action | `event_id` | `user_id -> users.user_id` |
| `subscriptions` | one subscription per subscribing user | `subscription_id` | `user_id -> users.user_id` |
| `payments` | one attempted charge | `payment_id` | `subscription_id -> subscriptions.subscription_id` |
| `refunds` | one refund of a paid charge | `refund_id` | `payment_id -> payments.payment_id` |

There are 600 users across six signup months, 2,139 event rows, 137
subscriptions, 503 payment attempts, and 24 refunds. A person can have many
events and payments. Some completion events are logged twice intentionally.
Payment `status = 'failed'` contributes zero cash. Refunds occur on their own
dates, sometimes in a later month. All dates are ISO-style text; the data stop
on 2026-09-30.

## Learning route

1. Audit row counts and duplicate event logging.
2. Summarize signup cohorts.
3. Build a distinct-user funnel.
4. Compare seven-day completion by A/B variant.
5. Measure 30-day paid conversion by channel.
6. Calculate monthly net cash and month-over-month changes.
7. Measure next-calendar-month activity by signup cohort.
8. Rank top users within each country.
9. Audit assignment balance across channels.

`queries/` contains prompts. `solutions/` contains tested reference queries.
Try each task before opening its solution. Equivalent SQL is welcome if its row
unit, denominator, and timing rule match the task.

## Interpretation rules

- Count **distinct users** or use `EXISTS` for conversion and funnel steps;
  counting event rows inflates completed users.
- Aggregate payments and refunds separately before joining user summaries;
  joining both raw tables can multiply amounts.
- The experiment is synthetic. The query reports observed differences in this
  generated data, not evidence about a real product.

SQLite references: https://www.sqlite.org/lang_with.html,
https://www.sqlite.org/windowfunctions.html, and
https://www.sqlite.org/lang_datefunc.html.
