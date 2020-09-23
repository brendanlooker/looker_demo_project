view: users_insights {
  derived_table: {
    distribution_style: all
    sql_trigger_value: select current_date ;;
    sql: select order_items.id, order_items.user_id, sum(sale_price) as total_revenue,
      row_number() over (partition by order_items.user_id order by order_items.id asc) as seq_num,
      sum(total_revenue) over (partition by order_items.user_id order by order_items.id asc rows unbounded preceding) as running_total
      from order_items
      group by 1,2
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_revenue {
    type: number
    sql: ${TABLE}.total_revenue ;;
  }

  dimension: seq_num {
    type: number
    sql: ${TABLE}.seq_num ;;
  }

  dimension: running_total {
    type: number
    sql: ${TABLE}.running_total ;;
  }

  set: detail {
    fields: [id, user_id, total_revenue, seq_num, running_total]
  }
}
