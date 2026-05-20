{% macro person_type_label(column_name='person_type', alias='person_type_label') %}

CASE {{ column_name }}
    WHEN 'SC' THEN '门店客户'
    WHEN 'IN' THEN '个人客户'
    WHEN 'EM' THEN '员工'
    WHEN 'VC' THEN '供应商联系人'
    WHEN 'GC' THEN '一般联系人'
    ELSE '未知'
END{% if alias %} AS {{ alias }}{% endif %}

{% endmacro %}
