connection: "thelook_events_redshift"

# include all the views
include: "*.view"
include: "product_dash.dashboard.lookml"
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
explore: sleepcycle_demo {
  group_label: "SleepCycle"
  label: "SleepCycle123"
  description: "SleepCycle Description"
  view_label: "SleepCycle Data Points"
}

datagroup: my_data_group {
  max_cache_age: "24 hours"
  sql_trigger: select current_date ;;
}

explore: users_test_1 {}
