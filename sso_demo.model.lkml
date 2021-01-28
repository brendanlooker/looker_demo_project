connection: "snowlooker"

# include all the views
include: "*.view"
include: "*products_dashboard.dashboard"
include: "*products_dashboard_extended.dashboard"
# include: "brendan_dashboard.dashboard"
# include: "performance_dash.dashboard"
include: "conditional_formatting_dash.dashboard"
include: "model.base.lkml"

explore: users_fact {}


# explore: +inventory_items {
#   # view_name: inventory_items

#   label: "Refined Explore *****"

#   join: products {
#     type: left_outer
#     sql_on: ${products.id}=${inventory_items.product_id} ;;
#     relationship: many_to_one
#   }
# }


explore: inventory_items_extd {

  extends: [inventory_items,distribution_centers]

  view_name: inventory_items

  label: "Refined Explore *****"

  join: products {
    type: left_outer
    sql_on: ${products.id}=${inventory_items.product_id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.id}=${distribution_centers.id} ;;
    relationship: many_to_one

  }
}





named_value_format: bb {
  value_format: "[>=1000000]\"\"0.00,,\" M\";[<=-1000000]\"\"-0.00,,\" M\";[>=1000]\"\"0.00,\" K\";\"\"0.00"
}


datagroup: dv_datagroup {
  max_cache_age: "12 hours"
#   sql_trigger:select current_date;;
}

####################
