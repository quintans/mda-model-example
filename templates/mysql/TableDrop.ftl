<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#list Group?reverse as entity>
	<#if !entity.readOnly>
		<#if !entity.root>
            <#list entity.associations as association>
                <#if association.many && association.fromTarget.many && association.owner && !association.relations??>
-- tabela intermedia entre ${entity.name} e ${association.target.name}
DROP TABLE `${mylib.dbSchemaTableName(association.alias)}`;
                </#if>
            </#list>
DROP TABLE `${mylib.dbSchemaTableName(entity.alias)}`;
		</#if>
	</#if>
</#list>
