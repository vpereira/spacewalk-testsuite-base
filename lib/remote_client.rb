# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.
#
# Author: Bo Maryniuk <bo@suse.de>
#
# This module allows remote execution for the Cucumber-based test suite.
# Original Spacewalk better suits with the Fedora clients instead.
#
# Requires:
#      rubygem-net-ssh
#      rubygem-highline (optional)
#

require 'rubygems'
require 'net/ssh'


#
# Class to operate remote.
#
class ClientRemoteOperations
  attr :verbose, true
  #
  # Initialization of the class.
  #
  def initialize(host, user)
    @host = host
    @user = user

    @ssh = nil
    @channel = nil
    @verbose = true
    @sudo_password = ""
  end


  #
  # Connect to the remove via SSH.
  #
  def connect
    if @ssh
      return @ssh
    end

    begin
      @ssh = Net::SSH.start(@host, @user)
    rescue Net::SSH::AuthenticationFailed => e
      if self.verbose
        puts "Authentication error. Have you generated your passphrase-less SSH keys yet to the right places?"
        raise Exception
      end
    end

    return @ssh
  end


  #
  # Exec an SSH command without a pseudo TTY.
  # Useful for SSH commands within a same user session.
  #
  def exec(command)
    return @ssh.exec!(command).chomp
  end


  #
  # In order to run remote sudo commands, a TTY is needed.  # SSH can create a pseudo-tty, called PTY.
  # This method allows you to call anything within the PTY initialized.
  #
  def exec_with_pty(command)
    out = []
    @ssh.open_channel do |channel|
      channel.request_pty do |c, result|
        if !result
          raise "No PTY allocated :("
        end
      end

      channel.exec(command) do |c, callback|
        abort "Execution error" unless callback

        channel.on_data do |c, data|
          data.strip!
          if data.include?('password for ' + @user)
            channel.send_data(@sudo_password + "\n")
          else
            out.push(data)
          end
        end

        channel.on_extended_data do |c, type, data|
          puts "STDERR: #{data}"
        end

        #channel.on_close do |c|
        #  puts "Closing"
        #end
      end
    end

    # Channels working simultaneously over the session.
    # We have only one channel at one call, yet still
    # need to wait it is all done.

    @ssh.loop

    # Return the out back in appropriate type.

    if out
      return out.join('')
    else
      return nil
    end
  end


  #
  # Close SSH connection to the remote.
  #
  def close
    if @ssh
      @ssh.close
    end
  end


  #
  # Set sudo password on the remote host.
  # No need in case of there is a :NOPASSWD in /etc/sudoers
  # for the current user.
  #
  def set_sudo_password(password)
    @sudo_password = password
  end
end


# Test usage and example
if __FILE__ == $0
  begin
    require 'highline/import'
  rescue
    puts "In order to run this example, please install rubygem-highline package first."
    exit 1
  end

  puts "Running Net::SSH"
  cro = ClientRemoteOperations.new("dummy.suse.de", ENV['USER'])
  cro.set_sudo_password(ask("Your sudo password, please?") {|o| o.echo = false})
  cro.connect
  cro.exec_with_pty("sudo cat /etc/shadow")
  cro.close
  puts "Finished"
end
