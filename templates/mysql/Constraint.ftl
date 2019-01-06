<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#if !entity.readOnly>
<#if !entity.root>
<#-- NOTA: AS CONSTRAINTS SAO RECONSTRUIDAS NO DEPLOY -->
<#assign tabname = mylib.dbSchemaTableName(entity.alias)>
	<#-- unique keys -->
	<#assign cnt = 1>
	<#list entity.attributes as attribute>
		<#if attribute.unique>
ALTER TABLE `${tabname}` ADD CONSTRAINT ${mylib.dbName('U'+cnt+'_'+tabname)} UNIQUE (`${mylib.dbColumnName(attribute.alias)}`);
			<#assign cnt = cnt + 1>
		</#if>	
	</#list>
	<#-- uniqueGroup keys -->
	<#list entity.uniqueGroups as uniqueGroup>
ALTER TABLE `${tabname}` ADD CONSTRAINT ${mylib.dbName('U'+cnt+'_'+tabname)} UNIQUE (<@mylib.exp seq=uniqueGroup.members; x>`${mylib.dbColumnName(x.alias)}`</@mylib.exp>);
        <#assign cnt = cnt + 1>
	</#list>  
	<#assign cnt = 1>
	<#list entity.associations as association>
		<#-- one to one (OWNER) / many to one -->
		<#if !association.many && !association.fromTarget.many && association.owner || !association.many && association.fromTarget.many>
			<#if association.id?? && association.id != '0'>
<#--
<@log out='association.name: ' + association.name></@>
<@log out='association.fromTarget.alias: ' + association.fromTarget.alias></@>
-->
<#-- Vejo se tenho a flag para não criar a FK -->
<#if !association.noForeignKey>
<@compress single_line=true>
ALTER TABLE `${tabname}` ADD CONSTRAINT ${mylib.dbName('FK'+cnt+'_'+tabname)}
	<#if association.relations??>
  FOREIGN KEY (<@mylib.exp seq=association.relations; x>`${mylib.dbUpperName(x.foreign.name)}`</@mylib.exp>)
  REFERENCES `${mylib.dbSchemaTableName(association.target.alias)}` (<@mylib.exp seq=association.relations; x>`${mylib.dbUpperName(x.key.name)}`</@mylib.exp>);
	<#else>
  FOREIGN KEY (`${mylib.dbTable2ColumnName(association.alias)}`) 
  REFERENCES `${mylib.dbSchemaTableName(association.target.alias)}` (ID);
	</#if>
</@compress>
</#if>

				<#assign cnt = cnt + 1>
			</#if>
		<#-- one to one / one to many -->
<#--
		<#if !association.many && !association.fromTarget.many && association.owner || association.many && !association.fromTarget.many>
ALTER TABLE ${mylib.dbSchemaTableName(association.target.alias)} ADD CONSTRAINT ${mylib.dbSchemaTableName(association.fromTarget.alias)}R${cnt}
  FOREIGN KEY (${mylib.dbTableName(association.fromTarget.alias)}R) REFERENCES ${mylib.dbSchemaTableName(entity.name)} (ID);
			<#assign cnt = cnt + 1>
-->
		<#-- many to many -->
		<#elseif association.many && association.fromTarget.many && association.owner && !association.relations??>
            <#assign tabname = mylib.dbSchemaTableName(association.alias)>
-- FKs for the between ${mylib.dbUpperName(entity.name)} and ${mylib.dbUpperName(association.target.name)} 
<@compress single_line=true>
ALTER TABLE `${tabname}` ADD CONSTRAINT ${mylib.dbName('FK1_'+tabname)}
  FOREIGN KEY (`${mylib.dbTable2ColumnName(entity.alias)}`) 
  REFERENCES `${mylib.dbSchemaTableName(entity.alias)}` (ID);
</@compress>

<@compress single_line=true>
ALTER TABLE `${tabname}` ADD CONSTRAINT ${mylib.dbName('FK2_'+tabname)}
  FOREIGN KEY (`${mylib.dbTable2ColumnName(association.target.alias)}`) 
  REFERENCES `${mylib.dbSchemaTableName(association.target.alias)}` (ID);
</@compress>

<@compress single_line=true>
ALTER TABLE `${tabname}` ADD CONSTRAINT ${mylib.dbName('UK_'+tabname)}
 UNIQUE (`${mylib.dbTable2ColumnName(entity.alias)}`, `${mylib.dbTable2ColumnName(association.target.alias)}`);
</@compress>

		</#if>
	</#list>
</#if>
</#if>