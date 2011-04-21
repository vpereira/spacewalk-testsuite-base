# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.
#
# Author: Bo Maryniuk <bo@suse.de>
#
# This module allows remote execution for the Cucumber-based test suite.
# Original Spacewalk better suits with the Fedora clients instead.

require 'remote_client'


#
# Remote registration tester
#
class RemoteRegistrationTest

  #
  # Class constructor.
  #
  def initialize(host, user, password = nil)
    @host = host
    @user = user
    @remote_client = ClientRemoteOperations.new(host, user)
    if password
      @remote_client.set_sudo_password(password)
    end
    @remote_client.connect
  end


  #
  # Check environment if we can operate with the target host.
  #
  def check_env
    hostname = @remote_client.exec!("hostname").strip! # XXX: Not finished
    if hostname != @host
      raise "Wrong hostname: " + hostname
    end

    data = @remote_client.exec!("sudo cat /etc/shadow")
    puts data
  end
end
