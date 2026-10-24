-- ============================================================
-- RAVENSTACK | DATA PROFILING & QUALITY VALIDATION
-- ============================================================
-- Purpose: Assess missing values, identifier uniqueness,
-- categorical consistency, numerical validity, date quality,
-- and relationships across the five RavenStack tables.
-- ============================================================


-- ============================================================
-- TABLE 1: ACCOUNTS | DATA PROFILING
-- ============================================================

-- Check for missing values across account fields
SELECT
    COUNT(*) - COUNT(account_id) AS missing_account_ids,
    COUNT(*) - COUNT(account_name) AS missing_account_names,
    COUNT(*) - COUNT(industry) AS missing_industries,
    COUNT(*) - COUNT(country) AS missing_countries,
    COUNT(*) - COUNT(signup_date) AS missing_signup_dates,
    COUNT(*) - COUNT(referral_source) AS missing_referral_sources,
    COUNT(*) - COUNT(plan_tier) AS missing_plan_tiers,
    COUNT(*) - COUNT(seats) AS missing_seat_counts,
    COUNT(*) - COUNT(is_trial) AS missing_trial_flags,
    COUNT(*) - COUNT(churn_flag) AS missing_churn_flags
FROM ravenstack_accounts;


-- Identify account IDs that appear more than once
SELECT
    account_id,
    COUNT(*) AS duplicate_account_count
FROM ravenstack_accounts
GROUP BY account_id
HAVING COUNT(*) > 1;


-- Inspect industry values for inconsistent categories
SELECT DISTINCT
    industry
FROM ravenstack_accounts;


-- Inspect plan tier values for inconsistent categories
SELECT DISTINCT
    plan_tier
FROM ravenstack_accounts;


-- Inspect trial flag values for consistency
SELECT DISTINCT
    is_trial
FROM ravenstack_accounts;


-- Inspect churn flag values for consistency
SELECT DISTINCT
    churn_flag
FROM ravenstack_accounts;


-- Inspect the minimum and maximum number of seats
SELECT
    MIN(seats) AS min_seats,
    MAX(seats) AS max_seats
FROM ravenstack_accounts;


-- ============================================================
-- TABLE 2: SUBSCRIPTIONS | DATA PROFILING
-- ============================================================

-- Check for missing values across subscription fields
SELECT
    COUNT(*) - COUNT(subscription_id) AS missing_subscription_ids,
    COUNT(*) - COUNT(account_id) AS missing_account_ids,
    COUNT(*) - COUNT(start_date) AS missing_start_dates,
    COUNT(*) - COUNT(end_date) AS missing_end_dates,
    COUNT(*) - COUNT(plan_tier) AS missing_plan_tiers,
    COUNT(*) - COUNT(seats) AS missing_seat_counts,
    COUNT(*) - COUNT(mrr_amount) AS missing_mrr_amounts,
    COUNT(*) - COUNT(arr_amount) AS missing_arr_amounts,
    COUNT(*) - COUNT(is_trial) AS missing_trial_flags,
    COUNT(*) - COUNT(upgrade_flag) AS missing_upgrade_flags,
    COUNT(*) - COUNT(downgrade_flag) AS missing_downgrade_flags,
    COUNT(*) - COUNT(churn_flag) AS missing_churn_flags,
    COUNT(*) - COUNT(billing_frequency) AS missing_billing_frequencies,
    COUNT(*) - COUNT(auto_renew_flag) AS missing_auto_renew_flags
FROM ravenstack_subscriptions;


-- Identify subscription IDs that appear more than once
SELECT
    subscription_id,
    COUNT(*) AS duplicate_subscription_count
FROM ravenstack_subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;


-- Inspect subscription plan tiers for inconsistent categories
SELECT DISTINCT
    plan_tier
FROM ravenstack_subscriptions;


-- Inspect the minimum and maximum MRR and ARR amounts
SELECT
    MIN(mrr_amount) AS min_mrr_amount,
    MAX(mrr_amount) AS max_mrr_amount,
    MIN(arr_amount) AS min_arr_amount,
    MAX(arr_amount) AS max_arr_amount
FROM ravenstack_subscriptions;


-- Investigate zero-revenue subscriptions that are not trials
SELECT
    subscription_id,
    arr_amount,
    mrr_amount,
    is_trial
FROM ravenstack_subscriptions
WHERE (arr_amount = 0 OR mrr_amount = 0)
    AND is_trial = 'false';


-- Identify subscriptions with inconsistent MRR and ARR values
SELECT
    subscription_id,
    mrr_amount,
    arr_amount
