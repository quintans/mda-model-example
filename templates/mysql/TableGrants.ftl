<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#if !entity.readOnly>
<#if !entity.root>
GRANT SELECT, INSERT, DELETE, UPDATE ON ${mylib.dbSchemaTableName(entity.alias)} TO &outro;
<#list entity.associations as association>
	<#if association.many && association.fromTarget.many && association.owner && !association.relations??>
GRANT SELECT, INSERT, DELETE, UPDATE ON ${mylib.dbSchemaTableName(association.alias)} TO &outro;
	</#if>
</#list>
</#if>
</#if>