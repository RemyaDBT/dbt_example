{% macro update_model_time_post_hook(model_name) %}
    update 
        dbt_practise.model_info.model_time
    set
        end_time = current_timestamp()
    where
        model_name = '{{ model_name }}'
{% endmacro %}