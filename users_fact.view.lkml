view: users_fact {
  derived_table: {
    sql: select users.id,users.state,
      count(order_items.id) as total_order,
      sum(order_items.sale_price) as total_sales,
      min(order_items.created_at) as first_order,
      max(order_items.created_at) as last_order,
     rank() over (order by total_sales desc) as ranking,
     {{   state_parameter._parameter_value }} as state

from order_items
left outer join users on order_items.user_id = users.id
where case when {% condition state_filter %} 'Arizona' {% endcondition %} then 1=1
        else {% condition state_filter %} users.state  {% endcondition %} end
group by 1,2
order by ranking asc
 ;;
  }

  filter: state_filter {
    type: string
  }
  parameter: state_parameter {
    type: string
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: state {
#     primary_key: yes
  type: string
  sql: ${TABLE}.state ;;
}

dimension: total_order {
  type: number
  sql: ${TABLE}.total_order ;;
}

dimension: total_sales {
  type: number
  sql: ${TABLE}.total_sales ;;
}

dimension_group: first_order {
  type: time
  sql: ${TABLE}.first_order ;;
}

dimension_group: last_order {
  type: time
  sql: ${TABLE}.last_order ;;
}

dimension: ranking {
  type: number
  sql: ${TABLE}.ranking ;;
}

set: detail {
  fields: [
    id,
    total_order,
    total_sales,
    first_order_time,
    last_order_time,
    ranking
  ]
}
}
