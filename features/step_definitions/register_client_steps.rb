# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

require "remote_registration"


$client_host = ENV['CLIENTHOST']

#
# Get remote registration object.
#
def get_remote_registrar
  remote_registrar = nil
  if $client_host
    remote_registrar = RemoteRegistrationTest.new($client_host, ENV['USER'])
  end

  return remote_registrar
end


#
# Register remote host.
#
def register_local_or_remote_host(keyname)
  if ENV['TESTHOST'].to_s == ""
    print "    ERROR: Please define TESTHOST environment variable.\n\n"
    raise "Satellite host is missing!"
  end

  rm_sys_id_cmd = "rm -f /etc/sysconfig/rhn/systemid"
  regurl = "http://#{ENV['TESTHOST']}/XMLRPC"
  reg_host_cmd = "rhnreg_ks --serverUrl=#{regurl} --activationkey=#{keyname}"

  if $client_host.to_s != ""
    puts "Registering remote host #{$client_host}"
    print "Removing system ID...  "
    begin
      result = get_remote_registrar.get_remote_client.exec_with_pty("sudo " + rm_sys_id_cmd)
      print "Done\n"
      puts "Result: #{result}"
    rescue
      print "Failed\n"
    end

    print "Registering host... "
    begin
      result = get_remote_registrar.get_remote_client.exec_with_pty("sudo " + reg_host_cmd)
      print "Done\n"
      puts "Result: #{result}"
    rescue
      print "Failed\n"
    end

  else
    `#{rm_sys_id_cmd}`
    output = `#{reg_host_cmd}`
    if ! $?.success?
      raise "Registration failed '#{command}' #{$!}: #{output}"
    end
  end
end


#
# Get a client hostname (remote or a local)
#
def get_client_hostname
  hostname = ENV['CLIENTHOST']
  if hostname.to_s == ""
    hostname = $myhostname
  end
  return hostname
end


Given /^I am root$/ do
  if $client_host
    puts "    WARNING: Root test has been skipped as you are registering a remote host \"#{$client_host}\"."
  else
    if $client_host != nil
      puts "Using target host: " + $client_host
    end

    uid = `id -u`
    if ! $?.success? || uid.to_i != 0
      raise "You are not root!"
    end
  end

  if get_client_hostname == "linux"
    raise "Invalid hostname"
  end
end


Given /^I am on the Systems overview page of this client$/ do
  Given "I am on the Systems page"
  Given "I follow \"Systems\" in element \"sidenav\""
  When  "I follow this client link"
end


Given /^I update the profile of this client$/ do
  `rhn-profile-sync`
  if ! $?.success?
    raise "Profile sync failed"
  end
end


When /^I register using "([^"]*)" key$/ do |keyname|
  register_local_or_remote_host(keyname)
end


When /^I register using an activation key$/ do
  arch = nil
  remote = get_remote_registrar()
  if remote
    arch = remote.get_platform
  else
    arch=`#{cmd}`.chomp
  end

  platforms = ["x86_64", "i586"]
  if !platforms.any? {|platform| platform == arch}
    puts "    WARNING: Overriding platform #{arch} with i586."
    arch = "i586"
  end

  When "I register using \"1-SUSE-DEV-#{arch}\" key"
end


Then /^I should see this client in spacewalk$/ do
  Given "I am on the Systems page"
  Then "I should see this client as link"
end


Then /^I should see this client as link$/ do
  Then "I should see a \"#{get_client_hostname}\" link"
end


When /^I follow this client link$/ do
  When "I follow \"#{get_client_hostname}\""
end

When /^I check if it is a remote host$/ do
  remote = get_remote_registrar()
  if remote
    remote.check_env
  else
    puts "    NOTE: You are going to register *this* host."
  end
end
