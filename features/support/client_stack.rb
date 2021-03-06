#!/usr/bin/ruby
# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

def client_is_zypp?
  File.stat("/usr/bin/zypper").executable?
end

def client_refresh_metadata
  if client_is_zypp?
    `zypper --non-interactive ref -s`
    fail if ! $?.success?
  else
    `yum clean all`
   fail if ! $?.success?
   `yum makecache`
   fail if ! $?.success?
  end
end

def client_raw_repodata_dir( channel )
  if client_is_zypp?
    return "/var/cache/zypp/raw/spacewalk:#{channel}/repodata"
  else
    return "/var/cache/yum/#{channel}"
  end
end
