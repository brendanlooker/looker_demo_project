view: ranking_google_analytics {
  derived_table: {
    sql: select  country_group.country_group,
        country_group.country_group_rank,
        country.country,
        country.country_rank,
        city.city,
        city.city_rank,
        city.session_count

from

(SELECT

            country_grouping.{% parameter country_grouping %} as country_group,
            google_analytics_daily.country  AS country,
            google_analytics_daily.city  AS city,
            COALESCE(SUM(google_analytics_daily.sessions), 0) AS session_count,
            {% if ranking_google_analytics.country._in_query %}
            row_number() OVER (PARTITION BY google_analytics_daily.country ORDER BY session_count DESC) AS city_rank
            {% else %}
            row_number() OVER (ORDER BY session_count DESC) AS city_rank
            {% endif %}
        FROM public.google_analytics_daily  AS google_analytics_daily
              LEFT JOIN public.country_grouping  AS country_grouping
            ON google_analytics_daily.country = country_grouping.country
        WHERE ({% condition rank_date_filter %} google_analytics_daily.date {% endcondition %} )
        GROUP BY 1,2,3) city


left outer join

(SELECT
            google_analytics_daily.country  AS country,
            COALESCE(SUM(google_analytics_daily.sessions), 0) AS session_count,
            row_number() OVER (ORDER BY session_count DESC) AS country_rank
        FROM public.google_analytics_daily  AS google_analytics_daily
              LEFT JOIN public.country_grouping  AS country_grouping
            ON google_analytics_daily.country = country_grouping.country
        WHERE ({% condition rank_date_filter %} google_analytics_daily.date {% endcondition %} )
        GROUP BY 1) country

on city.country = country.country

left outer join

(SELECT
            country_grouping.{% parameter country_grouping %} as country_group,
            COALESCE(SUM(google_analytics_daily.sessions), 0) AS session_count,
            row_number() OVER (ORDER BY session_count DESC) AS country_group_rank
        FROM public.google_analytics_daily  AS google_analytics_daily
              LEFT JOIN public.country_grouping  AS country_grouping
            ON google_analytics_daily.country = country_grouping.country
        WHERE ({% condition rank_date_filter %} google_analytics_daily.date {% endcondition %} )
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

  dimension: sessions {
    hidden: yes
    type: number
    sql: ${TABLE}.session_count ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  measure: total_sessions {
    type: sum
    sql: ${sessions} ;;
  }

  set: detail {
    fields: [
      country_group,
      country_group_rank,
      country,
      country_rank,
      city,
      city_rank,
      sessions
    ]
  }
}
