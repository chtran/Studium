Given /^$(.*) should be in the user list$/ do |name|
  user_list = page.find("#user_list")
  asser user_list.has_content(name)
end
