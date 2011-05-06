# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

When /^I refresh the metadata$/ do
  print "Check RHN Network... "
  client_rhn_check
  puts "Done"

  print "Refreshing metadata... "
  client_refresh_metadata
  puts "Done"
end


Then /^I should have "([^"]*)" in the metadata$/ do |text|
   arch=`uname -m`
   arch.chomp!
   if arch != "x86_64"
     arch = "i586"
   end
   `zgrep #{text} #{client_raw_repodata_dir("sles11-sp1-updates-#{arch}-channel")}/primary.xml.gz`
   fail if ! $?.success?
end

