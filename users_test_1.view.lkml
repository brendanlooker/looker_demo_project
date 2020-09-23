view: users_test_1 {
  derived_table: {
    sql_trigger_value: select current_date ;;
    distribution_style: all
    sql: SELECT
        users_test.email  AS "users_test.email",
        users_test.first_name  AS "users_test.first_name",
        users_test.last_name  AS "users_test.last_name",
        users_test.state AS "users_test.state",
        CASE WHEN (DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', GETDATE() )))-(DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', users_test.created_at ))) < 90 THEN 'Yes' ELSE 'No' END
       AS "users_test.is_new_user"
      FROM public.users  AS users_test

      WHERE case when 1=1 -- no filter on 'users_test.state_filter'
       then 1=1
          else 1=1 -- no filter on 'users_test.state_filter'
       end
      GROUP BY 1,2,3,4,5
      ORDER BY 1
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: users_test_email {
    primary_key: yes
    type: string
    sql: ${TABLE}."users_test.email" ;;
  }

  dimension: users_test_first_name {
    type: string
    sql: ${TABLE}."users_test.first_name" ;;
  }

  dimension: users_test_last_name {
    type: string
    sql: ${TABLE}."users_test.last_name" ;;
  }

  dimension: users_test_state {
    type: string
    sql: ${TABLE}."users_test.state" ;;
  }

  dimension: users_test_is_new_user {
    type: string
    sql: ${TABLE}."users_test.is_new_user" ;;
  }

  set: detail {
    fields: [users_test_email, users_test_first_name, users_test_last_name, users_test_state, users_test_is_new_user]
  }
}
