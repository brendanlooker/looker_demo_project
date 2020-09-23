- dashboard: customer_behaviour
  title: Customer Behaviour
  layout: newspaper
  embed_style:
    background_color: "#ffffff"
    show_title: true
    title_color: "#3a4245"
    show_filters_bar: true
    tile_text_color: "#3a4245"
    text_tile_text_color: ''
  elements:
  - title: Average Lifetime Spend
    name: Average Lifetime Spend
    model: bb_ramp_case_study
    explore: customer_behaviour_fact
    type: single_value
    fields: [customer_behaviour_fact.average_lifetime_revenue]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    custom_color: ''
    show_single_value_title: true
    single_value_title: Average Lifetime Spend
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    series_types: {}
    row: 0
    col: 9
    width: 8
    height: 2
  - title: Lifetime Revenue Distribution
    name: Lifetime Revenue Distribution
    model: bb_ramp_case_study
    explore: customer_behaviour_fact
    type: looker_bar
    fields: [customer_behaviour_fact.customer_lifetime_revenue_grp, customer_behaviour_fact.count_users]
    sorts: [customer_behaviour_fact.customer_lifetime_revenue_grp]
    limit: 500
    column_limit: 50
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_types: {}
    limit_displayed_rows: false
    y_axes: [{label: User Count, orientation: bottom, series: [{id: customer_behaviour_fact.count_users,
            name: Customer Behaviour Fact Count Users, axisId: customer_behaviour_fact.count_users}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Lifetime Revenue Bucket
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: true
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 2
    col: 0
    width: 24
    height: 5
  - title: Customer by Orders Grouping
    name: Customer by Orders Grouping
    model: bb_ramp_case_study
    explore: customer_behaviour_fact
    type: looker_column
    fields: [customer_behaviour_fact.customer_lifetime_orders_grp, customer_behaviour_fact.count_users,
      order_items.total_gross_revenue, order_items.average_sale_price]
    fill_fields: [customer_behaviour_fact.customer_lifetime_orders_grp]
    sorts: [customer_behaviour_fact.customer_lifetime_orders_grp]
    limit: 500
    total: true
    query_timezone: GMT
    stacking: ''
    trellis: ''
    color_application:
      collection_id: 0a5cba20-3b6e-4739-b9e3-ba1d442d992d
      palette_id: 47126dad-3a99-4cff-926a-a99f3b2eeccc
      options:
        steps: 5
    show_value_labels: true
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: circle_outline
    series_colors:
      order_items.average_sale_price: "#e0d1dc"
      order_items.total_gross_revenue: "#a9c574"
    series_types:
      order_items.total_gross_revenue: line
      order_items.average_sale_price: area
    series_point_styles:
      order_items.total_gross_revenue: diamond
    limit_displayed_rows: false
    hidden_series: []
    y_axes: [{label: Customer Count, orientation: left, series: [{id: customer_behaviour_fact.count_users,
            name: Customer Behaviour Fact Count Users, axisId: customer_behaviour_fact.count_users}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{id: order_items.total_gross_revenue, name: Orders Total Gross Revenue,
            axisId: order_items.total_gross_revenue}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: '', orientation: right, series: [{id: order_items.average_sale_price,
            name: Orders Average Sale Price, axisId: order_items.average_sale_price}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    x_axis_label: Number of Orders
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    reference_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      YearFilter: customer_behaviour_fact.first_order_year
    row: 7
    col: 11
    width: 13
    height: 19
  - title: Revenue Last 30 Days by Customer Groups
    name: Revenue Last 30 Days by Customer Groups
    model: bb_ramp_case_study
    explore: customer_behaviour_fact
    type: looker_column
    fields: [customer_behaviour_fact.customer_lifetime_orders_grp, customer_behaviour_fact.customer_lifetime_revenue,
      customer_behaviour_fact.customer_lifetime_revenue_grp]
    pivots: [customer_behaviour_fact.customer_lifetime_revenue_grp]
    fill_fields: [customer_behaviour_fact.customer_lifetime_revenue_grp, customer_behaviour_fact.customer_lifetime_orders_grp]
    filters:
      customer_behaviour_fact.last_order_month: 30 days
      customer_behaviour_fact.is_active: 'Yes'
    sorts: [customer_behaviour_fact.customer_lifetime_revenue desc 0, customer_behaviour_fact.customer_lifetime_orders_grp,
      customer_behaviour_fact.customer_lifetime_revenue_grp]
    limit: 500
    column_limit: 50
    stacking: ''
    show_value_labels: false
    label_density: 25
    font_size: '12'
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_types: {}
    limit_displayed_rows: false
    hidden_series: [1 Order - $0.00 - $4.99|FIELD|0|FIELD|0 - customer_behaviour_fact.customer_lifetime_revenue,
      1 Order - $50.00 - $99.99|FIELD|0|FIELD|3 - customer_behaviour_fact.customer_lifetime_revenue,
      2 Orders - $5.00 - $19.99|FIELD|1|FIELD|1 - customer_behaviour_fact.customer_lifetime_revenue,
      2 Orders - $100.00 - $499.99|FIELD|1|FIELD|4 - customer_behaviour_fact.customer_lifetime_revenue]
    y_axes: [{label: Revenue, orientation: left, series: [{id: "$0.00 - $4.99 - 0\
              \ - customer_behaviour_fact.customer_lifetime_revenue", name: "$0.00\
              \ - $4.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$5.00 - $19.99 - 1 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$5.00 - $19.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$20.00 - $49.99 - 2 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$20.00 - $49.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$50.00 - $99.99 - 3 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$50.00 - $99.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$100.00 - $499.99 - 4 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$100.00 - $499.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$500.00 - $999.99 - 5 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$500.00 - $999.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$1000.00 + - 6 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$1000.00 +", axisId: customer_behaviour_fact.customer_lifetime_revenue}],
        showLabels: true, showValues: true, valueFormat: "$#,##0", unpinAxis: false,
        tickDensity: default, type: linear}]
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen: {}
    row: 7
    col: 0
    width: 11
    height: 10
  - title: Lifetime Revenue by Customer Groups
    name: Lifetime Revenue by Customer Groups
    model: bb_ramp_case_study
    explore: customer_behaviour_fact
    type: looker_column
    fields: [customer_behaviour_fact.customer_lifetime_orders_grp, customer_behaviour_fact.customer_lifetime_revenue,
      customer_behaviour_fact.customer_lifetime_revenue_grp]
    pivots: [customer_behaviour_fact.customer_lifetime_revenue_grp]
    fill_fields: [customer_behaviour_fact.customer_lifetime_revenue_grp, customer_behaviour_fact.customer_lifetime_orders_grp]
    sorts: [customer_behaviour_fact.customer_lifetime_revenue desc 0, customer_behaviour_fact.customer_lifetime_orders_grp,
      customer_behaviour_fact.customer_lifetime_revenue_grp]
    limit: 500
    column_limit: 50
    stacking: ''
    show_value_labels: false
    label_density: 25
    font_size: '12'
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    point_style: none
    series_types: {}
    limit_displayed_rows: false
    hidden_series: [1 Order - $0.00 - $4.99|FIELD|0|FIELD|0 - customer_behaviour_fact.customer_lifetime_revenue,
      1 Order - $50.00 - $99.99|FIELD|0|FIELD|3 - customer_behaviour_fact.customer_lifetime_revenue,
      2 Orders - $5.00 - $19.99|FIELD|1|FIELD|1 - customer_behaviour_fact.customer_lifetime_revenue,
      2 Orders - $100.00 - $499.99|FIELD|1|FIELD|4 - customer_behaviour_fact.customer_lifetime_revenue]
    y_axes: [{label: Revenue, orientation: left, series: [{id: "$0.00 - $4.99 - 0\
              \ - customer_behaviour_fact.customer_lifetime_revenue", name: "$0.00\
              \ - $4.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$5.00 - $19.99 - 1 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$5.00 - $19.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$20.00 - $49.99 - 2 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$20.00 - $49.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$50.00 - $99.99 - 3 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$50.00 - $99.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$100.00 - $499.99 - 4 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$100.00 - $499.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$500.00 - $999.99 - 5 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$500.00 - $999.99", axisId: customer_behaviour_fact.customer_lifetime_revenue},
          {id: "$1000.00 + - 6 - customer_behaviour_fact.customer_lifetime_revenue",
            name: "$1000.00 +", axisId: customer_behaviour_fact.customer_lifetime_revenue}],
        showLabels: true, showValues: true, valueFormat: "$#,##0", unpinAxis: false,
        tickDensity: default, type: linear}]
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 17
    col: 0
    width: 11
    height: 9
  filters:
  - name: YearFilter
    title: YearFilter
    type: date_filter
    default_value: 3 years ago for 3 years
    allow_multiple_values: true
    required: false
