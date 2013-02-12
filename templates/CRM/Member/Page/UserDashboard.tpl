{*
 +--------------------------------------------------------------------+
 | CiviCRM version 4.1                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2011                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
*}
<div class="view-content">
{if $activeMembers}
<div id="memberships">
    <div class="form-item">
        {strip}
        <table>
        <tr class="columnheader">
            <th>{ts}Membership{/ts}</th>
            <th>{ts}Member Since{/ts}</th>
            <th>{ts}Start Date{/ts}</th>
            <th>{ts}End Date{/ts}</th>
            <th>{ts}Status{/ts}</th>
            <th></th>
        </tr>
        {foreach from=$activeMembers item=activeMember}
        <tr class="{cycle values="odd-row,even-row"} {$activeMember.class}">
	        <td>{$activeMember.membership_type}</td>
		<td>{$activeMember.join_date|crmDate}</td>
	        <td>{$activeMember.start_date|crmDate}</td>
	        <td>{$activeMember.end_date|crmDate}</td>
	        <td>{$activeMember.status}</td>
	        <td>{if $activeMember.renewPageId}<a href="{crmURL p='civicrm/contribute/transact' q="id=`$activeMember.renewPageId`&mid=`$activeMember.id`&reset=1"}">[ {ts}Renew Now{/ts} ]</a>{/if}</td>
        </tr>
        {/foreach}
        </table>
        {/strip}

    </div>
</div>
{/if}

{if $inActiveMembers}
<div id="ltype">
<p></p>
    <div class="label font-red">{ts}Expired / Inactive Memberships{/ts}</div>
    <div class="form-item">
        {strip}
        <table>
        <tr class="columnheader">
            <th>{ts}Membership{/ts}</th>
            <th>{ts}Start Date{/ts}</th>
            <th>{ts}End Date{/ts}</th>
            <th>{ts}Status{/ts}</th>
            <th></th>
        </tr>
        {foreach from=$inActiveMembers item=inActiveMember}
        <tr class="{cycle values="odd-row,even-row"} {$inActiveMember.class}">
	        <td>{$inActiveMember.membership_type}</td>
	        <td>{$inActiveMember.start_date|crmDate}</td>
	        <td>{$inActiveMember.end_date|crmDate}</td>
	        <td>{$inActiveMember.status}</td>
	        <td>{if $inActiveMember.renewPageId}<a href="{crmURL p='civicrm/contribute/transact' q="id=`$inActiveMember.renewPageId`&mid=`$inActiveMember.id`&reset=1"}">[ {ts}Renew Now{/ts} ]</a>{/if}</td>

        </tr>
        {/foreach}
        </table>
        {/strip}

    </div>
</div>
{/if}

{if NOT ($activeMembers or $inActiveMembers)}
   <div class="messages status">
       <div class="icon inform-icon"></div></dt>
           {ts}There are no memberships on record for you.{/ts}
   </div>
{/if}
</div>
{assign var=count value=0}
{if $contactId}
  {crmAPI entity="contribution" action="get" var="mycontributions" contact_id=$contactId is_test=0 return="honor_contact_id"}
  {if $mycontributions.values}
  <div id="gifted-memberships">
  <div class="header-dark">Gifted Membership(s)</div>
    <div class="form-item">
      <table>
        <tr class="columnheader">
          <th>{ts}Membership for{/ts}</th>
          <th>{ts}Membership{/ts}</th>
          <th>{ts}Start Date{/ts}</th>
          <th>{ts}End Date{/ts}</th>
          <th></th>
        </tr>
    {foreach from=$mycontributions.values item=contribution}
      {if $contribution.honor_contact_id}
        {crmAPI entity="membership_payment" action="get" var="mypayments" contribution_id=$contribution.id is_test=0}
        {if $mypayments.values}
          {foreach from=$mypayments.values item=payment}
            {crmAPI entity="membership" action="getsingle" var="membership" id=$payment.membership_id is_test=0}
            {crmAPI entity="contact" action="getvalue" var="contact" id=$membership.contact_id  return='display_name'}
            {assign var=membershipcontactid value=$membership.contact_id}
            {assign var=membershipid value=$membership.id}
              <tr>
                <td>{$contact}</td>
                <td>{$membership.source}</td>
                <td>{$membership.start_date}</td>
                <td>{$membership.end_date}</td>
                <td><a href={crmURL p='civicrm/contribute/transact' q="reset=1&mid=$membershipid&id=8" h=$membership.contact_id}>[Renew Now]</a></td>

              </tr>
          {/foreach}
        {/if}

      {/if}
    {/foreach}
  </table></div></div>
  {/if}
{/if}
