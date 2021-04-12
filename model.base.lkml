

# include all the views
include: "*.view"
# include: "*.dashboard"

# datagroup: bb_ramp_case_study_default_datagroup {

explore: test_running_total {}
explore: users_test {
  # fields: [id,age,age_tier,country,city]
  persist_with: dv_datagroup
  sql_always_where: case when {% condition users_test.state_filter %} 'Arizona' {% endcondition %} then 1=1
    else {% condition users_test.state_filter %} state  {% endcondition %} end ;;
}


access_grant: my_access {
  allowed_values: ["New York"]
  user_attribute: state
}
# explore: products {
# #   fields: [products.product_set*]
# #   view_name: products
#   # fields:[products.my_set*]
#   sql_always_where: ${brand} = 'Dockers' ;;
#   }


# explore: my_entended_explore {
#   extends: [users,products]
#   label: "My Extended Explore"
#   join: products {
#     from: products
#     sql_on: ${products.id}=${inventory_items.product_id} ;;
#     relationship: many_to_one
#   }

# }

named_value_format: brendan {
  value_format: "0.000,,\" M\""
}

named_value_format: bb_format {
  value_format: " [>=1000000]0.00,,\"M\";[>=1000]0.00,\"K\";"
}


explore: order_items {





  # access_filter: {
  #   field: users.city
  #   user_attribute:city
  # }

  # access_filter: {
  #   field: users.state
  #   user_attribute: state
  # }

  access_filter: {
    field: products.brand
    user_attribute: brand
  }



  join: order_items_fact {
    # required_access_grants: [my_access]
    type: inner
    sql_on: ${order_items.id}=${order_items_fact.id} ;;
    relationship: one_to_one
    view_label: "Order Items Fact"
    fields: [order_items_fact.id]
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id};;
    relationship: one_to_one
  }
  join: products {
    type: left_outer
    sql_on: ${products.id}=${inventory_items.product_id} ;;
    relationship: many_to_one
  }
  join: distribution_centers {
    type: left_outer
    sql_on: ${distribution_centers.id} = ${products.distribution_center_id} ;;
    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: events {
    type: left_outer
    sql_on: ${events.user_id}=${users.id} ;;
    relationship: one_to_many
  }
#   join: ndt_orders {
#     type: left_outer
#     relationship: many_to_one
#     sql_on: ${ndt_orders.order_id} = ${order_items.order_id} ;;
#   }
  label: "1) Order Items"
  group_label: "SSO Demo"
}

# explore: order_items {}
# explore: products_extended {}

####################################

explore: users {

  persist_for: "0 seconds"

  # always_filter: {
  #   filters: {
  #     field:users.city
  #     value: "Boston"
  #   }
  # }

  view_name: users

  access_filter: {
    field: users.state
    user_attribute:state
  }

  # join: period_over_period {
  #   type:cross
  #   # sql_on:${period_over_period.dummy_dim} = ${users.id};;
  #   relationship: many_to_one

  # }
  # always_join: [period_over_period]

  join: events {

    type: left_outer
    sql_on: ${users.id} = ${events.user_id} ;;
    relationship: one_to_many
  }
  join: order_items {
    type: left_outer
    sql_on: ${users.id}= ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: order_items_fact {
    type: inner
    sql_on: ${order_items.id}=${order_items_fact.id} ;;
    relationship: one_to_one
  }
  join: inventory_items {
#     view_label: "Users" -- Relable
  type: left_outer
  sql_on: ${order_items.inventory_item_id}=${inventory_items.id} ;;
  relationship: one_to_one
#     fields: [inventory_items.cost, inventory_items.average_cost] -- bring in fields needed
}
label: "2) Customers"
group_label: "SSO Demo"
}


####################################
# Place in `model1` model
# explore: +customer_behaviour_fact {
#   aggregate_table: rollup__products_brand {
#     query: {
#       dimensions: [products.brand]
#       measures: [order_items.total_sales]
#       filters: [products.brand]
#       timezone: "America/Los_Angeles"
#     }

#     materialization: {
#       persist_for: "24 hours"
#     }
#   }
# }


explore: customer_behaviour_fact {
  label: "3) Customer Behaviour"
  group_label: "SSO Demo"


  join: order_items {
    type: left_outer
    sql_on: ${customer_behaviour_fact.user_id}=${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: inventory_items {
    type: inner
    sql_on: ${inventory_items.id}=${order_items.inventory_item_id};;
    relationship: one_to_one
  }
  join: products {
    type: left_outer
    sql_on: ${products.id}=${inventory_items.product_id} ;;
    relationship: many_to_one
  }
}


explore: inventory_items {
  view_name: inventory_items
  label: "Inventory Raw"

  join: products {
    type: left_outer
    sql_on: ${products.id}=${inventory_items.product_id} ;;
    relationship: many_to_one
  }
  }

explore: distribution_centers {
  view_name: distribution_centers
  label: "Distribution Raw"

  join: products {
    type: left_outer
    sql_on: ${products.id}=${distribution_centers.id} ;;
    relationship: many_to_one
  }
}
