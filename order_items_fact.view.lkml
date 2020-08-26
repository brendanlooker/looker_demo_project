# include: "order_items.view.lkml"
view: order_items_fact {
  derived_table: {
    sql: select order_items.id,
              case when ((order_items.returned_at  IS NULL) AND (order_items.status <> 'Cancelled' OR order_items.status IS NULL)) then order_items.sale_price else 0 End - inventory_items.cost as gross_margin,
              dense_rank() over (partition by user_id order by order_items.created_at asc) as order_sequence,
              nvl(datediff(day,lag(order_items.created_at,1) over (partition by user_id order by order_items.created_at asc),order_items.created_at),0) as days_to_previous_order,
              case when order_sequence = 1 then 0 when days_to_previous_order < 60 then 1 else 0 end as repeat_purchase_within_60_days
              from order_items join inventory_items on order_items.inventory_item_id = inventory_items.id
               ;;
  }
  view_label: "Orders"

#   extends: [order_items]


  dimension: id {
    primary_key:yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence ;;
  }

  dimension: is_first_purchase {
    type: yesno
    sql: ${TABLE}.order_sequence = 1;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql: ${TABLE}.order_sequence > 1;;
  }

  dimension: repeat_purchase_within_60_days {
    type: yesno
    sql: ${TABLE}.repeat_purchase_within_60_days = 1;;
  }

  measure:  count_of_repeat_purchases_within_60_days{
    type: sum
    sql: ${TABLE}.repeat_purchase_within_60_days;;
    description: "Count of Purchases occurring within 60 days of a pervious purchase"
  }


  dimension: days_to_previous_order {
    type: number
    sql:${TABLE}.days_to_previous_order ;;
  }

  measure: average_number_of_days_between_orders {
    type: average
    sql: ${TABLE}.days_to_previous_order ;;
  }

  measure: average_gross_margin {
    type: average
    sql: ${TABLE}.gross_margin ;;
    value_format_name: usd_0
    description: "Average Gross Margin"
  }

  set: detail {
#       fields: [id, average_gross_margin,days_to_previous_order,total_gross_revenue]
  fields: [id,order_sequence]
}
}
