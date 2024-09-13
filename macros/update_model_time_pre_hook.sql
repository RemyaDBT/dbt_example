{% macro update_model_time_pre_hook(model_name) %}
    merge into 
        dbt_practise.model_info.model_time model_time 
    using
        (select 
            '{{ model_name }}' as model_name,
        ) current_model
    on
        model_time.model_name = current_model.model_name

    when matched then 
        update set 
            model_time.start_time = current_timestamp(),
            model_time.end_time = null
    when not matched then 
        insert (model_name,start_time) values (current_model.model_name,current_timestamp())
{% endmacro %}