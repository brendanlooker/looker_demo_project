connection: "thelook_events_redshift"

# include all the views
include: "test.lkml"
include: "*.view"
# include: "product_dash.dashboard.lookml"
include: "model.base.lkml"

explore: events {
  group_label: "Events Brendan Test2"
  label: "Events Brendan Test2"
}

explore: customer_behaviour_fact_bla {
  from:  customer_behaviour_fact
  group_label: "Events Brendan Test2"
  label: "customer_behaviour_fact"
}

datagroup: my_data_group {
  max_cache_age: "24 hours"
  sql_trigger: select current_date ;;
}

explore: users_test_1 {}

explore: users_insights {}

datagroup: dv_datagroup {
  max_cache_age: "12 hours"
#   sql_trigger:select current_date;;
}

###############################################
###############################################


explore: +order_items {
  aggregate_table: rollup__users_email {
    query: {
      dimensions: [
        # "products.brand" is automatically filtered on in an access_filter.
        # Uncomment to allow all possible filters to work with aggregate awareness.
        # products.brand,
        # "users.state" is automatically filtered on in an access_filter.
        # Uncomment to allow all possible filters to work with aggregate awareness.
        # users.state,
        users.email
      ]
      measures: [percentile, total_sales]
      filters: [
        # "products.brand" is automatically filtered on in an access_filter in this query.
        # Remove this filter to allow all possible filters to work with aggregate awareness.
        products.brand: "%",
        # "users.state" is automatically filtered on in an access_filter in this query.
        # Remove this filter to allow all possible filters to work with aggregate awareness.
        users.state: "%"
      ]
      timezone: "America/Los_Angeles"
    }

    materialization: {
      persist_for: "24 hours"
    }
  }
}
