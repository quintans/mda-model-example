<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#if !entity.readOnly>
<#if !entity.root>
CREATE OR REPLACE SYNONYM ${mylib.dbSchemaTableName(entity.alias)} FOR &dono..${mylib.dbSchemaTableName(entity.alias)};
<#list entity.associations as association>
	<#if association.many && association.fromTarget.many && association.owner && !association.relations??>
CREATE OR REPLACE SYNONYM ${mylib.dbSchemaTableName(association.alias)} FOR &dono..${mylib.dbSchemaTableName(association.alias)};
	</#if>
</#list>
</#if>
</#if>