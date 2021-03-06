# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

Given /^I am not authorized$/ do
  visit Capybara.app_host
  fail if not find_button('Sign In').visible?
end

When /^I go to the home page$/ do
  visit Capybara.app_host
end

Given /^I access the host the first time$/ do
  visit Capybara.app_host
  #fail if not page.has_content?("Create Spacewalk Administrator")
  fail if not page.has_content?("Create SUSE Manager Administrator")
end

Then /^no link should be broken$/ do
#  require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "collect"))
  Capybara.default_wait_time = 1
  visit Capybara.app_host

  relation = Hash.new

  hrefs = collect_all_hrefs
  hrefs.each() do |url|
      relation[url.to_s] = "/"
  end

  visited = Hash.new
  failed_other_reason = Array.new


  loop do
    href = hrefs.shift
    next if href.nil?
    base = href.split("?")[0]
    $stderr.puts "Visiting '#{href}' '#{base}', #{hrefs.size} to go, found at '#{relation[href.to_s]}'"
    visit href.to_s
    htmlbody = page.html()
    # We have one page in our manual with has "Internal Server Error" in its text
    # we need to mark this page as success.
    if base != '/rhn/help/reference/en-US/ch-rhn-workgroup.jsp' &&
       (htmlbody.include?('Page Not Found') ||
        htmlbody.include?('File Not Found') ||
        htmlbody.include?('Internal Server Error') ||
        htmlbody.include?('Permission Error')
       )
      visited[base] = href
      $stderr.puts "-- ** failed"
    else
      if htmlbody.include?('/var/www/html')
          $stderr.puts "-- ** failed (/var/www)"
          failed_other_reason << href
      end
      #if page.has_content?('Errata') || page.has_content?('Erratum')
      #    $stderr.puts "-- ** failed (Errata)"
      #    failed_other_reason << href
      #end
      collect_all_hrefs.each do |fhref|
          next if fhref[0,1] == "#" # relative link
          next if hrefs.include?(fhref)
          hbase = fhref.split("?")[0]
          next if visited[hbase]
          visited[hbase] = true
          if hbase.nil? or hbase.empty?
              # Example: fhref = "?order=asc&sort=login"
              fhref = base.concat(fhref)
#             $stderr.puts "\t empyt hbase; new href is #{fhref}"
          elsif fhref[0,1] != "/"
              # Example: fhref = "delete_confirm.pxt?sgid=7"
#             $stderr.puts "From #{fhref} (#{base})"
              hsplit = base.split("/")
              hsplit.pop
              hsplit << fhref
              fhref = hsplit.join("/")
#             $stderr.puts "\t to #{fhref}"
          end
#         $stderr.puts "Adding #{fhref}"
          hrefs << fhref
          relation[fhref.to_s] = href.to_s
          #$stderr.puts "add rel #{fhref.to_s} => #{relation[fhref.to_s]}"
      end
    end
    break if hrefs.empty?
  end
  $stderr.puts "\nFinished. Visited #{visited.size} pages. Failed pages:"
  failed_pages = ""
  visited.each_value do |f|
    next if f.is_a? TrueClass
    failed_pages << "\t#{f}\n"
    $stderr.puts "\t#{f}"
  end
  failed_other_reason.each do |f|
      failed_pages << "\tother_reason: #{f}\n"
      $stderr.puts "\tother_reason: #{f}"
  end
  $stderr.puts "End of failed pages"
  if ! failed_pages.empty?
    raise "Failed pages:\n#{failed_pages}"
  end
end

Then /^I should be able to login$/ do

    (0..10).each() do |i|
        visit Capybara.app_host
        if page.has_content?('Welcome to SUSE Manager')
            break
        end
        sleep(5)
    end
end

