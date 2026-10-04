# Guided workbook

Use one session per stage, or combine stages when they feel comfortable. For
each query, write down what **one output row** represents before you run it.
Then compare the result with the checkpoint. The solution files are in
`solutions/` for review after your attempt.

## Stage 0: Know the schema

Run `queries/00_explore.sql`. Inspect a table with a query such as
`SELECT * FROM users LIMIT 5;`, or check columns in the terminal with a new
SQL file containing `PRAGMA table_info(users);`.

Draw these paths: `users -> events`; `users -> subscriptions -> payments ->
refunds`. There is no direct `users` key in `payments`.

## Task 1: Audit the data

File: `queries/01_audit.sql`. Return the number of rows in each of the six
tables. Then run a separate query comparing:

```sql
COUNT(*)
COUNT(DISTINCT user_id)
```

for `events` where `event_name = 'onboarding_completed'`.

Checkpoint: 600 user rows; 383 completion event rows but only 365 distinct
completing users. Explain why these differ.

## Task 2: Signup cohorts

File: `queries/02_cohorts.sql`. Extract `YYYY-MM` from `users.signup_at`, group
by that month and `acquisition_channel`, and count signups. Sort month
ascending, then signups descending.

Skills: `strftime`, two-column `GROUP BY`, multiple sort keys. Checkpoint:
24 month-channel rows, with 100 users in each of six months after summing the
four channels.

## Task 3: User funnel

File: `queries/03_funnel.sql`. Produce **one output row** with four numbers:
assigned users, users with `onboarding_started`, users with
`onboarding_completed`, and users with a subscription. Count a person once at
each step. `EXISTS` or a CTE with one row per user works well.

Checkpoint: 600 -> 558 -> 365 -> 137. Explain why a direct join to all event
rows followed by `COUNT(*)` gives the wrong number.

## Task 4: Seven-day experiment outcome

File: `queries/04_experiment.sql`. Find each user's **first** completion time.
For each variant, count assigned users and users who completed between
assignment and exactly seven days later, inclusive. Report the percentage.

Skills: CTE, `MIN`, `LEFT JOIN`, `CASE`, SQLite `datetime`. Denominator:
**all assigned users**, including those without a completion event. Checkpoint:
300 per variant; A has 142 seven-day completions and B has 188.

## Task 5: Thirty-day paid conversion

File: `queries/05_paid_conversion.sql`. For each acquisition channel, count
all signups and those with **at least one successful (`paid`) payment** from
signup through 30 days later. Return a percentage and sort high to low.

Skills: `EXISTS` across `subscriptions` and `payments`, date boundary,
denominator choice. A failed charge is not a conversion. Checkpoint: four
channels; Social has 168 signups and 42 converting users.

## Task 6: Monthly net cash

File: `queries/06_monthly_revenue.sql`. Sum successful payments in their
payment month. Subtract refunds in their **refund month**. Return each month,
net collected revenue, the previous month's net revenue, and percentage change.

Skills: `UNION ALL`, CTEs, `LAG`, `NULLIF`. Checkpoint: January 2026 net
revenue is 148.00; its previous-month value and percentage change are NULL.
Explain why a refund in March should not necessarily change February's cash.

## Task 7: Next-month activity

File: `queries/07_retention.sql`. For each signup cohort month, count signups
and users with at least one `app_open` in the **next calendar month**. Compute
the retention percentage. This is a calendar-month definition, not a rolling
30-day window.

Skills: correlated `EXISTS`, date modifiers, grouped percentages. Checkpoint:
six cohorts of 100 signups each; January has 35 active users in February.

## Task 8: Top users within each country

File: `queries/08_top_users.sql`. For every user, calculate total successful
payment amount minus refunds. Rank users inside each country by net revenue
and return the top three per country. Break ties by `user_id`.

Skills: separate aggregates, `COALESCE`, `ROW_NUMBER() OVER (PARTITION BY ...)`.
Checkpoint: five countries times three users = 15 output rows. Explain why
joining raw `payments` and raw `refunds` before summing can inflate revenue.

## Task 9: Assignment balance

File: `queries/09_balance.sql`. Count users by variant and acquisition channel.
Add each channel's percentage **within its variant** using a window sum. The
four percentages within A should be about 100%, and likewise for B (small
rounding differences are fine).

Skills: `GROUP BY`, window aggregate, partition denominator. Checkpoint: eight
rows; each variant totals 300 users. Look for large imbalances before comparing
variant outcomes within channels.

## Final deliverable

Complete `REPORT_TEMPLATE.md` with three findings backed by a query and a
number, one chart or small table if helpful, and two limits of interpretation.
Keep query files in your repository so another analyst can reproduce the memo.
