{if $action eq 16}
{assign var=count value=0}
{if $contactId}
  {crmAPI entity="contribution" action="get" var="mycontributions" contact_id=$contactId is_test=0 return="honor_contact_id"}
  {if $mycontributions.values}
  <h3>Gifted Memberships</h3>
    <table><tr>
      <td>Contact</td>
      <td>Source</td>
      <td>Status</td>
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
                <td><a href={crmURL p='civicrm/contact/view/membership' q="action=view&reset=1&cid=$membershipcontactid&id=$membershipid&context=membership&selectedChild=member" h=$membership.contact_id}>{$membership.contact_id}</a></td>
                <td>{$membership.source}</td>
                <td>{$membership.status}</td>
              </tr>
          {/foreach}
        {/if}

      {/if}

  {/foreach}
  </table>
  {/if}
{/if}
{/if}
