#!/usr/bin/ruby
# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.


#
# Get remote registration object.
#
def get_remote_registrar
  remote_registrar = nil
  if ENV['CLIENTHOST'].to_s != ""
    remote_registrar = RemoteRegistrationTest.new(ENV['CLIENTHOST'], ENV['USER'])
  end

  return remote_registrar
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


#
# Returns True if a client is a remote host.
#
def is_remote?
  return (ENV['CLIENTHOST'].to_s != "" and ENV['CLIENTHOST'] != $myhostname)
end


#
# Check if client has a zypper installed.
#
def client_is_zypp?
  File.stat("/usr/bin/zypper").executable?
end

#
# Check if a remote client has a zypper installed.
#
def remote_client_is_zypp?
  cmd = "file /usr/bin/zypper | grep -v 'No such file'"
  return get_remote_registrar.get_remote_client.exec_with_pty(cmd).strip =~ /LSB executable/
end


#
# Call RHN Check utility for queued actions on RHN. If there some, execute them.
#
def client_rhn_check
  cmd = "/usr/sbin/rhn_check"
  if is_remote?
    fail if (get_remote_registrar.get_remote_client.exec_with_pty("sudo " + cmd).strip != "")
  else
    `#{cmd}`
    fail if ! $?.success?
  end
end


#
# Refreshes a metadata for the client host.
#
def client_refresh_metadata
  zpr_refresh_cmd = "zypper --non-interactive refs -r spacewalk"
  yum_refresh_cmd = "yum clean all && yum makecache"

  if is_remote?
    if remote_client_is_zypp?
      puts "Remote is ZYPP"
    else
      puts "Remote is not zypp!"
    end
    raise "STOP"
  else
    if client_is_zypp?
      `#{zpr_refresh_cmd}`
    else
      `#{yum_refresh_cmd}`
    end
    fail if !$?.success?
  end
end


#
# Get a directory of the repository.
#
def client_raw_repodata_dir(channel)
  return "/var/cache" + (client_is_zypp ? "/zypp/raw/spacewalk:#{channel}/repodata" : "/yum/#{channel}")
end
