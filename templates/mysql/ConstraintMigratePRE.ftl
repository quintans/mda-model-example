<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
/*
Dropping all constraints for the entire OLD model entities 
*/
<#list OldEntities as entity>
<#if !entity.readOnly>
<#if !entity.root>
<#assign tabname = mylib.dbSchemaTableName(entity.alias)>
	<#-- unique keys -->
	<#assign cnt = 1>
	<#list entity.attributes as attribute>
		<#if attribute.unique>
ALTER TABLE `${tabname}` DROP CONSTRAINT ${mylib.dbName('U'+cnt+'_'+tabname)};
			<#assign cnt = cnt + 1>
		</#if>	
	</#list>
	<#-- uniqueGroup keys -->
	<#list entity.uniqueGroups as uniqueGroup>
ALTER TABLE `${tabname}` DROP CONSTRAINT ${mylib.dbName('U'+cnt+'_'+tabname)};
	</#list>  
	<#assign cnt = 1>
	<#list entity.associations as association>
		<#-- one to one (OWNER) / many to one -->
		<#if !association.many && !association.fromTarget.many && association.owner || !association.many && association.fromTarget.many>
			<#if association.id != '0'>
ALTER TABLE `${tabname}` DROP CONSTRAINT ${mylib.dbName('FK'+cnt+'_'+tabname)}
				<#assign cnt = cnt + 1>
			</#if>
		<#-- many to many -->
		<#elseif association.many && association.fromTarget.many && association.owner && !association.relations??>
            <#assign tabname = mylib.dbSchemaTableName(association.alias)>		
-- FKs for the between ${mylib.dbUpperName(entity.name)} and ${mylib.dbUpperName(association.target.name)} 
ALTER TABLE `${tabname}` DROP CONSTRAINT ${mylib.dbName('FK1_'+tabname)};
ALTER TABLE `${tabname}` DROP CONSTRAINT ${mylib.dbName('FK2_'+tabname)};
ALTER TABLE `${tabname}` DROP CONSTRAINT ${mylib.dbName('UK_'+tabname)};
		</#if>
	</#list>
</#if>
</#if>
</#list>