FROM ravenstack_subscriptions
WHERE arr_amount <> mrr_amount * 12;


-- Identify subscriptions with end dates earlier than start dates
-- Exclude blank end dates, which may represent active subscriptions
SELECT
    subscription_id,
    start_date,
    end_date
FROM ravenstack_subscriptions
WHERE start_date > end_date
    AND end_date <> '';


-- Inspect upgrade flag values for consistency
SELECT DISTINCT
    upgrade_flag
FROM ravenstack_subscriptions;


-- Inspect downgrade flag values for consistency
SELECT DISTINCT
    downgrade_flag
FROM ravenstack_subscriptions;


-- Inspect subscription churn flag values for consistency
SELECT DISTINCT
    churn_flag
FROM ravenstack_subscriptions;


-- Inspect billing frequency values for consistency
SELECT DISTINCT
    billing_frequency
FROM ravenstack_subscriptions;


-- Inspect auto-renew flag values for consistency
SELECT DISTINCT
    auto_renew_flag
FROM ravenstack_subscriptions;


-- Identify subscriptions without matching customer accounts
SELECT
    s.subscription_id,
    s.account_id
FROM ravenstack_subscriptions AS s
LEFT JOIN ravenstack_accounts AS a
    ON s.account_id = a.account_id
WHERE a.account_id IS NULL;


-- Identify subscription start dates with inconsistent formatting
SELECT
    subscription_id,
    start_date,
    end_date
FROM ravenstack_subscriptions
WHERE start_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';


-- Identify populated subscription end dates with inconsistent formatting
-- Exclude NULL and blank end dates from the format check
SELECT
    subscription_id,
    start_date,
    end_date
FROM ravenstack_subscriptions
WHERE end_date NOT REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
    AND end_date IS NOT NULL
    AND end_date <> '';


-- ============================================================
-- TABLE 3: FEATURE USAGE | DATA PROFILING
-- ============================================================

-- Check for missing values across key product usage fields
SELECT
    COUNT(*) - COUNT(usage_id) AS missing_usage_ids,
    COUNT(*) - COUNT(subscription_id) AS missing_subscription_ids,
    COUNT(*) - COUNT(usage_date) AS missing_usage_dates,
    COUNT(*) - COUNT(feature_name) AS missing_feature_names,
    COUNT(*) - COUNT(usage_count) AS missing_usage_counts,
    COUNT(*) - COUNT(usage_duration_secs) AS missing_usage_durations,
    COUNT(*) - COUNT(error_count) AS missing_error_counts
FROM ravenstack_feature_usage;


-- Identify usage IDs that appear more than once
SELECT
    usage_id,
    COUNT(*) AS duplicate_usage_count
FROM ravenstack_feature_usage
GROUP BY usage_id
HAVING COUNT(*) > 1;


-- Inspect records associated with duplicate usage IDs
-- Retain records until their activity details have been reviewed
SELECT *
FROM ravenstack_feature_usage
WHERE usage_id IN (
    'U-25b56c',
    'U-662254',
    'U-c878da',
    'U-f42b0a',
    'U-8128da',
    'U-d20c6d',
    'U-ae1a6c',
    'U-13ce5b',
    'U-2103bb',
    'U-4ef9da',
    'U-8a3738',
    'U-0c9318'
)
ORDER BY usage_id;


-- Identify negative usage counts, durations, or error counts
SELECT *
FROM ravenstack_feature_usage
WHERE usage_count < 0
    OR usage_duration_secs < 0
    OR error_count < 0;


-- Identify feature usage records without matching subscriptions
SELECT
    u.usage_id,
    u.subscription_id
FROM ravenstack_feature_usage AS u
LEFT JOIN ravenstack_subscriptions AS s
    ON u.subscription_id = s.subscription_id
WHERE s.subscription_id IS NULL;


-- Inspect feature names for inconsistent labels
SELECT DISTINCT
    feature_name
FROM ravenstack_feature_usage
ORDER BY feature_name;


-- ============================================================
-- TABLE 4: SUPPORT TICKETS | DATA PROFILING
-- ============================================================

