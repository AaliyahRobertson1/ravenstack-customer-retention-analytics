-- ============================================================
-- RAVENSTACK | BUSINESS ANALYSIS
-- 12 SQL business questions
-- ============================================================

-- Question 1: Calculate total monthly recurring revenue (MRR) by subscription plan
-- and rank plans from highest to lowest revenue
SELECT 
	plan_tier,
	SUM(mrr_amount) AS total_monthly_revenue
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY total_monthly_revenue DESC;


-- Question 2: Calculate the number of churned subscriptions by plan tier
-- and rank plans from highest to lowest churn volume
SELECT 
	plan_tier,
	COUNT(*) AS churned_subscriptions
FROM ravenstack_subscriptions
WHERE churn_flag = 'True'
GROUP BY plan_tier
ORDER BY churned_subscriptions DESC;


-- Question 3: Calculate the churn rate for each subscription plan
-- and rank plans from highest to lowest churn rate
SELECT
    plan_tier,
    SUM(CASE 
            WHEN churn_flag = 'true' THEN 1 
            ELSE 0
        END) / COUNT(*) * 100 AS churn_rate
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY churn_rate DESC;


-- Question 4: Compare average monthly recurring revenue across subscription plans
-- and rank plans from highest to lowest average MRR
SELECT
	plan_tier,
	AVG(mrr_amount) AS monthly_revenue_average
FROM ravenstack_subscriptions
GROUP BY plan_tier
ORDER BY monthly_revenue_average DESC;


-- Question 5: Calculate total product usage by feature
-- and rank features from highest to lowest overall activity

SELECT
    feature_name,
    SUM(usage_count) AS usage_total
FROM ravenstack_feature_usage
GROUP BY feature_name
ORDER BY usage_total DESC;


-- Question 6: Compare average product usage between churned and non-churned subscriptions
-- including subscriptions with no recorded feature usage
WITH feature_usage AS (
    SELECT
        subscription_id,
        SUM(usage_count) AS total_feature_usage
    FROM ravenstack_feature_usage
    GROUP BY subscription_id
)
SELECT
    s.churn_flag,
    AVG(COALESCE(f.total_feature_usage, 0)) AS average_feature_usage
FROM ravenstack_subscriptions s
LEFT JOIN feature_usage f
    ON s.subscription_id = f.subscription_id
GROUP BY s.churn_flag;


-- Question 7: Compare average support ticket volume between churned and non-churned accounts
-- including accounts with no support tickets
WITH support_tickets AS (
    SELECT
        account_id,
        COUNT(ticket_id) AS ticket_count
    FROM ravenstack_support_tickets
    GROUP BY account_id
)
SELECT
    a.churn_flag,
    AVG(COALESCE(t.ticket_count, 0)) AS average_ticket_count
FROM ravenstack_accounts a
LEFT JOIN support_tickets t
    ON a.account_id = t.account_id
GROUP BY a.churn_flag;


-- Question 8: Compare average monthly recurring revenue between upgraded and non-upgraded subscriptions
-- to evaluate whether upgrades are associated with stronger revenue performance
SELECT
	upgrade_flag,
	AVG(mrr_amount) AS average_monthly_revenue
FROM ravenstack_subscriptions
GROUP BY upgrade_flag;


-- Question 9: Compare churn rates between downgraded and non-downgraded subscriptions
-- to evaluate whether downgrades are associated with a higher likelihood of churn
SELECT
    downgrade_flag,
    SUM(
        CASE 
            WHEN churn_flag = 'true' THEN 1 
            ELSE 0
        END
    ) / COUNT(*) * 100 AS churn_rate
FROM ravenstack_subscriptions
GROUP BY downgrade_flag;


-- Question 10: Calculate each subscription's share of total monthly recurring revenue
-- to identify the subscriptions contributing the most to company MRR
SELECT
    subscription_id,
    mrr_amount,
    SUM(mrr_amount) OVER() AS total_company_mrr,
    mrr_amount / SUM(mrr_amount) OVER() * 100 AS revenue_percentage
FROM ravenstack_subscriptions
ORDER BY revenue_percentage DESC;		


-- Question 11: Identify subscriptions generating above-average monthly recurring revenue (MRR)
-- to highlight high-value subscriptions for revenue and retention analysis
SELECT
    subscription_id,
    mrr_amount
FROM ravenstack_subscriptions
WHERE mrr_amount > (
    SELECT AVG(mrr_amount)
    FROM ravenstack_subscriptions);



-- Question 12: Identify industries with customer churn rates above
-- the company's overall customer churn rate
WITH industry_churn AS (
    SELECT
        industry,
        SUM(CASE WHEN churn_flag = 'true' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate
    FROM ravenstack_accounts
    GROUP BY industry
),
overall_churn AS (
    SELECT
        SUM(CASE WHEN churn_flag = 'true' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS overall_churn_rate
    FROM ravenstack_accounts
)
SELECT
    i.industry,
    i.churn_rate
FROM industry_churn i
CROSS JOIN overall_churn o
WHERE i.churn_rate > o.overall_churn_rate
ORDER BY i.churn_rate DESC;
