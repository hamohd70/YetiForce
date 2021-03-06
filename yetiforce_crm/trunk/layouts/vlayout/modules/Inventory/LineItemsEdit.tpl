
{*<!--
/*********************************************************************************
** The contents of this file are subject to the vtiger CRM Public License Version 1.0
* ("License"); You may not use this file except in compliance with the License
* The Original Code is:  vtiger CRM Open Source
* The Initial Developer of the Original Code is vtiger.
* Portions created by vtiger are Copyright (C) vtiger.
* All Rights Reserved.
*
********************************************************************************/
-->*}
{strip}
    <!--
    All final details are stored in the first element in the array with the index name as final_details
    so we will get that array, parse that array and fill the details
    -->
    {assign var="FINAL" value=$RELATED_PRODUCTS.1.final_details}

    {assign var="IS_INDIVIDUAL_TAX_TYPE" value=false}
    {assign var="IS_GROUP_TAX_TYPE" value=true}

    {if $FINAL.taxtype eq 'individual'}
        {assign var="IS_GROUP_TAX_TYPE" value=false}
        {assign var="IS_INDIVIDUAL_TAX_TYPE" value=true}
    {/if}
    {assign var="NUMBEROFCURRENCYDECIMAL" value=$USER_MODEL->get('no_of_currency_decimals')}
    <input type="hidden" class="numberOfCurrencyDecimal" value="{$NUMBEROFCURRENCYDECIMAL}" />

    <table class="table table-bordered blockContainer lineItemTable" id="lineItemTab">
        <tr>
            <th colspan="2"><span class="inventoryLineItemHeader">{vtranslate('LBL_ITEM_DETAILS', $MODULE)}</span></th>
            <th colspan="2" class="chznDropDown">
                <div class="row-fluid">
                    <span class="inventoryLineItemHeader">{vtranslate('LBL_CURRENCY', $MODULE)}</span>&nbsp;&nbsp;
                    {assign var=SELECTED_CURRENCY value=$CURRENCINFO}
                    {* Lookup the currency information if not yet set - create mode *}
                    {if $SELECTED_CURRENCY eq ''}
                        {assign var=USER_CURRENCY_ID value=$USER_MODEL->get('currency_id')}
                        {foreach item=currency_details from=$CURRENCIES}
                            {if $currency_details.curid eq $USER_CURRENCY_ID}
                                {assign var=SELECTED_CURRENCY value=$currency_details}
                            {/if}
                        {/foreach}
                    {/if}

                    <select class="chzn-select" id="currency_id" name="currency_id" style="width: 164px;">
                        {foreach item=currency_details key=count from=$CURRENCIES}
                            <option value="{$currency_details.curid}" class="textShadowNone" data-conversion-rate="{$currency_details.conversionrate}" {if $SELECTED_CURRENCY.currency_id eq $currency_details.curid} selected {/if}>
                                {$currency_details.currencylabel|@getTranslatedCurrencyString} ({$currency_details.currencysymbol})
                            </option>
                        {/foreach}
                    </select>

                    {assign var="RECORD_CURRENCY_RATE" value=$RECORD_STRUCTURE_MODEL->getRecord()->get('conversion_rate')}
                    {if $RECORD_CURRENCY_RATE eq ''}
                        {assign var="RECORD_CURRENCY_RATE" value=$SELECTED_CURRENCY.conversionrate}
                    {/if}
                    <input type="hidden" name="conversion_rate" id="conversion_rate" value="{$RECORD_CURRENCY_RATE}" />
                    <input type="hidden" value="{$SELECTED_CURRENCY.currency_id}" id="prev_selected_currency_id" />
                    <!-- TODO : To get default currency in even better way than depending on first element -->
                    <input type="hidden" id="default_currency_id" value="{$CURRENCIES.0.curid}" />
                </div>
            </th>
            <th colspan="2" class="chznDropDown">
                <div class="row-fluid">
                    <div class="inventoryLineItemHeader">
                        <span class="alignTop">{vtranslate('LBL_TAX_MODE', $MODULE)}</span>
                    </div>
                    <select class="chzn-select lineItemTax" id="taxtype" name="taxtype" style="width: 164px;">
                        <OPTION value="individual" {if $IS_INDIVIDUAL_TAX_TYPE}selected{/if}>{vtranslate('LBL_INDIVIDUAL', $MODULE)}</OPTION>
                        <OPTION value="group" {if $IS_GROUP_TAX_TYPE}selected{/if}>{vtranslate('LBL_GROUP', $MODULE)}</OPTION>
                    </select>
                </div>
            </th>
        </tr>
        <tr>
            <td><b>{vtranslate('LBL_TOOLS',$MODULE)}</b></td>
            <td><span class="redColor">*</span><b>{vtranslate('LBL_ITEM_NAME',$MODULE)}</b></td>
            <td><b>{vtranslate('LBL_QTY',$MODULE)}</b></td>
            <td><b>{vtranslate('LBL_LIST_PRICE',$MODULE)}</b></td>
            <td><b class="pull-right">{vtranslate('LBL_TOTAL',$MODULE)}</b></td>
            <td><b class="pull-right">{vtranslate('LBL_NET_PRICE',$MODULE)}</b></td>
        </tr>
        <tr id="row0" class="hide lineItemCloneCopy">
            {include file="LineItemsContent.tpl"|@vtemplate_path:'Inventory' row_no=0 data=[]}
        </tr>
        {foreach key=row_no item=data from=$RELATED_PRODUCTS}
            <tr id="row{$row_no}" class="lineItemRow" {if $data["entityType$row_no"] eq 'Products'}data-quantity-in-stock={$data["qtyInStock$row_no"]}{/if}>
                {include file="LineItemsContent.tpl"|@vtemplate_path:'Inventory' row_no=$row_no data=$data}
            </tr>
        {/foreach}
        {if count($RELATED_PRODUCTS) eq 0}
            <tr id="row1" class="lineItemRow">
                {include file="LineItemsContent.tpl"|@vtemplate_path:'Inventory' row_no=1 data=[]}
            </tr>
        {/if}

    </table>


    <div class="row-fluid verticalBottomSpacing">
        <div>
            {if $PRODUCT_ACTIVE eq 'true' && $SERVICE_ACTIVE eq 'true'}
                <div class="btn-toolbar">
                    <span class="btn-group">
                        <button type="button" class="btn addButton" id="addProduct">
                            <i class="icon-plus"></i><strong>{vtranslate('LBL_ADD_PRODUCT',$MODULE)}</strong>
                        </button>
                    </span>
                    <span class="btn-group">
                        <button type="button" class="btn addButton" id="addService">
                            <i class="icon-plus"></i><strong>{vtranslate('LBL_ADD_SERVICE',$MODULE)}</strong>
                        </button>
                    </span>
                </div>
            {elseif $PRODUCT_ACTIVE eq 'true'}
                <div class="btn-group">
                    <button type="button" class="btn addButton" id="addProduct">
                        <i class="icon-plus"></i><strong> {vtranslate('LBL_ADD_PRODUCT',$MODULE)}</strong>
                    </button>
                </div>
            {elseif $SERVICE_ACTIVE eq 'true'}
                <div class="btn-group">
                    <button type="button" class="btn addButton" id="addService">
                        <i class="icon-plus icon-white"></i><strong> {vtranslate('LBL_ADD_SERVICE',$MODULE)}</strong>
                    </button>
                </div>
            {/if}
        </div>
    </div>
    <table class="table table-bordered blockContainer lineItemTable" id="lineItemResult">
		{if $MODULE_NAME neq 'OSSCosts' and $MODULE_NAME neq 'PurchaseOrder'}
			<tr valign="top">
				<td width="83%" >
					<div class="pull-right">
						<b>{vtranslate('Total Purchase',$MODULE)}</b>
					</div>
				</td>
				<td>
					<span id="total_purchase" name="total_purchase" class="pull-right total_purchase">{$FINAL.total_purchase}</span>
				</td>
			</tr>
		{/if}
        <tr>
            <td  width="83%">
                <div class="pull-right"><strong>{vtranslate('LBL_ITEMS_TOTAL',$MODULE)}</strong></div>
            </td>
            <td>
                <div id="netTotal" class="pull-right netTotal">{if !empty($FINAL.hdnSubTotal)}{$FINAL.hdnSubTotal}{else}0.00{/if}</div>
            </td>
        </tr>
        <tr>
            <td width="83%">
                <span class="pull-right">(-)&nbsp;<b><a href="javascript:void(0)"  id="finalDiscount">{vtranslate('LBL_TOTAL_DISCOUNT',$MODULE)}</a></b></span>
            </td>
            <td>
                <span id="discountTotal_final" class="pull-right discountTotal_final">{if $FINAL.discountTotal_final}{$FINAL.discountTotal_final}{else}0.00{/if}</span>

                <!-- Popup Discount Div -->
                <div id="finalDiscountUI" class="finalDiscountUI validCheck hide">
                    {assign var=DISCOUNT_TYPE_FINAL value="zero"}
                    {if !empty($FINAL.discount_type_final)}
                        {assign var=DISCOUNT_TYPE_FINAL value=$FINAL.discount_type_final }
                    {/if}
                    <input type="hidden" id="discount_type_final" name="discount_type_final" value="{$DISCOUNT_TYPE_FINAL}" />
                    <table width="100%" border="0" cellpadding="5" cellspacing="0" class="table table-nobordered popupTable">
                        <thead>
                            <tr>
                                <th id="discount_div_title_final"><b>{vtranslate('LBL_SET_DISCOUNT_FOR',$MODULE)}:{$data.$productTotal}</b></th>
                                <th>
                                    <button type="button" class="close closeDiv">x</button>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><input type="radio" name="discount_final" class="finalDiscounts" data-discount-type="zero" {if $DISCOUNT_TYPE_FINAL eq 'zero'}checked{/if} />&nbsp; {vtranslate('LBL_ZERO_DISCOUNT',$MODULE)}</td>
                                <td class="lineOnTop">
                                    <!-- Make the discount value as zero -->
                                    <input type="hidden" class="discountVal" value="0" />
                                </td>
                            </tr>
                            <tr>
                                <td><input type="radio" name="discount_final" class="finalDiscounts" data-discount-type="percentage" {if $DISCOUNT_TYPE_FINAL eq 'percentage'}checked{/if} />&nbsp; % {vtranslate('LBL_OF_PRICE',$MODULE)}</td>
                                <td><span class="pull-right">&nbsp;%</span><input type="text" data-validation-engine="validate[funcCall[Vtiger_PositiveNumber_Validator_Js.invokeValidation]]" id="discount_percentage_final" name="discount_percentage_final" value="{$FINAL.discount_percentage_final}" class="discount_percentage_final smallInputBox pull-right discountVal {if $DISCOUNT_TYPE_FINAL neq 'percentage'}hide{/if}" /></td>
                            </tr>
                            <tr>
                                <td><input type="radio" name="discount_final" class="finalDiscounts" data-discount-type="amount" {if $DISCOUNT_TYPE_FINAL eq 'amount'}checked{/if} />&nbsp;{vtranslate('LBL_DIRECT_PRICE_REDUCTION',$MODULE)}</td>
                                <td><input type="text" data-validation-engine="validate[funcCall[Vtiger_PositiveNumber_Validator_Js.invokeValidation]]"  id="discount_amount_final" name="discount_amount_final" value="{$FINAL.discount_amount_final}" class="smallInputBox pull-right discount_amount_final discountVal {if $DISCOUNT_TYPE_FINAL neq 'amount'}hide{/if}" /></td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="modal-footer lineItemPopupModalFooter modal-footer-padding">
                        <div class=" pull-right cancelLinkContainer">
                            <a class="cancelLink" type="reset" data-dismiss="modal">{vtranslate('LBL_CANCEL', $MODULE)}</a>
                        </div>
                        <button class="btn btn-success finalDiscountSave" type="button" name="lineItemActionSave"><strong>{vtranslate('LBL_SAVE', $MODULE)}</strong></button>
                    </div>
                </div>
                <!-- End Popup Div -->
            </td>
        </tr>
		<tr>
			<td width="83%">
				<span class="pull-right"><b>{vtranslate('LBL_PRE_TAX_TOTAL', $MODULE_NAME)} </b></span>
			</td>
			<td>
				{assign var=PRE_TAX_TOTAL value=$FINAL.preTaxTotal}
				<span class="pull-right" id="preTaxTotal">{if $PRE_TAX_TOTAL}{$PRE_TAX_TOTAL}{else}0.00{/if}</span>
				<input type="hidden" id="pre_tax_total" name="pre_tax_total" value="{if $PRE_TAX_TOTAL}{$PRE_TAX_TOTAL}{else}0.00{/if}"/>
			</td>
        </tr>
		{if $MODULE_NAME neq 'OSSCosts' and $MODULE_NAME neq 'PurchaseOrder'}
			<tr valign="top">
				<td width="83%" >
					<div class="pull-right">
						<b>{vtranslate('Total margin',$MODULE)}</b>
					</div>
				</td>
				<td>
					<span id="total_margin" name="total_margin" class="pull-right total_margin">{$FINAL.total_margin}</span>
				</td>
			</tr>
			<tr valign="top">
				<td width="83%" >
					<div class="pull-right">
						<b>{vtranslate('Total margin Percentage',$MODULE)}</b>
					</div>
				</td>
				<td>
					<span id="total_marginp" name="total_marginp" class="pull-right total_marginp">{$FINAL.total_marginp}</span>
				</td>
			</tr>
		{/if}
		<!-- Group Tax - starts -->
        <tr id="group_tax_row" valign="top" class="{if $IS_INDIVIDUAL_TAX_TYPE}hide{/if}">
            <td width="83%">
                <span class="pull-right">(+)&nbsp;<b><a href="javascript:void(0)" id="finalTax">{vtranslate('LBL_TAX',$MODULE)}</a></b></span>
                <!-- Pop Div For Group TAX -->
                <div class="hide finalTaxUI validCheck" id="group_tax_div">
                    <table width="100%" border="0" cellpadding="5" cellspacing="0" class="table table-nobordered popupTable">
                        <tr>
                            <th id="group_tax_div_title" colspan="2" nowrap align="left" >{vtranslate('LBL_GROUP_TAX',$MODULE)}</th>
                            <th colspan="2" align="right">
                                <button type="button" class="close closeDiv">x</button>
                            </th>
                        </tr>
                        {foreach item=tax_detail name=group_tax_loop key=loop_count from=$TAXES}
                            <tr>
								<td>
									<input type="radio" name="group_tax_option" class="group_tax_option" value="{$tax_detail.taxname}" {if {$FINAL['tax']} == $tax_detail.taxname}checked{/if}>
								</td>
                                <td align="left" class="lineOnTop">
                                    <input type="text" size="5" data-validation-engine="validate[funcCall[Vtiger_PositiveNumber_Validator_Js.invokeValidation]]" name="{$tax_detail.taxname}_group_percentage" id="group_tax_percentage{$smarty.foreach.group_tax_loop.iteration}" value="{$tax_detail.percentage}" class="smallInputBox groupTaxPercentage" />&nbsp;%
                                </td>
                                <td align="center" class="lineOnTop"><div class="textOverflowEllipsis">{$tax_detail.taxlabel}</div></td>
                                <td align="right" class="lineOnTop">
                                    <input type="text" size="6" name="{$tax_detail.taxname}_group_amount" id="group_tax_amount{$smarty.foreach.group_tax_loop.iteration}" style="cursor:pointer;" value="{$tax_detail.amount}" readonly class="cursorPointer smallInputBox groupTaxTotal" />
                                </td>
                            </tr>
                        {/foreach}
                        <input type="hidden" id="group_tax_count" value="{$smarty.foreach.group_tax_loop.iteration}" />
                    </table>
                    <div class="modal-footer lineItemPopupModalFooter modal-footer-padding">
                        <div class=" pull-right cancelLinkContainer">
                            <a class="cancelLink" type="reset" data-dismiss="modal">{vtranslate('LBL_CANCEL', $MODULE)}</a>
                        </div>
                        <button class="btn btn-success" type="button" name="lineItemActionSave"><strong>{vtranslate('LBL_SAVE', $MODULE)}</strong></button>
                    </div>
                </div>
                <!-- End Popup Div Group Tax -->
            </td>
            <td><span id="tax_final" class="pull-right tax_final">{if $FINAL.tax_totalamount}{$FINAL.tax_totalamount}{else}0.00{/if}</span></td>
        </tr>
        <tr valign="top">
            <td  width="83%">
                <span class="pull-right"><b>{vtranslate('LBL_GRAND_TOTAL',$MODULE)}</b></span>
            </td>
            <td>
                <span id="grandTotal" name="grandTotal" class="pull-right grandTotal">{$FINAL.grandTotal}</span>
            </td>
        </tr>
        {if $MODULE eq 'Invoice' or $MODULE eq 'PurchaseOrder'}
            <tr valign="top">
                <td width="83%" >
                    <div class="pull-right">
                        {if $MODULE eq 'Invoice'}
                            <b>{vtranslate('LBL_RECEIVED',$MODULE)}</b>
                        {else}
                            <b>{vtranslate('LBL_PAID',$MODULE)}</b>
                        {/if}
                    </div>
                </td>
                <td>
                    {if $MODULE eq 'Invoice'}
                            <span class="pull-right"><input id="received" name="received" type="text" class="lineItemInputBox" value="{if $RECORD->getDisplayValue('received') && !($IS_DUPLICATE)}{number_format($RECORD->get('received'),$NUMBEROFCURRENCYDECIMAL,'.','')}{else}0.00{/if}"></span>
                    {else}
                        <span class="pull-right"><input id="paid" name="paid" type="text" class="lineItemInputBox" value="{if $RECORD->getDisplayValue('paid') && !($IS_DUPLICATE)}{number_format($RECORD->get('paid'),$NUMBEROFCURRENCYDECIMAL,'.','')}{else}0.00{/if}"></span>
                    {/if}
                </td>
            </tr>
			<!--
            <tr valign="top">
                <td width="83%" >
                    <div class="pull-right">
                        <b>{vtranslate('LBL_BALANCE',$MODULE)}</b>
                    </div>
                </td>
                <td>
                    <span class="pull-right"><input id="balance" name="balance" type="text" class="lineItemInputBox" value="{if $RECORD->getDisplayValue('balance') && !($IS_DUPLICATE)}{number_format($RECORD->get('balance'),$NUMBEROFCURRENCYDECIMAL,'.','')}{else}0.00{/if}" readonly></span>
                </td>
            </tr>
			-->
        {/if}
    </table>
    <br>
    <input type="hidden" name="totalProductCount" id="totalProductCount" value="{$row_no}" />
    <input type="hidden" name="subtotal" id="subtotal" value="" />
    <input type="hidden" name="total" id="total" value="" />
{/strip}