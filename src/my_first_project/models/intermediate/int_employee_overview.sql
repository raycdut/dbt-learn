-- intermediate: employee overview — 合并 HR + Person 公司员工相关表
{{ config(materialized='table') }}

WITH
-- Latest department assignment (most recent start_date)
latest_dept AS (
    SELECT e.business_entity_id, e.department_id, e.shift_id, e.start_date
    FROM {{ ref('stg_hr_employee_department_history') }} e
    JOIN (
        SELECT business_entity_id, MAX(start_date) AS max_start
        FROM {{ ref('stg_hr_employee_department_history') }}
        GROUP BY business_entity_id
    ) m ON e.business_entity_id = m.business_entity_id AND e.start_date = m.max_start
),

-- Latest pay rate
latest_pay AS (
    SELECT e.business_entity_id, e.rate_change_date, e.rate, e.pay_frequency
    FROM {{ ref('stg_hr_employee_pay_history') }} e
    JOIN (
        SELECT business_entity_id, MAX(rate_change_date) AS max_date
        FROM {{ ref('stg_hr_employee_pay_history') }}
        GROUP BY business_entity_id
    ) m ON e.business_entity_id = m.business_entity_id AND e.rate_change_date = m.max_date
),

-- Primary email (min email_address_id)
primary_email AS (
    SELECT e.business_entity_id, e.email_address
    FROM {{ ref('stg_person_email_address') }} e
    JOIN (
        SELECT business_entity_id, MIN(email_address_id) AS min_id
        FROM {{ ref('stg_person_email_address') }}
        GROUP BY business_entity_id
    ) m ON e.business_entity_id = m.business_entity_id AND e.email_address_id = m.min_id
),

-- Primary address (min address_id)
primary_address AS (
    SELECT bea.business_entity_id, a.address_line_1, a.city, a.state_province_id, a.postal_code
    FROM (
        SELECT bea.business_entity_id, bea.address_id
        FROM {{ ref('stg_person_business_entity_address') }} bea
        JOIN (
            SELECT business_entity_id, MIN(address_id) AS min_id
            FROM {{ ref('stg_person_business_entity_address') }}
            GROUP BY business_entity_id
        ) m ON bea.business_entity_id = m.business_entity_id AND bea.address_id = m.min_id
    ) bea
    LEFT JOIN {{ ref('stg_person_address') }} a ON bea.address_id = a.address_id
)

SELECT
    e.business_entity_id,
    e.national_id_number,
    e.login_id,
    e.organization_node,
    e.organization_level,
    e.job_title,
    e.birth_date,
    e.marital_status,
    e.gender,
    e.hire_date,
    e.salaried_flag,
    e.vacation_hours,
    e.sick_leave_hours,
    -- person info
    p.full_name,
    p.title,
    p.first_name,
    p.middle_name,
    p.last_name,
    -- department info
    d.name               AS department_name,
    d.group_name          AS department_group_name,
    -- shift info
    s.name                AS shift_name,
    s.start_time          AS shift_start_time,
    s.end_time            AS shift_end_time,
    -- pay info
    lpr.rate              AS current_pay_rate,
    lpr.pay_frequency,
    lpr.rate_change_date  AS last_pay_rate_change_date,
    -- contact info
    pe.email_address,
    -- address info
    pa.address_line_1,
    pa.city,
    pa.postal_code,
    sp.name               AS state_province_name
FROM {{ ref('stg_hr_employee') }} e
LEFT JOIN {{ ref('stg_person', v=2) }} p ON e.business_entity_id = p.business_entity_id
LEFT JOIN latest_dept ld ON e.business_entity_id = ld.business_entity_id
LEFT JOIN {{ ref('stg_hr_department') }} d ON ld.department_id = d.department_id
LEFT JOIN {{ ref('stg_hr_shift') }} s ON ld.shift_id = s.shift_id
LEFT JOIN latest_pay lpr ON e.business_entity_id = lpr.business_entity_id
LEFT JOIN primary_email pe ON e.business_entity_id = pe.business_entity_id
LEFT JOIN primary_address pa ON e.business_entity_id = pa.business_entity_id
LEFT JOIN {{ ref('stg_person_state_province') }} sp ON pa.state_province_id = sp.state_province_id
WHERE e.current_flag = TRUE
