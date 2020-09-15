view: code_samples {

# Dynamic value format
#  [>=1000000]0.00,,\"M\";[>=1000]0.00,\"K\";


# Formatting single value viz outputs
# e-bot7


  dimension: dash_title {
    sql:  {% if _user_attributes['locale']  == 'en' %} 'MAIN STATS - OVER TIME'
          {% else  %} 'HAUPTZUSTÄNDE - IM LAUFE DER ZEIT'
          {% endif %};;
    html: <div class="vis">
          <div class="vis-single-value" style="background-color: #d6d6d6">
          <p style="color: #707070; font-size: 30px; font-weight: bolder"> {{ rendered_value }} </p>
          </div>
          </div>
          ;;
  }

  # html: <p style="color: black; font-size: 100px; font-weight: bolder"> {{ rendered_value }} </p> ;;

  # html:
  # <span style="font-size: 14px">{{rendered_value}}</span>
  # {% if item_return_rate._value > 0 %}
  # <span style="color: green"> ▴ {{ item_return_rate._rendered_value }}</span>
  # {% elsif item_return_rate._value < 0 %}
  # <span style="color: tomato"> ▾ {{ item_return_rate._rendered_value }}</span>
  # {% else %}
  # <span style="color: tomato"> ▾ {{ item_return_rate._rendered_value }}</span>
  # {% endif %};;





  #### Liquid #######


  # Using liquid to dynamically enable drill paths based on dashboard filters
  # e-bot7 / eShopWorld

  measure: count_messages {
    label: "All Messages"
    type: count_distinct
    sql: 1 ;;
    link: {
      label: "{% if _filters['message_categories.category_name'] == '' %} {% else %} View messages by category {% endif %}"
      url: "https://looker.production.e-bot7.de/dashboards/11?Bot={{_filters['bots.botname'] | url_encode }}&Status={{_filters['convs.statusFirstMessage'] | url_encode }}&Date={{_filters['convs.createdAt_date'] | url_encode }}&Chat%20Origin={{_filters['convs.chatOrigin'] | url_encode }}&Chats%20with%20Visitor%20Interaction={{_filters['convs.hasVisitorInteraction'] | url_encode }}"
    }
    link: {
      label: "View dashboards for links"
      url: "https://looker.production.e-bot7.de/dashboards/8?Bot={{_filters['bots.botname'] | url_encode }}&Status={{_filters['convs.statusFirstMessage'] | url_encode }}&Date={{_filters['convs.createdAt_date'] | url_encode }}&Chat%20Origin={{_filters['convs.chatOrigin'] | url_encode }}&Chats%20with%20Visitor%20Interaction={{_filters['convs.hasVisitorInteraction'] | url_encode }}"
    }
  }



  # Using liquid to dynamically enable drill paths based on the value of annother measure
  # e-bot7


  measure: count_chats {
    label: "All Chats"
    type: count_distinct
    link: {
      label: "{% if conv_categories.count_categories._rendered_value == '0' %} {% else %} View chats by category {% endif %}"
      url: "https://looker.production.e-bot7.de/dashboards/12?Bot={{_filters['bots.botname'] | url_encode }}&Status={{_filters['convs.statusFirstMessage'] | url_encode }}&Date={{_filters['convs.createdAt_date'] | url_encode }}&Chat%20Origin={{_filters['convs.chatOrigin'] | url_encode }}&Chats%20with%20Visitor%20Interaction={{_filters['convs.hasVisitorInteraction'] | url_encode }}"
      }
    sql:  1 ;;
    }
  }



  ################################################

  # Beryl


