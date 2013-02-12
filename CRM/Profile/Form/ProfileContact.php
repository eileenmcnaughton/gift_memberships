<?php

/*
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
*/

/**
 *
 * @package CRM
 * @copyright CiviCRM LLC (c) 2004-2011
 * $Id$
 *
 */
require_once 'CRM/Contact/BAO/Relationship.php';
require_once 'CRM/Core/BAO/UFGroup.php';
require_once 'CRM/Member/BAO/Membership.php';

class CRM_Profile_Form_ProfileContact
{
    /**
     * Function to set variables up before form is built
     * @param object $form Form object to add to
     * @param string module -
     * @return void
     * @access public
     */
    static function preProcess( &$form, $prefix,$profileId, $requiredProfileFields = array())
    {

        $form->_profileId = $profileId;
        $form->assign( $prefix . 'profileId', $form->_profileId );
        $form->assign( 'mode', $form->_mode );
        $form->profile_{$prefix} = array('id' => $profileId, 'requiredFields' => $requiredProfileFields);
    }

    /**
     * Function to build form for related contacts / on behalf of organization.
     *
     * @param $form              object  invoking Object
     * @param $contactType       string  contact type
     * @param $title             string  fieldset title
     * @param string $prefix  prefix to add to all fields
     *
     * @static
     */
    static function buildQuickForm( &$form,$contactType ,$title, $prefix )
    {
        $form->assign( 'fieldSetTitle', ts($title) );
        $form->assign( $prefix . 'profileform', true );
        $profileFields = CRM_Core_BAO_UFGroup::getFields( $form->_profileId, false, CRM_Core_Action::VIEW, null,
                                                          null, false, null, false, null,
                                                          CRM_Core_Permission::CREATE, null );
        $fieldTypes = array( 'Contact', $contactType);
        if ( is_array( $form->_membershipBlock ) && !empty( $form->_membershipBlock ) ) {
            $fieldTypes = array_merge( $fieldTypes, array( 'Membership' ) );
        } else {
            $fieldTypes = array_merge( $fieldTypes, array( 'Contribution' ) );
        }

        $stateCountryMap = array( );
        foreach ( $profileFields as $name => $field ) {
            if ( in_array( $field['field_type'], $fieldTypes ) ) {
                list( $prefixName, $index ) = CRM_Utils_System::explode( '-', $name, 2 );
                if ( in_array( $prefixName, array( 'state_province', 'country', 'county' ) ) ) {
                    if ( ! array_key_exists( $index, $stateCountryMap ) ) {
                        $stateCountryMap[$index] = array( );
                    }
                    $stateCountryMap[$index][$prefixName] = $prefix . $name;
                } else if ( in_array( $prefixName, $form->profile_{$prefix}['requiredFields'] ) &&
                            !CRM_Utils_Array::value( 'is_required', $field ) ) {
                    $field['is_required'] = 1;
                }

                CRM_Core_BAO_UFGroup::buildProfile( $form, $field, null, null, false, false, $prefix );
            }
        }

        if ( !empty($stateCountryMap) ) {
            require_once 'CRM/Core/BAO/Address.php';
            CRM_Core_BAO_Address::addStateCountryMap( $stateCountryMap );
        }

        $form->assign($prefix. 'ProfileFields', $profileFields);
        $form->addElement( 'hidden', "hidden_{$prefix}profile", 1 );
    }
}