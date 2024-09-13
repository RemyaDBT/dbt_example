{% set methods = ['credit_card','coupon','bank_transfer','gift_card']%}
with payments as (
    select * from {{ ref('stg_stripe__payments') }}
),

pivoted as (
    select 
        order_id,
        {%- for method in methods %}
        sum(case when payment_method = '{{method}}' then amount else 0 end) as {{method}}_payment
        {%- if not loop.last -%}
        ,
        {%- endif -%}

        {%- endfor %}
    from
        payments
    group by
        1
)

select * from pivoted
where
{% for method in methods %}   case when {{method}}_payment != 0 then 1 else 0 end
    {%- if not loop.last %} +
    {%- endif %}
{% endfor %} > 1