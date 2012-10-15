
{assign var=count value=0}
{if $contactId}
  {crmAPI entity="contribution" action="get" var="mycontributions" contact_id=$contactId is_test=0 return="honor_contact_id"}
  {if $mycontributions.values}
  <h3 class='header-dark'>Gifted Memberships</h3>
    <table>
    <tr>
      <td>Contact</td>
      <td>Type</td>
      <td>Expiry</td>
    </tr>
    {foreach from=$mycontributions.values item=contribution}
      {if $contribution.contribution_honor_contact_id}
        {crmAPI entity="membership_payment" action="get" var="mypayments" contribution_id=$contribution.id is_test=0 rowCount=50}
        {if $mypayments.values}
          {foreach from=$mypayments.values item=payment}
            {crmAPI entity="membership" action="getsingle" var="membership" id=$payment.membership_id is_test=0}
            {crmAPI entity="contact" action="getvalue" var="contact" id=$membership.contact_id  return='display_name'}
            {assign var=membershipcontactid value=$membership.contact_id}
            {assign var=membershipid value=$membership.id}
              <tr>
                <td><a href={crmURL p='civicrm/contribute/transact' q="reset=1&mid=$membershipcontactid&id=8" h=$membership.contact_id}>{$contact}</a></td>
                <td>{$membership.membership_name}</td>
                <td>{$membership.end_date}</td>
              </tr>
          {/foreach}
        {/if}

      {/if}

  {/foreach}
  </table>
  {/if}
{/if}

