include: "users_extd.view.lkml"
view: customer_behaviour {
  extends: [users_extd]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  measure: customer_lifetime_orders {
    hidden: yes
    type: count_distinct
    sql: ${order_items.order_id} ;;
  }

#   measure: customer_lifetime_orders_grp {
#     type: string
#     case:{
#       when: {
#         sql: ${customer_lifetime_orders}=1;;
#         label: "1 Order"
#       }
#       when: {
#         sql:${customer_lifetime_orders}=2 ;;
#         label: "2 Orders"
#       }
#       when: {
#         sql:${customer_lifetime_orders} between 3 and 5 ;;
#         label: "3 - 5 Orders"
#       }
#       when: {
#         sql:${customer_lifetime_orders} between 6 and 9;;
#         label: "6 - 9 Orders"
#       }
#       when: {
#         sql:${customer_lifetime_orders} > 10;;
#         label: "10+ Orders"
#       }
#     }
#   }

  measure: customer_lifetime_revenue {
    hidden: yes
    type: number
    sql: ${order_items.total_gross_revenue} ;;
    value_format_name: usd_0
  }

#   measure: customer_lifetime_revenue_grp {
#     type: string
#     case: {
#       when: {
#         sql: ${customer_lifetime_revenue} between 0 and 4;;
#         label: "$0.00 - $4.99"
#       }
#       when: {
#         sql: ${customer_lifetime_revenue} between 5 and 19;;
#         label: "$5.00 - $19.99"
#       }
#       when: {
#         sql: ${customer_lifetime_revenue} between 20 and 40;;
#         label: "$20.00 - $49.99"
#       }
#       when: {
#         sql: ${customer_lifetime_revenue} between 50 and 99;;
#         label: "$50.00 - $99.99"
#       }
#       when: {
#         sql: ${customer_lifetime_revenue} between 100 and 499;;
#         label: "$100.00 - $499.99"
#       }
#       when: {
#         sql: ${customer_lifetime_revenue} between 500 and 999;;
#         label: "$500.00 - $999.99"
#       }
#       when: {
#         sql: ${customer_lifetime_revenue}>= 1000;;
#         label: "$1000.00 +"
#       }
#     }
#   }


}
