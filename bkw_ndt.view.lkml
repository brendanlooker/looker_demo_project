

view: bkw_ndt {
  derived_table: {
    explore_source: order_items {
      column: gross_margin_pct {}
      column: number_of_items_returned {}
      column: period_over_period_total_sales {}
      column: sale_price {}
      column: brand { field: products.brand }
    }
  }
  dimension: gross_margin_pct {
    label: "Orders Gross Margin Pct"
    description: "Gross Margin Percentage - Total Gross Margin devided by Total Revenue"
    value_format: "#,##0.00%"
    type: number
  }
  dimension: number_of_items_returned {
    label: "Orders Number of Items Returned"
    description: "Number of Items Returned"
    type: number
  }
  dimension: period_over_period_total_sales {
    label: "Orders Period Over Period Total Sales"
    description: "Total Sales for the defined period"
    value_format: "$#,##0"
    type: number
  }
  dimension: sale_price {
    label: "Orders Sale Price"
    value_format: "$#,##0.00"
    type: number
  }
  dimension: brand {}
}
