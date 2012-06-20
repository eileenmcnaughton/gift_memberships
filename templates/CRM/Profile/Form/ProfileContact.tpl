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
{* This file provides the HTML for the on-behalf-of form. Can also be used for related contact edit form. *}


  <fieldset id="for_{$prefix}" class="for_{$prefix-group}">
  <legend>{$fieldSetTitle}</legend>

  <div id="{$prefix}-profile" class="crm-section">
    {foreach from=$fields item=field key=fieldName}
    <div class="crm-section {$fields.$fieldName.name}-section">
      {if $field.help_pre}
        &nbsp;&nbsp;<span class='description'>{$fields.help_pre}</span>
      {/if}

          {if $fields.$fieldName.options_per_line != 0}
            <div class="label option-label">{$field.label}</div>
            <div class="content 3">
              {assign var="count" value="1"}
              {strip}
              <table class="form-layout-compressed">
              <tr>
                {* sort by fails for option per line. Added a variable to iterate through the element array*}
                {assign var="index" value="1"}
                {foreach name=outer key=key item=item from=$field}
                {if $index < 10}
                  {assign var="index" value=`$index+1`}
                {else}
                  <td class="labels font-light">{$field.$key.html}</td>
                  {if $count == $field.options_per_line}
                    </tr>
                    <tr>
                    {assign var="count" value="1"}
                  {else}
                       {assign var="count" value=`$count+1`}
                  {/if}
                {/if}
                {/foreach}
              </tr>
              </table>
              {/strip}
              {if $field.help_post}
                 <span class='description'>{$fields.$fieldName.help_post}</span>
              {/if}
            </div>
          {else}
              <div class="label">{$field.label}</div>
              <div class="content">
              {$field.html}
        {if !empty($field.html_type)  && $field.html_type eq 'Autocomplete-Select'}
          {assign var=elementName value=onbehalf[$fieldName]}
          {include file="CRM/Custom/Form/AutoComplete.tpl" element_name=$elementName}
        {/if}
              {if $field.help_post}
                <br /><span class='description'>{$field.help_post}</span>
              {/if}
              </div>
          {/if}

      <div class="clear"></div>
    </div>
    {/foreach}
  </div>
  <div>{$form.mode.html}</div>


{literal}
<script type="text/javascript">

function setLocationDetails( contactID )
{
    resetValues( true );
    var locationUrl = {/literal}"{$locDataURL}"{literal} + contactID + "&ufId=" + {/literal}"{$profileId}"{literal};
    cj.ajax({
              url         : locationUrl,
              dataType    : "json",
              timeout     : 5000, //Time in milliseconds
              success     : function( data, status ) {
                for (var ele in data) {
                   if ( data[ele].type == 'Radio' ) {
                       if ( data[ele].value ) {
                           cj( "input[name='"+ ele +"']" ).filter( "[value=" + data[ele].value + "]" ).attr( 'checked', 'checked' );
                       }
       } else if ( data[ele].type == 'CheckBox' ) {
           if ( data[ele].value ) {
                           cj( "input[name='"+ ele +"']" ).attr( 'checked','checked' );
                       }
                   } else if ( data[ele].type == 'Multi-Select' ) {
                       for ( var selectedOption in data[ele].value ) {
                            cj( "#" + ele + " option[value='" + selectedOption + "']" ).attr( 'selected', 'selected' );
                       }
                   } else if ( data[ele].type == 'Autocomplete-Select' ) {
                       cj( "#" + ele ).val( data[ele].value );
                       cj( "#" + ele + '_id' ).val( data[ele].id );
                   } else {
                       cj( "#" + ele ).val( data[ele].value );
                   }
                }
              },
              error       : function( XMLHttpRequest, textStatus, errorThrown ) {
                   console.error("HTTP error status: ", textStatus);
              }
    });
}

</script>
{/literal}
</fieldset>

