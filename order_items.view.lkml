
view: order_items {
  sql_table_name: public.order_items ;;


  view_label: "Orders"

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      day_of_week,
      day_of_month,
      month_name,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;

  }

  dimension: created_mth {
    type: yesno
    sql: ${created_month} ;;
  }

  dimension: bb_date {
    type: date
    sql: ${created_date} ;;
    drill_fields: [created_month]

  }


  dimension: days_in_filter {
    type: duration_day
    sql_start: {% date_start created_date %} ;;
    sql_end: {% date_end created_date %} ;;

  }

  dimension: created_dynamic {
    label: "{% if created_date._in_query %} Created qweqweqwe
            {% elsif created_week._in_query %} Created Week
            {% elsif created_month._in_query %} Created Month
            {% endif %}"
    type: string
    sql: case when ${days_in_filter} < 15 then cast(${created_date} as date)
              when ${days_in_filter} >= 15 and ${days_in_filter} < 90 then cast (${created_week} as date)
              when ${days_in_filter} >=90 then cast(${created_month} as date) end;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    value_format_name: usd
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: total_sales {
    type: sum
    sql: ${sale_price};;
    # value_format_name:bb
    description: "Total Sale Price"
    html: {{linked_value}} ;;
   value_format_name: usd_0
  drill_fields: [users.state]
  }

  measure: total_dockers_sales {
    type: sum
    sql: ${sale_price};;
    # value_format_name:bb
    description: "Total Sale Price"
    # filters: [products.is_dockers: "Yes"]
  }

  measure: average_sale_price {
    type: average
    sql: ${sale_price};;
    description: "Average Sale Price"
    value_format_name: usd_0
  }

  measure: cumulative_total_sales {
    type: running_total
    sql: ${total_sales} ;;
    value_format_name: usd_0
    description: "Cumulative Total Sales"
  }

  measure: total_gross_revenue {
    tags: ["email","brand","total_gross_revenue"]
    type: sum
    sql: ${sale_price} ;;
    filters: {
      field: returned_date
      value: "NULL"
    }
    filters: {
      field: status
      value: "-Cancelled"
    }
    value_format_name: usd_0
    description: "Total Gross Revenue - Total revenue from completed sales (cancelled and returned orders excluded)"
    drill_fields: [order_id,created_date,user_id,products.name,sale_price]
  }

  measure: total_gross_margin {
    type: number
    sql: ${total_gross_revenue}-${inventory_items.total_cost} ;;
    value_format_name: usd_0
    description: "Total Gross Margin - Total Gross Revenue minus Total Cost"
    drill_fields: [products.brand, total_gross_margin]
  }

  measure: total_gross_revenue_all_orders {
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd_0
    description: "Total Gross Revenue All Orders - Total revenue from completed sales (cancelled and returned orders included)"
  }

  measure: gross_margin_pct {
    type: number
    sql: ${total_gross_margin}/${total_gross_revenue_all_orders} ;;
    value_format_name: percent_2
    description: "Gross Margin Percentage - Total Gross Margin devided by Total Revenue"
    drill_fields: [created_date, gross_margin_pct]
  }

  measure: number_of_items_returned {
    type: count_distinct
    sql: ${inventory_item_id} ;;
    filters: {
      field: returned_date
      value: "-NULL"
    }
    description: "Number of Items Returned"
  }

  measure: item_return_rate {
    type: number
    sql: (1.0*${number_of_items_returned}/${inventory_items.total_items_sold}) ;;
    description: "Items Returned Rate"
    value_format_name: percent_2
    html: {{ rendered_value }} || {{ number_of_items_returned._rendered_value }} of total>> ;;
  }

  measure: order_item_count {
    type: count
    drill_fields: [detail*]

    html:
    <span style="font-size: 14px">{{rendered_value}}</span>
    {% if item_return_rate._value > 0 %}
    <span style="color: green"> ▴ {{ item_return_rate._rendered_value }}</span>
    {% elsif item_return_rate._value < 0 %}
    <span style="color: tomato"> ▾ {{ item_return_rate._rendered_value }}</span>
    {% else %}
    <span style="color: tomato"> ▾ {{ item_return_rate._rendered_value }}</span>
    {% endif %};;
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

  measure: period_over_period_total_sales {
    description: "Total Sales for the defined period"
    value_format_name: usd_0
    type: number
    sql: {% if period_over_period._parameter_value == "'YoY'" %}

                       sum(case when ( extract(month from ${created_date}) < extract(month from getdate())
                        or (extract(month from ${created_date}) = extract(month from getdate()) and extract(day from ${created_date}) <= extract(day from getdate()))) then ${sale_price} else NULL end)

                      {% elsif period_over_period._parameter_value == "'MoM-Y'" %}

                      sum(case when (extract(month from ${created_date}) = extract(month from dateadd(month,{% parameter period_over_period_offset %},getdate()))
                      and extract(day from ${created_date}) <= extract(day from dateadd(month,{% parameter period_over_period_offset %},getdate()))) then ${sale_price} else NULL end)

                      {% elsif period_over_period._parameter_value == "'MoM-M'" %}

                      sum(case when (${created_date} >= date_trunc('month',dateadd(month,-1,dateadd(month,{% parameter period_over_period_offset %},getdate())))
                      and ${created_date} <= last_day(dateadd(month,{% parameter period_over_period_offset %},getdate()))
                      and extract(day from ${created_date}) <= extract(day from getdate())) then ${sale_price} else NULL end)

                      {% elsif period_over_period._parameter_value == "'QoQ-Q'" %}

                      sum(case when (${created_date} >= date_trunc('quarter',dateadd(quarter,-1,dateadd(quarter,{% parameter period_over_period_offset %},getdate())))
                      and ${created_date} <= dateadd(day,-1,date_trunc('quarter',dateadd(quarter,1,dateadd(quarter,{% parameter period_over_period_offset %},getdate()))))
                          and extract(day from (${created_date} - date_trunc('quarter', ${created_date})))+1 <= extract(day from (getdate() - date_trunc('quarter', getdate())))+1) then ${sale_price} else NULL end) -- need to generate the quarter day, otherwise ewsults from days within future months in the quarter will be included

                      {% elsif period_over_period._parameter_value == "'QoQ-Y'" %}

                      sum(case when (extract(quarter from ${created_date}) = extract(quarter from dateadd(quarter,{% parameter period_over_period_offset %},getdate()))
                      and extract(month from ${created_date}) <= extract(month from dateadd(quarter,{% parameter period_over_period_offset %},getdate()))
                      and extract(day from (${created_date} - date_trunc('quarter', ${created_date})))+1 <= extract(day from (getdate() - date_trunc('quarter', getdate())))+1) then ${sale_price} else NULL end) -- need to generate the quarter day, otherwise ewsults from days within future months in the quarter will be included


                      {% else %}

                        NULL
                      {% endif %} ;;

    drill_fields: [period_over_period_total_sales]
    link: {
      label: "Explore Total Order Value - Flagship App Vs SPA"
      url: "{% assign vis= '{\"x_axis_gridlines\":false,
      \"y_axis_gridlines\":true,
      \"show_view_names\":false,
      \"show_y_axis_labels\":true,
      \"show_y_axis_ticks\":true,
      \"y_axis_tick_density\":\"default\",
      \"y_axis_tick_density_custom\":5,
      \"show_x_axis_label\":true,
      \"show_x_axis_ticks\":true,
      \"y_axis_scale_mode\":\"linear\",
      \"x_axis_reversed\":false,
      \"y_axis_reversed\":false,
      \"plot_size_by_field\":false,
      \"trellis\":\"\",
      \"stacking\":\"\",
      \"limit_displayed_rows\":false,
      \"legend_position\":\"center\",
      \"point_style\":\"none\",
      \"show_value_labels\":true,
      \"label_density\":25,
      \"x_axis_scale\":\"auto\",
      \"y_axis_combined\":true,
      \"ordering\":\"none\",
      \"show_null_labels\":false,
      \"show_totals_labels\":false,
      \"show_silhouette\":false,
      \"totals_color\":\"#808080\",
      \"series_types\":{},
      \"show_dropoff\":true,
      \"type\":\"looker_column\",
      \"show_null_points\":true,
      \"interpolation\":\"linear\",
      \"defaults_version\":1,
      \"hidden_fields\":null}' %}

      {% assign dynamic_fields= '[]' %}
      {{link  | replace: 'order_items.period_over_period_total_sales', 'order_items.created_date
      ,order_items.period_over_period_total_sales
      ,order_items.order_item_count'}}

      &vis={{vis | encode_uri}}
      &dynamic_fields={{dynamic_fields | encode_uri}}"
    }
  }

  measure: percentile {
    type: percentile
    percentile: 75
    sql: ${sale_price} ;;

  }



  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [id]
  }
}
