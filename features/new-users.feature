# Copyright (c) 2010-2011 Novell, Inc.
# Licensed under the terms of the MIT license.

# feature/users.feature
@setup
Feature: Create and delete a new user.
  Scenario: Try to create a new user with a weak password
    Given I am on the Users page
      When I follow "create new user"
        And I enter "user1" as "login"
        And I enter "x" as "desiredpassword"
        And I enter "x" as "desiredpasswordConfirm"
        And I select "Mr." from "prefix"
        And I enter "Test" as "firstNames"
        And I enter "User" as "lastName"
        And I enter "galaxy-noise@suse.de" as "email"
        And I click on "Create Login"
       Then I should see a "Desired Password cannot be less than 5 characters." text
        And I should see a "Confirm Password cannot be less than 5 characters." text

  Scenario: Try to create a new user with a password that does not matches.
    Given I am on the Users page
      When I follow "create new user"
        And I enter "user1" as "login"
        And I enter "foobar" as "desiredpassword"
        And I enter "spambot" as "desiredpasswordConfirm"
        And I select "Mr." from "prefix"
        And I enter "Test" as "firstNames"
        And I enter "User" as "lastName"
        And I enter "galaxy-noise@suse.de" as "email"
        And I click on "Create Login"
       Then I should see a "Passwords do not match." text

  Scenario: Create a new user.
    Given I am on the Users page
      When I follow "create new user"
        And I enter "user1" as "login"
        And I enter "user1" as "desiredpassword"
        And I enter "user1" as "desiredpasswordConfirm"
        And I select "Mr." from "prefix"
        And I enter "Test" as "firstNames"
        And I enter "User" as "lastName"
        And I enter "galaxy-noise@suse.de" as "email"
        And I click on "Create Login"
      Then I should see a "Account user1 created, login information sent to galaxy-noise@suse.de" text
        And I should see a "user1" link

  Scenario: Login as user1
    Given I am authorized as "user1" with password "user1"
      Then I should see a "user1" link

  Scenario: Access new user details
    Given I am on the Details page
      Then I should see a "User Details" text
        And I should see a "delete user" link
        And I should see a "deactivate user" link
        And I should see a "Details" link
        And I should see a "System Groups" link
        And I should see a "Systems" link
        And I should see a "Channel Permissions" link
        And I should see a "Preferences" link
        And I should see a "Addresses" link
        And I should see a "Notification Methods" link
        And I should see a "user1" text
        And Option "Mr." is selected as "prefix"
        And I should see "Test" in field "firstNames"
        And I should see "User" in field "lastName"
        And I should see a "galaxy-noise@suse.de" text
        And I should see a "Change" link
        And I should see a "Administrative Roles" text
        And I should see a "Roles:" text
        And I should see a "Created:" text
        And I should see a "Last Sign In:" text

  Scenario: Change Roles (1)
    Given I am on the Details page
      When the "role_satellite_admin" checkbox should be disabled
        And I check "role_org_admin"
        And I check "role_system_group_admin"
        And I check "role_channel_admin"
        And I check "role_activation_key_admin"
        And I check "role_config_admin"
        And I check "role_monitoring_admin"
        And I click on "Submit"
      Then the "role_satellite_admin" checkbox should be disabled
        And I should see a "Spacewalk Administrator" text
        And I should see "role_org_admin" as checked
        And I should see a "Organization Administrator" text
        And the "role_system_group_admin" checkbox should be disabled
        And I should see "role_system_group_admin" as checked
        And I should see a "System Group Administrator - [ Admin Access ]" text
        And the "role_channel_admin" checkbox should be disabled
        And I should see "role_channel_admin" as checked
        And I should see a "Channel Administrator - [ Admin Access ]" text
        And the "role_activation_key_admin" checkbox should be disabled
        And I should see "role_activation_key_admin" as checked
        And I should see a "Activation Key Administrator - [ Admin Access ]" text
        And the "role_config_admin" checkbox should be disabled
        And I should see "role_config_admin" as checked
        And I should see a "Configuration Administrator - [ Admin Access ]" text
        And the "role_monitoring_admin" checkbox should be disabled
        And I should see "role_monitoring_admin" as checked
        And I should see a "Monitoring Administrator - [ Admin Access ]" text
        And I should see a "Above roles are granted via the Organization Administrator role." text

  Scenario: Verify User List
    Given I am on the Users page
      Then Table row for "user1" should contain "Organization Administrator"
        And Table row for "user1" should contain "Channel Administrator"
        And Table row for "user1" should contain "Configuration Administrator"
        And Table row for "user1" should contain "Monitoring Administrator"
        And Table row for "user1" should contain "System Group Administrator"
        And Table row for "user1" should contain "Activation Key Administrator"

  Scenario: Deactivate User (Fail)
    Given I am on the Details page
      When I follow "deactivate user"
      Then I should see a "This action will deactivate this user. This user will no longer be able to log in or perform actions unless it is reactivated." text
      When I click on "Deactivate User"
      Then I should see a "You cannot deactivate another organization administrator. Please remove the 'Organization Administrator' role from this user before attempting to deactivate their account." text
      When I follow "Deactivated"
      Then I should see a "No deactivated users." text

  Scenario: Change Role (2)
    Given I am on the Details page
      When I uncheck "role_org_admin"
        And I click on "Submit"
      Then I should see "role_org_admin" as unchecked

  Scenario: Deactivate User (Succeed)
    Given I am on the Details page
      Then I should see "role_org_admin" as unchecked
      When I follow "deactivate user"
      Then I should see a "This action will deactivate this user. This user will no longer be able to log in or perform actions unless it is reactivated." text
      When I click on "Deactivate User"
      Then I should see a "Active Users" text
        And I should not see a "user1" link
      When I follow "Deactivated"
      Then I should see a "Deactivated Users" text
        And I should see a "user1" link
      When I follow "All"
      Then I should see a "user1" link

  Scenario: Reactivate User (Succeed)
    Given I am on the Users page
     When I follow "Deactivated"
      And I follow "user1"
     Then I should see a "reactivate user" link
     When I follow "reactivate user"
     Then I should see a "This action will allow this user to access Spacewalk. This user will retain all permissions, roles, and data that he or she had before being deactivated." text
     When I click on "Reactivate User"
     Then I should see a "Active Users" text
      And I should see a "user1" link
     When I follow "Deactivated"
     Then I should not see a "user1" link

  Scenario: Delete user1
    Given I am on the Details page
      When I follow "delete user"
      Then I should see a "Confirm User Deletion" text
       And I should see a "This will delete this user permanently." text
      When I click on "Delete User"
      Then I should see a "Active Users" text
       And I should not see a "user1" link


