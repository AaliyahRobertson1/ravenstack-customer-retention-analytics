-- ============================================================
-- RAVENSTACK | SUPPLEMENTARY CHURN REASON ANALYSIS
-- Counts represent churn events, not unique churned accounts.
-- ============================================================

-- Identify the most common recorded churn reasons
-- among DevTools customers
SELECT
    c.reason_code,
    COUNT(*) AS churn_event_count
FROM ravenstack_churn_events AS c
INNER JOIN ravenstack_accounts AS a
    ON c.account_id = a.account_id
WHERE a.industry = 'DevTools'
GROUP BY c.reason_code
ORDER BY churn_event_count DESC;


-- Compare recorded churn reasons across industries
SELECT
    a.industry,
    c.reason_code,
    COUNT(*) AS churn_event_count
FROM ravenstack_churn_events AS c
INNER JOIN ravenstack_accounts AS a
    ON c.account_id = a.account_id
GROUP BY a.industry, c.reason_code
ORDER BY a.industry, churn_event_count DESC;
