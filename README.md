gift_memberships
================

CiviCRM Gift Membership Module

Temporary implementation of 

http://wiki.civicrm.org/confluence/display/CRM/Technical+Specs

http://wiki.civicrm.org/confluence/display/CRM/Making+Gift+Memberships+a+Standard+Feature

With the hope of moving some to core

At this stage you need to patch your Civi with 
https://github.com/fuzionnz/civicrm/commit/fc2f37523cb37fd424bf5de7ad0f6ed20a8ee423

I haven't figured out how to fix Civi in Core yet so it hands off to hooks at the right point

Note that the following assumptions are made
1) first_name & last_name are required fields on honor contact
2) you need to create a profile using these fields & define it - HONOR_PROFILE
3) we are simply working with a situation where all other honor types are disabled

