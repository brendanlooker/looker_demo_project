include: "*.view.lkml"
view: users {
  sql_table_name: public.users ;;


extends: [users_etd]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: my_filter {

  }

  dimension: age {
    # required_access_grants: [my_access]
    type: number
    sql: ${TABLE}.age ;;
  }

  measure: distinct_age_count {
    type: count_distinct
    sql: ${age} ;;
  }


  dimension: arrow_right_down {
    sql:1 ;;
    html: <p style="text-align:centre;font-size:100px;">&#8628; </p>;;
  }

  dimension: arrow_down_left {
    sql:1 ;;
    html: <p style="text-align:centre;font-size:100px;">&#8626; </p>;;
  }

  dimension: age_tier {
    type: tier
    tiers: [15,26,36,51,66]
    style: integer
    sql: ${TABLE}.age ;;
  }

  parameter: state_parameter {
    allowed_value: {
      label: "Arizona"
      value: "Arizona"
    }
    allowed_value: {
      label: "New York"
      value: "New York"
    }
    allowed_value: {
      label: "All"
      value: "All"
    }
  }

  parameter: city_parameter {
    type: string
    allowed_value: {
      label: "Boston"
      value: "Boston"
    }
    allowed_value: {
      label: "New York"
      value: "New York"
    }
    allowed_value: {
      label: "All"
      value: "All"
    }
  }

  filter: test {
    type: string
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city;;
    drill_fields: [longitude,latitude]
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
    drill_fields: [state]
  }

  dimension: country_map {
    map_layer_name: countries
    sql: ${country} ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_month,
      week,
      month,
      month_name,
      month_num,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: year {
    type: date
    sql: ${created_year} ;;
    drill_fields: [created_month]
  }


  parameter: period_over_period {
    description: "Period-over-Period Options"
    type: string
    label: "Period-over-Period"
    allowed_value: {
      label: "Year-over-Year"
      value: "YoY"
    }
    allowed_value: {
      label: "Month-over-Month (v Previous Year)"
      value: "MoM-Y"
    }
    allowed_value: {
      label: "Month-over-Month (v Previous Month)"
      value: "MoM-M"
    }
    allowed_value: {
      label: "Quarter-over-Quarter (v Previous Quarter)"
      value: "QoQ-Q"
    }
    allowed_value: {
      label: "Quarter-over-Quarter (v Previous Year)"
      value: "QoQ-Y"
    }
  }

  parameter: period_over_period_offset {
    type: number
    default_value: "0"
    description: "Used to offset the Month and Quarter PoP Analysis"
  }

  filter: period_over_period_filter {
    description: "Required in order to dynamically inject SQL into the where clause based on the period-over-period analysis required"
    hidden: no
    default_value: "is not null"
    type: string
    sql: {% if period_over_period._parameter_value == "'YoY'" %}

            extract(month from ${created_date}) < extract(month from getdate())
            or (extract(month from ${created_date}) = extract(month from getdate()) and extract(day from ${created_date}) <= extract(day from getdate()))

          {% elsif period_over_period._parameter_value == "'MoM-Y'" %}

          extract(month from ${created_date}) = extract(month from dateadd(month,{% parameter period_over_period_offset %},getdate()))
          and extract(day from ${created_date}) <= extract(day from dateadd(month,{% parameter period_over_period_offset %},getdate()))

          {% elsif period_over_period._parameter_value == "'MoM-M'" %}

          ${created_date} >= date_trunc('month',dateadd(month,-1,dateadd(month,{% parameter period_over_period_offset %},getdate())))
          and ${created_date} <= last_day(dateadd(month,{% parameter period_over_period_offset %},getdate()))
          and extract(day from ${created_date}) <= extract(day from getdate())

          {% elsif period_over_period._parameter_value == "'QoQ-Q'" %}

          ${created_date} >= date_trunc('quarter',dateadd(quarter,-2,dateadd(quarter,{% parameter period_over_period_offset %},getdate())))
          and ${created_date} <= dateadd(day,-1,date_trunc('quarter',dateadd(quarter,0,dateadd(quarter,{% parameter period_over_period_offset %},getdate()))))
              and extract(day from (${created_date} - date_trunc('quarter', ${created_date})))+1 <= extract(day from (getdate() - date_trunc('quarter', getdate())))+1 -- need to generate the quarter day, otherwise ewsults from days within future months in the quarter will be included

          {% elsif period_over_period._parameter_value == "'QoQ-Y'" %}

          extract(quarter from ${created_date}) = extract(quarter from dateadd(quarter,{% parameter period_over_period_offset %},getdate()))
          and extract(month from ${created_date}) <= extract(month from dateadd(quarter,{% parameter period_over_period_offset %},getdate()))
          and extract(day from (${created_date} - date_trunc('quarter', ${created_date})))+1 <= extract(day from (getdate() - date_trunc('quarter', getdate())))+1 -- need to generate the quarter day, otherwise ewsults from days within future months in the quarter will be included


          {% else %}

            NULL
          {% endif %} ;;
  }


  filter: users_cities_filter {
    type: string
    full_suggestions: yes
    suggest_dimension: city

  }

  dimension: east_coast_city_choice {
    type: string
    sql:  case when {% condition users_cities_filter %} ${city} {% endcondition %} then 1 else 0 end;;
  }


  measure: period_over_period_user_count {
    description: ""
    type: number
    sql: {% if period_over_period._parameter_value == "'YoY'" %}

                 sum(case when ( extract(month from ${created_date}) < extract(month from getdate())
                  or (extract(month from ${created_date}) = extract(month from getdate()) and extract(day from ${created_date}) <= extract(day from getdate()))) then 1 else NULL end)

                {% elsif period_over_period._parameter_value == "'MoM-Y'" %}

                sum(case when (extract(month from ${created_date}) = extract(month from dateadd(month,{% parameter period_over_period_offset %},getdate()))
                and extract(day from ${created_date}) <= extract(day from dateadd(month,{% parameter period_over_period_offset %},getdate()))) then 1 else NULL end)

                {% elsif period_over_period._parameter_value == "'MoM-M'" %}

                sum(case when (${created_date} >= date_trunc('month',dateadd(month,-1,dateadd(month,{% parameter period_over_period_offset %},getdate())))
                and ${created_date} <= last_day(dateadd(month,{% parameter period_over_period_offset %},getdate()))
                and extract(day from ${created_date}) <= extract(day from getdate())) then 1 else NULL end)

                {% elsif period_over_period._parameter_value == "'QoQ-Q'" %}

                sum(case when (${created_date} >= date_trunc('quarter',dateadd(quarter,-1,dateadd(quarter,{% parameter period_over_period_offset %},getdate())))
                and ${created_date} <= dateadd(day,-1,date_trunc('quarter',dateadd(quarter,1,dateadd(quarter,{% parameter period_over_period_offset %},getdate()))))
                    and extract(day from (${created_date} - date_trunc('quarter', ${created_date})))+1 <= extract(day from (getdate() - date_trunc('quarter', getdate())))+1) then 1 else NULL end) -- need to generate the quarter day, otherwise ewsults from days within future months in the quarter will be included

                {% elsif period_over_period._parameter_value == "'QoQ-Y'" %}

                sum(case when (extract(quarter from ${created_date}) = extract(quarter from dateadd(quarter,{% parameter period_over_period_offset %},getdate()))
                and extract(month from ${created_date}) <= extract(month from dateadd(quarter,{% parameter period_over_period_offset %},getdate()))
                and extract(day from (${created_date} - date_trunc('quarter', ${created_date})))+1 <= extract(day from (getdate() - date_trunc('quarter', getdate())))+1) then 1 else NULL end) -- need to generate the quarter day, otherwise ewsults from days within future months in the quarter will be included


                {% else %}

                  NULL
                {% endif %} ;;
  }


  dimension: days_since_signup {
    # hidden: yes
    type: duration_day
    sql_start: case when ${created_date} < '01 Jan 2019' then '01 Jan 2019' else ${created_date} end ;;
    sql_end: current_date;;
  }

  dimension: days_since_signup_tiers {
    type: tier
    tiers: [5,10,30,60,90,180,360]
    style: integer
    sql: ${days_since_signup} ;;
  }

  dimension: months_since_signup {
    hidden: yes
    type: number
    sql: datediff(month,${created_date}, getdate()) ;;
  }

  dimension: months_since_signup_tiers {
    type: tier
    tiers: [1,3,6,12,18]
    sql: ${months_since_signup} ;;
  }

  dimension: dashborard_access {
    sql: 1 ;;
    html:<div class="vis">
          <div class="vis-single-value" style="background-color: #d6d6d6">
          <p style="color: #707070; font-size: 30px; font-weight: bolder"> Dashboard 1 </p>
          </div>
          </div>
          ;;
    }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    description: "Bla Bla Bla"
    type: string
    sql: ${TABLE}.state;;
    drill_fields: [city]

    link: {
      label: "Test Link"
      url: "/dashboards/24?State={{ value }}&Age={{ _filters['users.age'] | url_encode }}&City={{ 'San Francisco' | url_encode }}"
    }
  }

  dimension: state_map {
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: user_location {
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
    drill_fields: [age_tier, gender]
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  dimension: is_new_user {
    type: yesno
    sql: ${current_date}-${created_date} < 90;;
  }

  dimension_group: current {
    type: time
    sql: GETDATE() ;;
  }


  measure: users_who_have_returned_items {
    type: count_distinct
    html: {{ products.department }}{{rendered_value}} ;;
    sql: ${id} ;;
    filters: {
      field: order_items.returned_date
      value: "-NULL"

    }
    description: "Count of distinct users who have returned an item"
  }

  measure: users_with_returns_pct {
    type: number
    sql: 1.0*${users_who_have_returned_items}/${user_count};;
    value_format_name: percent_2
    description: "Percentage of Users who have returned an item"
  }

  # measure: average_spend_per_user {
  #   type: number
  #   sql: 1.0*${order_items.total_sales}/${user_count} ;;
  #   value_format_name: usd_0
  #   description: "Average spend per User (all Users)"
  # }

  measure: average_days_since_signup {
    type: average
    sql: ${days_since_signup} ;;
  }

  measure: average_months_since_signip {
    type: average
    sql: ${months_since_signup} ;;
  }

  measure: my_constant {
    type: number
    sql: 144 ;;
  }

  measure: user_count {
    hidden: yes
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }
}
