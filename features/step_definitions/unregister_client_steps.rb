When /^I should see a current client hostname link$/ do
  fail if not find_link(debrand_string(get_client_hostname)).visible?
end

When /^I follow current client hostname$/ do
  And "I follow \"#{get_client_hostname}\""
end
