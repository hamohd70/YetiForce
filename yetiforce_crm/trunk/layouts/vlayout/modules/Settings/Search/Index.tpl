{*<!--
/*+***********************************************************************************************************************************
 * The contents of this file are subject to the YetiForce Public License Version 1.1 (the "License"); you may not use this file except
 * in compliance with the License.
 * Software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or implied.
 * See the License for the specific language governing rights and limitations under the License.
 * The Original Code is YetiForce.
 * The Initial Developer of the Original Code is YetiForce. Portions created by YetiForce are Copyright (C) www.yetiforce.com. 
 * All Rights Reserved.
 *************************************************************************************************************************************/
-->*}
<style type="text/css">
.visibility{
visibility: hidden;
}
.turn_off{
min-width: 20px;
}
</style>
{strip}
{assign var="ModulesEntity" value=$MODULE_MODEL->getModulesEntity()}
{assign var="Fields" value=$MODULE_MODEL->getFielFromModule()}
<div class="container-fluid SearchFieldsEdit">
	<div class="widget_header row-fluid">
		<div class="span10"><h3>{vtranslate($MODULE, $QUALIFIED_MODULE)}</h3>{vtranslate('LBL_Module_desc', $QUALIFIED_MODULE)}</div>
		<div class="span2"></div>
	</div>
	<hr>
	<div class="btn-toolbar">
		<span class="pull-right group-desc ">
			<button class="btn btn-success saveModuleSequence visibility" type="button">
				<strong>{vtranslate('LBL_SAVE_MODULE_SEQUENCE', $QUALIFIED_MODULE)}</strong>
			</button>
		</span>
		<div class="clearfix"></div>
	</div>
	<div class="row-fluid">
        <div class="contents tabbable">
			<table class="table table-bordered table-condensed listViewEntriesTable" id="modulesEntity">
				<thead>
					<tr class="blockHeader">
						<th><strong>{vtranslate('Module',$QUALIFIED_MODULE)}</strong></th>
						<th><strong>{vtranslate('LabelFields',$QUALIFIED_MODULE)}</strong></th>
						<th><strong>{vtranslate('SearchFields',$QUALIFIED_MODULE)}</strong></th>
						<th colspan="2"><strong>{vtranslate('Tools',$QUALIFIED_MODULE)}</strong></th>
					</tr>
				</thead>
				<tbody>
					{foreach from=$ModulesEntity item=item key=key}
						{assign var="Field" value=$Fields[$key]}
						<tr data-tabid="{$key}">
							<td><span class="span1">&nbsp;
								<a>
									<img src="{vimage_path('drag.png')}" border="0" title="{vtranslate('LBL_DRAG',$QUALIFIED_MODULE)}"/>
								</a>&nbsp;
							</span>{vtranslate($item['modulename'],$item['modulename'])}</td>
							<td>
								<select multiple class="chzn-select span4 fieldname" name="fieldname">
									<optgroup>
										{foreach from=$Field item=fieldTab }
											<option value="{$fieldTab['columnname']}" {if $MODULE_MODEL->compare_vale($item['fieldname'],$fieldTab['columnname'])}selected{/if}>
												{vtranslate($fieldTab['fieldlabel'],$item['modulename'])}
											</option>
										{/foreach}
									</optgroup>
								</select>
							</td>
							<td>
								<select multiple class="chzn-select span4 searchcolumn" name="searchcolumn">
									<optgroup>
										{foreach from=$Field item=fieldTab }
											<option value="{$fieldTab['columnname']}" {if $MODULE_MODEL->compare_vale($item['searchcolumn'],$fieldTab['columnname'])}selected{/if}>
												{vtranslate($fieldTab['fieldlabel'],$item['modulename'])}
											</option>
										{/foreach}
									</optgroup>
								</select>
							</td>
							<td>
								<button class="btn marginLeftZero updateLabels btn-info" data-tabid="{$key}">{vtranslate('Update labels',$QUALIFIED_MODULE)}</button>
							</td>
							<td>
								<button name="turn_off" class="btn marginLeftZero turn_off {if $item['turn_off'] eq 1}btn-success{else}btn-danger{/if}" style="min-width:40px" value="{$item['turn_off']}" >{if $item['turn_off'] eq 1}{vtranslate('LBL_TURN_OFF',$QUALIFIED_MODULE)}{else}{vtranslate('LBL_TURN_ON',$QUALIFIED_MODULE)}{/if}</button>
							</td>
						</tr>
					{/foreach}
				</tbody>
			</table>
		</div>
	</div>
	<div class="clearfix"></div>
{/strip}