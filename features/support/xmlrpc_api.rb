File.expand_path(__FILE__)           # For Ruby 1.9.2+
$LOAD_PATH << File.dirname(__FILE__) # For Ruby 1.8

require 'xmlrpctest'


class XMLRPCApiTest < XMLRPCBaseTest
  def getVersion()
    return @connection.call("api.getVersion")
  end


  def systemVersion()
    return @connection.call("api.systemVersion")
  end


  def getCountOfApiNamespaces()
    namespaces = @connection.call("api.getApiNamespaces", @sid)
    count = 0
    if namespaces != nil
      count = namespaces.length
    end

    return count
  end


  #
  # Test lists all available api calls grouped by namespace.
  #
  def getCountOfApiCallListGroups()
    callList = @connection.call("api.getApiCallList", @sid)
    count = 0
    if callList != nil
      count = callList.length
    end

    return count
  end


  def getCountOfApiNamespaceCallList()
    count = 0
    namespaces = @connection.call("api.getApiNamespaces", @sid)
    puts "    Spaces found: " + namespaces.length.to_s
    for ns in namespaces
      print "      Analyzing " + ns[0] + "... "
      callList = @connection.call("api.getApiNamespaceCallList", @sid, ns[0])
      if callList != nil
        count += callList.length
        puts "Done"
      else
        puts "Failed"
      end
    end

    return count
  end
end
