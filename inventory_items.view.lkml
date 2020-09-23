view: inventory_items {
  sql_table_name: public.inventory_items ;;

  dimension: id {
    label: "Inventory Id"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    view_label: "Products"
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
  }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
  }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
  }

  dimension: product_distribution_center_id {
    type: number
    sql: ${TABLE}.product_distribution_center_id ;;
  }

  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}.product_retail_price ;;
  }

  dimension: product_sku {
    type: string
    sql: ${TABLE}.product_sku ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }
  parameter: currency_selector {
    type: unquoted
    default_value: "usd"
    allowed_value: {
      label: "GBP"
      value: "gbp"
    }

    allowed_value: {
      label: "EUR"
      value: "eur"
    }

    allowed_value: {
      label: "USD"
      value: "usd"
    }
  }


  measure: total_cost {
    type: sum
    sql: ${cost} ;;
    description: "Total Cost"
    value_format_name: decimal_0
    html:
    {% if currency_selector._parameter_value == 'usd' %}
    ${{rendered_value}}
    {% elsif currency_selector._parameter_value == 'eur' %}
    €{{rendered_value}}
    {% elsif currency_selector._parameter_value == 'gbp' %}
    £{{rendered_value}}
    {% else %}
    X{{rendered_value}}
    {% endif %}
    ;;
  }

  measure: average_cost {
    type: average
    sql: ${cost} ;;
    description: "Average Cost"
    value_format_name: usd
  }

  measure: total_items_sold {
    type: count_distinct
    sql: ${id} ;;
    description: "Total Items Sold"

  }

  measure: inventory_item_count {
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }
}
