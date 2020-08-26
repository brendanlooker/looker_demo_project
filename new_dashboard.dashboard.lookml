- dashboard: advanced_insights
  title: Advanced Insights
  layout: newspaper
  elements:
  - name: Sales by Brand
    title: Sales by Brand
    model: cheetah
    explore: order_items
    type: looker_line
    fields: [order_items.created_month_name, order_items.total_sales, products.brand]
    pivots: [products.brand]
    fill_fields: [order_items.created_month_name]
    filters:
      order_items.created_year: 2 years ago for 2 years
      products.brand: "{{ _user_attributes['brand'] }}"
    sorts: [products.brand 0, order_items.created_month_name]
    limit: 500
    query_timezone: America/Los_Angeles
    stacking: ''
    trellis: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: circle_outline
    series_types: {}
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    show_null_points: true
    interpolation: linear
    row: 4
    col: 1
    width: 11
    height: 12
  - name: Sales and Users by State
    title: Sales and Users by State
    model: cheetah
    explore: order_items
    type: looker_column
    fields: [users.state, users.user_count, order_items.total_sales]
    filters:
      order_items.created_year: 1 years ago for 1 years
    sorts: [order_items.total_sales desc]
    limit: 10
    query_timezone: America/Los_Angeles
    stacking: ''
    trellis: ''
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: 4a543302-b64d-409c-9863-679b5b230aac
      options:
        steps: 5
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_colors:
      order_items.total_gross_margin: "#ff9c60"
    series_types:
      users.user_count: line
    limit_displayed_rows: false
    hidden_series: []
    y_axes: [{label: '', orientation: left, series: [{id: order_items.total_sales,
            name: Total Sales, axisId: order_items.total_sales}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: !!null '', orientation: right, series: [{id: users.user_count, name: User
              Count, axisId: users.user_count}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
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
    row: 4
    col: 12
    width: 11
    height: 12
  - name: User Signups Last Month
    title: User Signups Last Month
    model: cheetah
    explore: order_items
    type: single_value
    fields: [users.created_month, users.user_count]
    fill_fields: [users.created_month]
    filters:
      users.created_month: 2 months ago for 2 months
    sorts: [users.created_month desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: previous_month, label: Previous Month, expression: "(${users.user_count}-offset(${users.user_count},1))/offset(${users.user_count},1)",
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    custom_color_enabled: true
    custom_color: ''
    show_single_value_title: true
    single_value_title: User Signups Last Month
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    row: 0
    col: 7
    width: 10
    height: 4
