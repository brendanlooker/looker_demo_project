  # include: "sso_demo.model.lkml"
  include: "users.view.lkml"

  view: users_extd {

    extends: [users]


    derived_table: {
      explore_source: order_items {
        column: count_of_repeat_purchases_within_60_days { field: order_items_fact.count_of_repeat_purchases_within_60_days }
        column: id { field: users.id }
      }
    }
    dimension: count_of_repeat_purchases_within_60_days {
      hidden: yes
      label: "Orders 60 Day Repeat Purchase Count"
      description: "Count of Purchases occurring within 60 days of a pervious purchase"
    }

    measure: sum_60_day_repeat_purchase {
      hidden: yes
      type: sum
      sql: ${count_of_repeat_purchases_within_60_days} ;;
    }

    measure: is_60_day_repeat_purchase_user {
      type: yesno
      sql: ${sum_60_day_repeat_purchase} > 0 ;;
    }

    dimension: id {
      type: number
    }
  }
