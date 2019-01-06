<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
/*
<#list Entity as entity>
	<#if !entity.readOnly>
		<#if !entity.root>
DROP SEQUENCE ${mylib.chop(mylib.dbUpperName(entity.alias), 4)}_GEN;
		</#if>
	</#if>
</#list>
*/

<#list Entity as entity>
	<#if !entity.readOnly>
		<#if !entity.root>
CREATE SEQUENCE ${mylib.chop(mylib.dbUpperName(entity.alias), 4)}_GEN;
		</#if>
	</#if>
</#list>