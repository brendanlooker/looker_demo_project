- dashboard: products_dashboard_extended
  title: Products Dashboard Extended
  extends: products_dashboard
  elements:
  - title: Total Sales Month-over-Month
    name: Total Sales Month-over-Month
    listen:
      State: users.state
  filters:
  - name: State
    title: State
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    model: sso_demo
    explore: order_items
    listens_to_filters: []
    field: users.state
