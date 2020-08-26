include: "customer_behaviour.view.lkml"
view: customer_behaviour_fact {
  derived_table: {
    sql: select users.id as user_id,
        count(distinct order_items.order_id) as number_of_orders,
        sum(order_items.sale_price) as total_revenue,
        min(order_items.created_at) as first_order,
        max(order_items.created_at) as last_order,
        datediff(day, last_order, getdate()) as days_since_last_order
from order_items
left outer join users on order_items.user_id = users.id
left outer join inventory_items on order_items.inventory_item_id = inventory_items.id
left outer join products on inventory_items.product_id = products.id
group by 1
 ;;
  }
#   extends: [customer_behaviour]


  dimension: id {
    type: number
    sql: ${TABLE}.user_id ;;
    primary_key: yes
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
#     primary_key: yes
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order ;;
    timeframes: [date,day_of_month,day_of_week,month,quarter,year]
  }

  dimension_group: last_order {
    type: time
    sql: ${TABLE}.last_order ;;
    timeframes: [date,day_of_month,day_of_week,month,quarter,year]
  }

  dimension: days_since_last_order {
    type: number
    sql: ${TABLE}.days_since_last_order ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${days_since_last_order} < 90 ;;
  }

  dimension: is_repeat_customer {
    type: yesno
    sql: ${TABLE}.number_of_orders > 1 ;;
  }

  measure: count_users {
    type: count
    drill_fields: [detail*]
  }

  measure: customer_lifetime_orders {
    type: sum
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: customer_lifetime_orders_grp {
    type: string
    case:{
      when: {
        sql: ${TABLE}.number_of_orders=1;;
        label: "1 Order"
      }
      when: {
        sql:${TABLE}.number_of_orders=2 ;;
        label: "2 Orders"
      }
      when: {
        sql:${TABLE}.number_of_orders between 3 and 5;;
        label: "3 - 5 Orders"
      }
      when: {
        sql:${TABLE}.number_of_orders between 6 and 9;;
        label: "6 - 9 Orders"
      }
      when: {
        sql:${TABLE}.number_of_orders >= 10;;
        label: "10+ Orders"
      }
    }
  }

  measure: customer_lifetime_revenue {
    type: sum
    sql: ${TABLE}.total_revenue ;;
    value_format_name: usd_0
    drill_fields: [detail*]
  }

  dimension: customer_lifetime_revenue_grp {
    type: string
    case: {
      when: {
        sql: ${TABLE}.total_revenue >=0 and  ${TABLE}.total_revenue < 5;;
        label: "$0.00 - $4.99"
      }
      when: {
        sql: ${TABLE}.total_revenue >= 5 and ${TABLE}.total_revenue <20;;
        label: "$5.00 - $19.99"
      }
      when: {
        sql: ${TABLE}.total_revenue >= 20.0 and ${TABLE}.total_revenue < 50;;
        label: "$20.00 - $49.99"
      }
      when: {
        sql: ${TABLE}.total_revenue >= 50.0 and ${TABLE}.total_revenue < 100;;
        label: "$50.00 - $99.99"
      }
      when: {
        sql: ${TABLE}.total_revenue >=100 and ${TABLE}.total_revenue < 500;;
        label: "$100.00 - $499.99"
      }
      when: {
        sql: ${TABLE}.total_revenue >= 500 and ${TABLE}.total_revenue < 1000;;
        label: "$500.00 - $999.99"
      }
      when: {
        sql: ${TABLE}.total_revenue>= 1000;;
        label: "$1000.00 +"
      }
    }
  }

  measure: average_number_of_orders {
    type: average
    sql: ${TABLE}.number_of_orders ;;
  }

  measure: average_lifetime_revenue {
    type: average
    sql: ${TABLE}.total_revenue ;;
    value_format_name: usd_0
  }

  measure: average_days_since_last_order {
    type: average
    sql: ${TABLE}.days_since_last_order ;;
    value_format_name: decimal_0
    drill_fields: [user_id,is_repeat_customer, first_order_date, days_since_last_order]
  }

  set: detail {
    fields: [
      user_id,
      customer_lifetime_orders,
      customer_lifetime_revenue,
      first_order_date,
      last_order_date,
      days_since_last_order
    ]
  }
}
