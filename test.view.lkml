view: test_running_total {
  derived_table: {
    explore_source: order_items {
      column: cumulative_total_sales {}
      column: total_sales {}
      column: created_month {}
      filters: {
        field: order_items.created_month
        value: "6 months"
      }
    }
  }
  dimension: cumulative_total_sales {
    label: "Orders Cumulative Total Sales"
    description: "Cumulative Total Sales"
    value_format: "$#,##0"
    type: number
  }
  dimension: total_sales {
    label: "Orders Total Sales"
    description: "Total Sale Price"
    value_format: "$#,##0"
    type: number
  }
  dimension: created_month {
    label: "Orders Created Month"
    type: date_month
  }
}
