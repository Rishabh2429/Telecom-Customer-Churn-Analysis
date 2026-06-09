CREATE TABLE telecom_customer_churn (
    Customer_id TEXT,
    Gender TEXT,
    Age INT,
    Married TEXT,
    Number_of_Dependents INT,
    City TEXT,
    Zip_Code INT,
    Latitude NUMERIC,
    Longitude NUMERIC,
    Number_of_Referrals INT,
    Tenure_in_Months INT,
    Offer TEXT,
    Phone_Service TEXT,
    Avg_Monthly_Long_Distance_Charges NUMERIC,
    Multiple_Lines TEXT,
    Internet_Service TEXT,
    Internet_Type TEXT,
    Avg_Monthly_GB_Download NUMERIC,
    Online_Security TEXT,
    Online_Backup TEXT,
    Device_Protection_Plan TEXT,
    Premium_Tech_Support TEXT,
    Streaming_Tv TEXT,
    Streaming_Movies TEXT,
    Streaming_Music TEXT,
    Unlimited_Data TEXT,
    Contract TEXT,
    Paperless_Billing TEXT,
    Payment_Method TEXT,
    Monthly_Charge NUMERIC,
    Total_Charges NUMERIC,
    Total_Refunds NUMERIC,
    Total_Extra_Data_Charges NUMERIC,
    Total_Long_Distance_Charges NUMERIC,
    Total_Revenue NUMERIC,
    Customer_Status TEXT,
    Churn_Category TEXT,
    Churn_Reason TEXT
);

Q1.Total Customer and Churn OUT?
SELECT 
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN  Customer_Status = 'Churned' THEN 1 END) AS churned_customers
FROM telecom_customer_churn;


Q2. What is the overall Churn Rate?
SELECT 
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN customer_status = 'Churned' THEN 1 END) AS churned,
    ROUND(
        COUNT(CASE WHEN customer_status = 'Churned' THEN 1 END)*100.0 / COUNT(*), 
        2
    ) AS churn_rate
FROM telecom_customer_churn;
Insight: Baseline KPI for business health.


Q3. Which contract type has highest churn?
SELECT 
    contract,
    COUNT(*) AS total,
    COUNT(CASE WHEN customer_status='Churned' THEN 1 END) AS churned,
    ROUND(COUNT(CASE WHEN customer_status='Churned' THEN 1 END)*100.0/COUNT(*),2) AS churn_rate
FROM telecom_customer_churn
GROUP BY contract
ORDER BY churn_rate DESC;
Insight: Month-to-month = highest churn → push long-term contracts



Q4. When do customers churn most?
SELECT 
    CASE 
        WHEN tenure_in_months <= 12 THEN '0-1 Year'
        WHEN tenure_in_months <= 24 THEN '1-2 Years'
        ELSE '2+ Years'
    END AS tenure_group,
    COUNT(*) AS total,
    COUNT(CASE WHEN customer_status='Churned' THEN 1 END) AS churned
FROM telecom_customer_churn
GROUP BY tenure_group
ORDER BY churned DESC;
Insight: Early churn → onboarding issue



Q5. How much revenue is lost?
SELECT 
    ROUND(SUM(total_revenue),2) AS revenue_lost
FROM telecom_customer_churn
WHERE customer_status = 'Churned';
Insight: Shows real financial impact



Q6. Are high-paying customers leaving?
SELECT 
    customer_id,
    total_revenue
FROM telecom_customer_churn
WHERE customer_status = 'Churned'
ORDER BY total_revenue DESC
LIMIT 10;
Insight: Losing premium customers = critical risk



Q7. Does internet type affect churn?
SELECT 
    internet_type,
    COUNT(*) AS total,
    COUNT(CASE WHEN customer_status='Churned' THEN 1 END) AS churned
FROM telecom_customer_churn
GROUP BY internet_type
ORDER BY churned DESC;
Insight: Fiber users often churn more → service quality issue



Q8. Which payment method has highest churn?
SELECT 
    payment_method,
    COUNT(*) AS total,
    COUNT(CASE WHEN customer_status='Churned' THEN 1 END) AS churned
FROM telecom_customer_churn
GROUP BY payment_method
ORDER BY churned DESC;
Insight: Manual payments → higher churn



Q9. Do more services reduce churn?
SELECT 
    (CASE WHEN online_security='Yes' THEN 1 ELSE 0 END +
     CASE WHEN online_backup='Yes' THEN 1 ELSE 0 END +
     CASE WHEN premium_tech_support='Yes' THEN 1 ELSE 0 END) AS service_count,
    COUNT(*) AS total,
    COUNT(CASE WHEN customer_status='Churned' THEN 1 END) AS churned
FROM telecom_customer_churn
GROUP BY service_count
ORDER BY service_count;
Insight: More services = more retention


Q10. Does age affect churn?
SELECT 
    CASE 
        WHEN age < 30 THEN 'Young'
        WHEN age < 60 THEN 'Middle'
        ELSE 'Senior'
    END AS age_group,
    COUNT(*) AS total,
    COUNT(CASE WHEN customer_status='Churned' THEN 1 END) AS churned
FROM telecom_customer_churn
GROUP BY age_group;
Insight: Helps in targeted marketing


Q11. Which cities have highest churn?
SELECT 
    city,
    COUNT(CASE WHEN customer_status='Churned' THEN 1 END) AS churned
FROM telecom_customer_churn
GROUP BY city
ORDER BY churned DESC
LIMIT 10;
Insight: Region-specific issues


Q12. Why are customers leaving?
SELECT 
    churn_reason,
    COUNT(*) AS total
FROM telecom_customer_churn
WHERE customer_status='Churned'
GROUP BY churn_reason
ORDER BY total DESC;
Insight: Direct business action points


Q13. Which category dominates churn?
SELECT 
    churn_category,
    COUNT(*) AS total
FROM telecom_customer_churn
WHERE customer_status='Churned'
GROUP BY churn_category
ORDER BY total DESC;
Insight: Pricing vs service vs competitor


Q14. Do referred customers churn less?
SELECT 
    CASE WHEN number_of_referrals > 0 THEN 'Referred' ELSE 'Not Referred' END AS referral_group,
    COUNT(*) AS total,
    COUNT(CASE WHEN customer_status='Churned' THEN 1 END) AS churned
FROM telecom_customer_churn
GROUP BY referral_group;
Insight: Referral customers are more loyal


Q15. Who is likely to churn?
SELECT 
    customer_id,
    tenure_in_months,
    monthly_charge
FROM telecom_customer_churn
WHERE customer_status='Stayed'
  AND tenure_in_months < 12
  AND monthly_charge > (
        SELECT AVG(monthly_charge) FROM telecom_customer_churn
    );
Insight: Prevent future churn


Q16. Who can be retained easily?
SELECT 
    customer_id,
    tenure_in_months,
    contract
FROM telecom_customer_churn
WHERE contract = 'Month-to-month'
  AND tenure_in_months > 24;
Insight: Convert to long-term customers 