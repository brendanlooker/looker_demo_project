view: ranking_v2 {
  derived_table: {
    sql: select  country_group.country_group,
        country_group.country_group_rank,
        country.country, country.country_rank,
        city.city,
        city.city_rank,
        city.gross_sales_after_discount,
        city.orders

from

(SELECT

            country_grouping.{% parameter country_grouping %} as country_group,
            shopify_orders_shipping_address.country  AS shipping_country,
            city_mapping."city standardised"  AS city,
            COALESCE(SUM(shopify_orders_line_items.price), 0) AS gross_sales_after_discount,
            COALESCE(COUNT(shopify_orders.id), 0) AS orders,
            {% if ranking_v2.country._in_query %}
                {% if ranking_v2.total_gross_sales_after_discount._in_query %}
                    row_number() OVER (PARTITION BY shipping_country ORDER BY gross_sales_after_discount DESC) AS city_rank
                {% else %}
                    row_number() OVER (PARTITION BY shipping_country ORDER BY orders DESC) AS city_rank
                {% endif %}
            {% else %}
                {% if ranking_v2.total_gross_sales_after_discount._in_query %}
                    row_number() OVER (ORDER BY gross_sales_after_discount DESC) AS city_rank
                {% else %}
                    row_number() OVER (ORDER BY orders DESC) AS city_rank
                {% endif %}
            {% endif %}
        FROM public.shopify_orders  AS shopify_orders
              LEFT JOIN public.shopify_orders_line_items AS shopify_orders_line_items
              ON shopify_orders_line_items.shopify_orders_id = shopify_orders.id
              LEFT JOIN public.shopify_orders_shipping_address AS shopify_orders_shipping_address
              ON shopify_orders.id = shopify_orders_shipping_address.id
              LEFT JOIN public.country_grouping  AS country_grouping
            ON shopify_orders_shipping_address.country = country_grouping.country
              LEFT JOIN city_mapping on shopify_orders_shipping_address.city = city_mapping.id
        WHERE ({% condition rank_date_filter %} shopify_orders.created_at {% endcondition %} )
        GROUP BY 1,2,3) city


left outer join

(SELECT
            shopify_orders_shipping_address.country  AS country,
            COALESCE(SUM(shopify_orders_line_items.price), 0) AS total_gross_sales_after_discount_country,
            COALESCE(COUNT(shopify_orders.id), 0) AS orders_country,
            {% if ranking_v2.total_gross_sales_after_discount._in_query %}
              row_number() OVER (ORDER BY total_gross_sales_after_discount_country DESC) AS country_rank
            {% else %}
              row_number() OVER (ORDER BY orders_country DESC) AS country_rank
            {% endif %}
        FROM public.shopify_orders  AS shopify_orders
              LEFT JOIN public.shopify_orders_line_items AS shopify_orders_line_items
              ON shopify_orders_line_items.shopify_orders_id = shopify_orders.id
              LEFT JOIN public.shopify_orders_shipping_address AS shopify_orders_shipping_address
              ON shopify_orders.id = shopify_orders_shipping_address.id
              LEFT JOIN public.country_grouping  AS country_grouping
            ON shopify_orders_shipping_address.country = country_grouping.country
        WHERE ({% condition rank_date_filter %} shopify_orders.created_at {% endcondition %} )
        GROUP BY 1) country

on city.shipping_country = country.country

left outer join

(SELECT
            country_grouping.{% parameter country_grouping %} as country_group,
            COALESCE(SUM(shopify_orders_line_items.price), 0) AS total_gross_sales_after_discount,
            COALESCE(COUNT(shopify_orders.id), 0) AS orders_country_group,
            {% if ranking_v2.total_gross_sales_after_discount._in_query %}
              row_number() OVER (ORDER BY total_gross_sales_after_discount DESC) AS country_group_rank
            {% else %}
              row_number() OVER (ORDER BY orders_country_group DESC) AS country_group_rank
            {% endif %}
        FROM public.shopify_orders  AS shopify_orders
              LEFT JOIN public.shopify_orders_line_items AS shopify_orders_line_items
              ON shopify_orders_line_items.shopify_orders_id = shopify_orders.id
              LEFT JOIN public.shopify_orders_shipping_address AS shopify_orders_shipping_address
              ON shopify_orders.id = shopify_orders_shipping_address.id
              LEFT JOIN public.country_grouping  AS country_grouping
            ON shopify_orders_shipping_address.country = country_grouping.country
        WHERE ({% condition rank_date_filter %} shopify_orders.created_at {% endcondition %} )
        GROUP BY 1) country_group

on city.country_group = country_group.country_group

where {% condition country_group_rank_filter %} country_group_rank {% endcondition %}
and {% condition country_rank_filter %} country_rank {% endcondition %}
and {% condition city_rank_filter %} city_rank {% endcondition %}
 ;;
  }

  filter: rank_date_filter{
    type: date
  }

  filter: city_rank_filter {
    label: "City Rank"
    description: "Contains a list of City Ranking Values"
    type: number
  }

  filter: country_rank_filter {
    label: "Country Rank"
    description: "Contains a list of Country Ranking Values"
    type: number
  }

  filter: country_group_rank_filter {
    label: "Country Group Rank"
    description: "Contains a list of Country Group Ranking Values"
    type: number
  }

  parameter: country_grouping {
    type: unquoted
    default_value: "grouping_type_1"
    allowed_value: {
      label: "Country Grouping 1"
      value: "grouping_type_1"
    }
    allowed_value: {
      label: "Country Grouping 2"
      value: "grouping_type_2"
    }
    allowed_value: {
      label: "Country Grouping 3"
      value: "grouping_type_3"
    }

    allowed_value: {
      label: "Country Grouping 4"
      value: "grouping_type_4"
    }
  }

  dimension: ranking_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${country}||${city}  ;;
  }

  dimension: country_group {
    type: string
    sql: ${TABLE}.country_group ;;
  }

  dimension: country_group_rank {
    type: number
    sql: ${TABLE}.country_group_rank ;;
  }

  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: country_rank {
    type: number
    sql: ${TABLE}.country_rank ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: city_rank {
    type: number
    sql: ${TABLE}.city_rank ;;
  }

  dimension: gross_sales_after_discount {
    hidden: yes
    type: number
    sql: ${TABLE}.gross_sales_after_discount ;;
  }

  dimension: orders {
    hidden: yes
    type: number
    sql: ${TABLE}.orders ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  measure: total_gross_sales_after_discount {
    type: sum
    sql: ${gross_sales_after_discount} ;;
  }


  measure: total_orders {
    type: sum
    sql: ${orders} ;;
  }

  set: detail {
    fields: [
      country_group,
      country_group_rank,
      country,
      country_rank,
      city,
      city_rank,
      total_gross_sales_after_discount
    ]
  }
}
