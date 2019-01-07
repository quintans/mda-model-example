<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#list Group as entity>
<#if !entity.readOnly>
<#if !entity.root>
<#assign tabname = mylib.dbSchemaTableName(entity.alias)>
	<#assign cnt = 1>
	<#list entity.associations as association>
		<#-- one to one (OWNER) / many to one -->
		<#if !association.many && !association.fromTarget.many && association.owner || !association.many && association.fromTarget.many>
			<#if association.id?? && association.id != '0' && !association.noForeignKey>
CREATE INDEX `${mylib.dbName('I'+cnt+'_'+tabname)}` ON `${tabname}` (`${mylib.dbTable2ColumnName(association.alias)}`);
				<#assign cnt = cnt + 1>
			</#if>
		</#if>
	</#list>
    <#list entity.indexes as index>
        <#assign cols = ''>
        <#list index.members as member>
            <#assign cols = mylib.concat(cols, "`"+mylib.dbTable2ColumnName(member.alias)+"`", ', ')>
        </#list>
CREATE INDEX `${mylib.dbName('I'+cnt+'_'+tabname)}` ON `${tabname}` (${cols});
            <#assign cnt = cnt + 1>
    </#list>
</#if>
</#if>
</#list>