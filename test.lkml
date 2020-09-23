test: test_there_are_users {
  explore_source: users {
    column: user_count {}
  }
  assert: there_is_data {
    expression: ${users.user_count} > 0 ;;
  }
}
