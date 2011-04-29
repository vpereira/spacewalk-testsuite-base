# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

#@wip
Feature: Adding repository to a channel
  In Order distribute software to the clients
  As an authorized user
  I want to add a repository
  And I want to add this repository to the base channel


  Scenario: Adding FC14 Tests i386 repository
   Given I am authorized as "testing" with password "testing"
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "Manage Repositories" in the left menu
     And I follow "create new repository"
    When I enter "FC14-Tests i386 Repository" as "label"
     And I enter "http://aigle.suse.de/repos/FEDORA-14/i386/" as "url"
     And I click on "Create Repository"
    Then I should see a "Repository created successfully" text or "is already in use, please choose a different label" text

  Scenario: Add repository to the channel
   Given I am authorized as "testing" with password "testing"
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "FC14-Tests i386"
     And I follow "Repositories"
    When I check "FC14-Tests i386 Repository" in the list
     And I click on "Update Repositories"
    Then I should see a "FC14-Tests i386 repository information was successfully updated" text

  Scenario: Sync the repository in the channel
   Given I am authorized as "testing" with password "testing"
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "FC14-Tests i386"
     And I follow "Repositories"
     And I follow "Sync"
    When I click on "Sync Now"
    Then I should see a "Repository sync scheduled for FC14-Tests i386." text

  Scenario: Adding FC14-Tests x86_64 repository
   Given I am authorized as "testing" with password "testing"
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "Manage Repositories" in the left menu
     And I follow "create new repository"
    When I enter "FC14-Tests x86_64 Repository" as "label"
     And I enter "http://aigle.suse.de/repos/FEDORA-14/x86_64" as "url"
     And I click on "Create Repository"
    Then I should see a "Repository created successfully" text or "is already in use, please choose a different label" text

  Scenario: Disable Metadata check for FC14-Tests x86_64 repository
   Given I am authorized as "testing" with password "testing"
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "Manage Repositories" in the left menu
     And I follow "FC14-Tests x86_64 Repository"
     And I click on "Update Repository"
    Then I should see a "Repository updated successfully" text

  Scenario: Add repository to the channel
   Given I am authorized as "testing" with password "testing"
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "FC14-Tests x86_64"
     And I follow "Repositories"
    When I check "FC14-Tests x86_64 Repository" in the list
     And I click on "Update Repositories"
    Then I should see a "FC14-Tests x86_64 repository information was successfully updated" text

  Scenario: Sync the repository in the channel
   Given I am authorized as "testing" with password "testing"
     And I follow "Channels"
     And I follow "Manage Software Channels" in the left menu
     And I follow "FC14-Tests x86_64"
     And I follow "Repositories"
     And I follow "Sync"
    When I click on "Sync Now"
    Then I should see a "Repository sync scheduled for FC14-Tests x86_64." text