-- Check for missing values across support ticket fields
SELECT
    COUNT(*) - COUNT(ticket_id) AS missing_ticket_ids,
    COUNT(*) - COUNT(account_id) AS missing_account_ids,
    COUNT(*) - COUNT(submitted_at) AS missing_submission_dates,
    COUNT(*) - COUNT(closed_at) AS missing_closure_dates,
    COUNT(*) - COUNT(resolution_time_hours) AS missing_resolution_times,
    COUNT(*) - COUNT(priority) AS missing_priorities,
    COUNT(*) - COUNT(first_response_time_minutes) AS missing_first_response_times,
    COUNT(*) - COUNT(satisfaction_score) AS missing_satisfaction_scores,
    COUNT(*) - COUNT(escalation_flag) AS missing_escalation_flags
FROM ravenstack_support_tickets;


-- Identify ticket IDs that appear more than once
SELECT
    ticket_id,
    COUNT(*) AS duplicate_ticket_count
FROM ravenstack_support_tickets
GROUP BY ticket_id
HAVING COUNT(*) > 1;


-- Inspect support ticket priority levels for inconsistent categories
SELECT DISTINCT
    priority
FROM ravenstack_support_tickets;


-- Inspect escalation flag values for consistency
SELECT DISTINCT
    escalation_flag
FROM ravenstack_support_tickets;


-- Identify negative response times, resolution times, or satisfaction scores
SELECT *
FROM ravenstack_support_tickets
WHERE resolution_time_hours < 0
    OR first_response_time_minutes < 0
    OR satisfaction_score < 0;


-- Inspect the minimum and maximum customer satisfaction scores
SELECT
    MIN(satisfaction_score) AS min_satisfaction_score,
    MAX(satisfaction_score) AS max_satisfaction_score
FROM ravenstack_support_tickets;


-- Identify support tickets closed before their submission date
SELECT
    ticket_id,
    submitted_at,
    closed_at
FROM ravenstack_support_tickets
WHERE submitted_at > closed_at;


-- Identify support tickets without matching customer accounts
SELECT
    s.ticket_id,
    s.account_id
FROM ravenstack_support_tickets AS s
LEFT JOIN ravenstack_accounts AS a
    ON s.account_id = a.account_id
WHERE a.account_id IS NULL;


-- ============================================================
-- TABLE 5: CHURN EVENTS | DATA PROFILING
-- ============================================================

-- Check for missing values across churn event fields
SELECT
    COUNT(*) - COUNT(churn_event_id) AS missing_churn_event_ids,
    COUNT(*) - COUNT(account_id) AS missing_account_ids,
    COUNT(*) - COUNT(churn_date) AS missing_churn_dates,
    COUNT(*) - COUNT(reason_code) AS missing_reason_codes,
    COUNT(*) - COUNT(refund_amount_usd) AS missing_refund_amounts,
    COUNT(*) - COUNT(preceding_downgrade_flag) AS missing_preceding_downgrade_flags,
    COUNT(*) - COUNT(preceding_upgrade_flag) AS missing_preceding_upgrade_flags,
    COUNT(*) - COUNT(is_reactivation) AS missing_reactivation_flags,
    COUNT(*) - COUNT(feedback_text) AS missing_feedback_text
FROM ravenstack_churn_events;


-- Identify churn event IDs that appear more than once
SELECT
    churn_event_id,
    COUNT(*) AS duplicate_churn_event_count
FROM ravenstack_churn_events
GROUP BY churn_event_id
HAVING COUNT(*) > 1;


-- Identify churn events with negative refund amounts
SELECT
    churn_event_id,
    refund_amount_usd
FROM ravenstack_churn_events
WHERE refund_amount_usd < 0;


-- Inspect churn reasons for inconsistent categories
SELECT DISTINCT
    reason_code
FROM ravenstack_churn_events;


-- Inspect preceding downgrade flag values for consistency
SELECT DISTINCT
    preceding_downgrade_flag
FROM ravenstack_churn_events;


-- Inspect preceding upgrade flag values for consistency
SELECT DISTINCT
    preceding_upgrade_flag
FROM ravenstack_churn_events;


-- Inspect reactivation flag values for consistency
SELECT DISTINCT
    is_reactivation
FROM ravenstack_churn_events;


-- Identify churn events without matching customer accounts
SELECT
    c.churn_event_id,
    c.account_id
FROM ravenstack_churn_events AS c
LEFT JOIN ravenstack_accounts AS a
    ON c.account_id = a.account_id
WHERE a.account_id IS NULL;


-- Identify churn events dated before the customer's signup date
SELECT
    c.churn_event_id,
    c.account_id,
    c.churn_date,
    a.signup_date
FROM ravenstack_churn_events AS c
LEFT JOIN ravenstack_accounts AS a
    ON c.account_id = a.account_id
WHERE a.signup_date > c.churn_date;
