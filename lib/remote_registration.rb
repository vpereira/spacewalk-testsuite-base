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
    @password = password
  end


  #
  # Get remote operations client.
  #
  def get_remote_client
    remote_client = ClientRemoteOperations.new(@host, @user)
    if @password
      remote_client.set_sudo_password(@password)
    end
    remote_client.connect

    return remote_client
  end


  #
  # Check environment if we can operate with the target host.
  #
  def check_env
    # Check we are on a correct host
    hostname = self.get_remote_client.exec("hostname")
    if hostname != @host or hostname == "linux"
      raise "Wrong hostname: " + hostname.to_s
    end

    # Check we can access as a root.
    data = self.get_remote_client.exec_with_pty("sudo id")

    if data !~ /^uid=0/ # Ruby is like a Pascalized Perl: if no regex, then no real life, but you have always "end"...
      raise "I have no access to the root-protected resources via sudo on a remote host."
    end

    # Check required utils are around
    data = self.get_remote_client.exec_with_pty("sudo which rhnreg_ks 2>/dev/null").strip
    if data == ""
      print "\nERROR: Where is \"rhnreg_ks\" utility on a \"#{@host}\" host?\n\n"
      raise "No RHN registration utility found on the remote host."
    end
  end


  #
  # Get platform name.
  #
  def get_platform
    arch = self.get_remote_client.exec_with_pty("uname -m").chomp
    return arch ? arch : nil
  end
end
