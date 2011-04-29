# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

#@wip
Feature: Adding channels
  In Order distribute software to the clients
  As an authorized user
  I want to add channels

  Background:
    Given I am testing channels

  Scenario: Adding a base channel
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "create new channel"
    When I enter "Test Base Channel" as "Channel Name"
     And I enter "test_base_channel" as "Channel Label"
     And I select "None" from "Parent Channel"
     And I select "x86_64" from "Channel Architecture"
     And I enter "Base channel for testing" as "Channel Summary"
     And I enter "No more description for base channel." as "Channel Description"
     And I click on "Create Channel"
    Then I should see a "Channel Test Base Channel created." text

  Scenario: Adding FC14-Tests i386 base channel
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "create new channel"
    When I enter "FC14-Tests i386" as "Channel Name"
     And I enter "fc14-tests-i386" as "Channel Label"
     And I select "None" from "Parent Channel"
     And I select "IA-32" from "Channel Architecture"
     And I enter "FC14-Tests i386 channel for testing" as "Channel Summary"
     And I enter "No more description for base channel." as "Channel Description"
     And I click on "Create Channel"
    Then I should see a "Channel FC14-Tests i386 created." text

  Scenario: Adding FC14-Tests x86_64 base channel
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "create new channel"
    When I enter "FC14-Tests x86_64" as "Channel Name"
     And I enter "fc14-tests-x86_64" as "Channel Label"
     And I select "None" from "Parent Channel"
     And I select "x86_64" from "Channel Architecture"
     And I enter "FC14 Tests x86_64 channel for testing" as "Channel Summary"
     And I enter "No more description for base channel." as "Channel Description"
     And I click on "Create Channel"
    Then I should see a "Channel FC14-Tests x86_64 created." text

#2nd entry
# "The channel name 'Test Base Channel' is already in use, please enter a different name"
