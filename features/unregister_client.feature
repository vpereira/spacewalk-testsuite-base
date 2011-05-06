# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

Feature: Unregister a client
  In Order unregister a client to the spacewalk server
  I call system unregistration function on the web interface.

  Scenario: Unregister a client
    Given I am authorized
    When I follow "Systems"
     And I follow "Systems" in the left menu
     And I follow "All" in the left menu
     And I should see a current client hostname link
     And I follow current client hostname
     And I follow "delete system"
     And I click on "Delete Profile"
     And I should see a "System profile deleted." text