view: availability_snapshot {
  derived_table: {
    sql:
      with generated_timestamp_seq as (
      select * from
      -- UNNEST(GENERATE_TIMESTAMP_ARRAY({% date_start date_range %}, {% date_end date_range %},  #### Funny results being returned - Need to investigate
      UNNEST(GENERATE_TIMESTAMP_ARRAY('2019-07-04 00:00:00', current_timestamp,
                                      INTERVAL 1 {% parameter availability_period %})) as timestamp
      cross join (select distinct bike.module_id from master.availability join master.bike on availability.module_id = bike.module_id)
      )
      -- Build a table for all Bikes (module_id) for all datetime periods
      -- Time period (i.e. day / hour / minute ) is set using the availability_period parameter and iniected into the SQL using liquid


      -- Because a status will only exist for the timestamp period when the status was generated, we need to fill the missing status values for all other timestamps
      -- Join the generated timestamp to master.availability and fill missing status values by using the first_value window function
      select  timestamp,
              status_fill as status,
              scheme.name as scheme,
              count(*) as count
      from (
        select  timestamp,
              generated_timestamp_seq.module_id as seq_module_id,
              availability.*,
              first_value(status IGNORE NULLS) over (partition by generated_timestamp_seq.module_id order by timestamp desc ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) as status_fill
        from generated_timestamp_seq
        left join master.availability
          on generated_timestamp_seq.timestamp = timestamp_trunc(availability.created_at,{% parameter availability_period %})
          and generated_timestamp_seq.module_id = availability.module_id
        )
      join master.bike on seq_module_id = bike.module_id
      join master.scheme on bike.scheme_id = scheme.id
      where status_fill is not null
      group by 1,2,3
       ;;
  }}

 #### Date concat & html rendering

# Aifora

  # dimension: period_date {
  #   type: string
  #   sql:  concat (cast({% date_start transaction_date %} as string),' , ', cast({% date_end transaction_date %} as string));;
  #   html: Zeitraum <br> {{ rendered_value | split: "," | first | date: "%m/%Y" }} - {{ rendered_value | split: "," | last | date: "%m/%Y" }};;
  # }

  # Final Veersion

  # dimension: period_date {
  #   type: string
  #   sql:  concat (cast({% date_start transaction_date %} as string),' , ', cast({% date_end transaction_date %} as string));;
  #   html: <div class="vis">
  #         <div class="vis-single-value" style="background-color: #d6d6d6">
  #         <p style="color: #707070; font-size: 20px; font-weight: bolder">
  #         Zeitraum <br> {{ rendered_value | split: "," | first | date: "%m/%Y" }} - {{ rendered_value | split: "," | last | date: "%m/%Y" }}
  #         </p>
  #         </div>
  #         </div>;;
  # }




  # dimension: brand {
  #   label: "brand"
  #   skip_drill_filter: yes
  #   tags: ["brand"]
  #   type: string
  #   sql: ${TABLE}.brand ;;

  # ############### DRILL TO A GOOGLE SEARCH, PASSING IN THE VALUE CLICKED ON AS A FILTER (if appropriate)

  #   link: {
  #     label: "Google {{ value }}"
  #     url: "http://www.google.com/search?q={{ value | url_encode }}"
  #     icon_url: "http://google.com/favicon.ico"
  #   }

  #   ############### DRILL TO A Dashboard, PASSING IN THE VALUE CLICKED ON AS A FILTER (if appropriate)

  #   link: {
  #     label: "Drill to Product Dashboard"
  #     url: "/dashboards/21?Brand={{ value }}&Category={{ _filters['products.category'] | url_encode }}"
  #     icon_url: "https://looker.com/favicon.ico"
  #   }

  #   ############### DRILL TO A LOOK, PASSING IN THE VALUE CLICKED ON AS A FILTER (if appropriate)

  #   link: {
  #     label: "Drill to Product Look"
  #     url: "/looks/44??&f[products.brand]={{ value | url_encode }}" # Path to Look content
  #     icon_url: "https://looker.com/favicon.ico"
  #   }

  #   ############### DRILL TO AN EXPLORE, SPECIFYING THE FIELDS & FILTERS TO BE PRE-POPULATED (if necessary)

  #   link: {
  #     label: "Drill to Product Explore"
  #     url: "/explore/sso_demo/order_items?fields=products.brand,products.category,products.cost,products.department,products.distribution_center_id,products.product_count&limit=100"
  #     icon_url: "https://looker.com/favicon.ico"
  #   }


  #   drill_fields: [department,category, name, inventory_items.id]
  # }


