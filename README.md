
# RavenStack | Customer Retention & Revenue Analytics

## Project Overview

This project analyzes customer churn, subscription revenue, product usage, support activity, and acquisition sources for RavenStack, a SaaS business. I used MySQL to profile and analyze five related datasets and Power BI to build an interactive dashboard that helps stakeholders understand retention patterns and revenue concentration.

## Business Objective

Identify where customer churn is concentrated, understand which segments contribute the most subscription revenue, and recommend evidence-based priorities for retention and marketing decisions.

**Executive Summary:** RavenStack has a 22% customer churn rate alongside strong growth in new subscriptions. Enterprise subscriptions account for approximately 75% of total subscription MRR, making this segment a key revenue-protection priority. DevTools customers and Event-acquired referrals have the highest observed churn rates in their respective categories, making them useful starting points for targeted retention efforts.

## Tools & Skills

- **MySQL:** Data profiling, joins, aggregations, common table expressions (CTEs), subqueries, and window functions
- **Power BI:** Data modeling, DAX measures, interactive slicers, KPI cards, and visual reporting
- **Business analysis:** Churn segmentation, revenue analysis, interpretation of findings, and actionable recommendations

## Dataset Overview

The analysis uses five related tables:

| Table | Purpose |
|---|---|
| ravenstack_accounts | Account attributes, industry, referral source, and customer churn status |
| ravenstack_subscriptions | Subscription plans, recurring revenue, dates, and subscription churn |
| ravenstack_feature_usage | Product feature usage associated with subscriptions |
| ravenstack_support_tickets | Customer support activity associated with accounts |
| ravenstack_churn_events | Recorded churn events, reasons, and feedback |

Customer-level churn and subscription-level churn are distinct metrics and are analyzed separately.

## Analysis Approach

1. Profiled data quality across the five tables, including missing values, duplicate identifiers, inconsistent categorical values, invalid dates, and unmatched account references.
2. Completed 12 SQL business analyses covering MRR by plan, churn volume and rates, feature usage, support tickets, upgrades and downgrades, revenue contribution, above-average subscriptions, and industry churn.
3. Performed follow-up churn-reason analysis by joining churn events to customer accounts, first for DevTools and then across industries.
4. Modeled the data in Power BI and built an interactive one-page report with Industry and Plan Tier slicers.
5. Cross-checked key dashboard metrics against SQL outputs, including plan MRR, subscription churn by plan, average feature usage, and average support tickets.

## Power BI Dashboard

The dashboard includes total accounts, customer churn, total subscription MRR, a retention breakdown, revenue and churn by plan, churn by industry and referral source, product usage and support comparisons, and monthly new subscriptions.

*Dashboard screenshot will be added here.*

## Key Metrics

| Metric | Value |
|---|---:|
| Total accounts | 500 |
| Customer churn rate | 22% |
| Retained accounts | 390 |
| Churned accounts | 110 |
| Total subscription MRR (sum of subscription MRR fields) | $11.34M |

**Metric Note:** The MRR figure is calculated by summing the subscription MRR values in the dataset; it does not represent a verified point-in-time active MRR balance. Customer churn and subscription churn are calculated separately at the account and subscription levels.

## Key Business Findings & Recommendations

### 1. DevTools Has the Highest Customer Churn

**Finding:** DevTools has a 31% customer churn rate, compared with 22% company-wide. Among 142 recorded DevTools churn events, budget and support were tied as the most frequently reported reasons (27 each), followed closely by features (26), competitors (25), and pricing (22).

**Recommendation:** Prioritize DevTools for a targeted retention initiative instead of immediately investing in a company-wide program. Have Customer Success conduct focused exit interviews to better understand the reported concerns, develop targeted improvements, and evaluate their effectiveness before expanding the initiative.

### 2. Event Referrals Have the Highest Customer Churn

**Finding:** Event-acquired customers have a 30% churn rate versus 15% for Partner referrals. Other referral sources also have lower churn rates, including Ads at 23% and Organic at 18%.

**Recommendation:** Review Event acquisition campaigns and test improvements to the onboarding experience before increasing spending on that channel. Compare acquisition costs and customer retention across referral sources to guide future marketing budget decisions.

**Business value:** Helps Marketing avoid expanding investment in a channel with relatively poor observed retention before confirming its overall financial performance.

### 3. Enterprise Generates the Majority of Subscription Revenue

**Finding:** Enterprise subscriptions generate approximately $8.47M of RavenStack's $11.34M total subscription MRR, accounting for roughly 75% of the total. Enterprise's subscription churn rate is 9.98%, compared with 9.67% for Pro and 9.49% for Basic.

**Recommendation:** Prioritize Enterprise retention planning because this segment represents the largest share of subscription revenue. Focus retention resources on protecting high-value accounts, with targeted outreach and renewal support rather than offering costly incentives to every Enterprise customer.

**Business value:** Directs retention resources toward a financially important segment while avoiding unnecessary blanket incentives.

### 4. Overall Feature Usage Shows Little Difference Between Churn Groups

**Finding:** Retained subscriptions average 42.37 feature uses, compared with 40.73 for churned subscriptions. The difference is relatively small.

**Recommendation:** Avoid using average feature usage alone to determine which customers need retention outreach. Evaluate specific feature engagement patterns before investing in automated low-usage alerts.

**Business value:** Helps prevent investment in an overly simplistic churn indicator that may not effectively distinguish churned from retained subscriptions.

### 5. Support Ticket Volume Is Nearly Identical Across Churn Groups

**Finding:** Retained accounts average 2.35 support tickets, compared with 2.36 for churned accounts.

**Recommendation:** Do not use support ticket volume alone to prioritize churn-prevention outreach. If support-related churn is investigated further, focus on the nature of complaints and customer experiences rather than simply the number of tickets submitted.

**Business value:** Helps Customer Success avoid allocating retention resources based on a metric that shows almost no difference between the two groups.

## Interpretation & Limitations

- The 22% customer churn figure is a dataset-level proportion; it should not be compared with annual industry churn benchmarks without confirming the observation period.
- Recorded churn reasons describe events, which may not represent unique customers or prove the cause of churn.
- Similar average feature usage and support ticket counts do not rule out more detailed relationships with churn.
- Recommendations are proposed actions based on observed patterns; their financial effects have not been experimentally verified.

## Repository Contents

- README.md — project overview, approach, findings, and recommendations
- sql/ — data profiling, business analysis, and supplementary churn-reason SQL scripts
- powerbi/ — Power BI report (.pbix)
- images/ — dashboard screenshot

## Project Outcome

This project demonstrates an end-to-end analytics workflow: validating source data, writing SQL to answer business questions, building an interactive Power BI dashboard, reconciling results, and translating findings into practical retention and revenue recommendations.
