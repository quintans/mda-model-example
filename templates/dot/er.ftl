<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#macro column attr type len>
			<tr><td align="left">${mylib.dbColumnName(attr.alias)}<#if !attr.nullable>*</#if></td><td align="left">${type}<#if len!=0>(${len})</#if></td></tr>
</#macro>
digraph G {
        fontname = "Arial"
        fontsize = 8
        pad = 0.5

        graph [splines=ortho overlap=false]
        node [
        	shape="plaintext" 
	        fontname = "Arial"
	        fontsize = 8
	        color=black
	    ]
<#list Entity as entity>
<#if !entity.root>

        "${entity.name}" [label=<
        <table bgcolor="lightyellow" border="1" cellborder="0" cellspacing="1">
			<tr><td align="center" colspan="2"><b>${mylib.dbTable2ColumnName(entity.alias)}</b></td></tr>
			<tr><td align="left">ID*</td><td align="left">${database['identity']}</td></tr>
<#list entity.attributes as attribute>
<#if !attribute.key>
	<#if attribute.lov??>
		<#if attribute.lov.numeric>
			<@column attr=attribute type=database['integer'] len=attribute.lov.keylen!2/>
		<#else>
			<@column attr=attribute type=database['string'] len=attribute.lov.keylen!2/>
		</#if>
	<#elseif attribute.type == 'string'>
			<@column attr=attribute type=database['string'] len=attribute.length!255/>
	<#else>
		<#if !database[attribute.type]??>
	<@log out='UNDEFINED attribute: '+entity.name+'.'+attribute.name+':'+attribute.type/>
		</#if>
			<@column attr=attribute type=database[attribute.type] len=attribute.length!0/>
	</#if>
</#if>
</#list>
<#list entity.associations as x>
	<#-- ONE to ONE (not owner) ou MANY to ONE-->
	<#if !x.many && !x.fromTarget.many && !x.owner || !x.many && x.fromTarget.many>
			<@column attr=x type=database['identity'] len=attribute.length!0/>
	</#if>
</#list>
   		</table>
		>]
</#if>
</#list>

<#list Entity as entity>
<#if !entity.root>
	<#list entity.associations as association>
		<#if association.many && association.fromTarget.many && association.owner>
"${association.alias}" [fillcolor=moccasin label="{${mylib.dbTable2ColumnName(association.alias)}|${mylib.dbTable2ColumnName(association.target.alias)}UID NOT NULL (FK)\l${mylib.dbTable2ColumnName(entity.alias)}UID NOT NULL (FK)}}"]
		</#if>
	</#list>
</#if>
</#list>
<#list Entity as entity>
<#if !entity.root>
	<#list entity.associations as association>	
		<#-- ONE to ONE (not owner) -->
		<#if !association.many && !association.fromTarget.many && association.owner>
        "${entity.name}" -> "${association.target.name}"
		<#-- MANY to ONE-->
		<#elseif !association.many && association.fromTarget.many>
        "${entity.name}" -> "${association.target.name}"
		<#-- MANY to MANY -->
		<#elseif association.many && association.fromTarget.many && association.owner>
        "${association.alias}" -> "${association.target.name}"
        "${association.alias}" -> "${entity.name}"
		</#if>
	</#list>
</#if>
</#list>
/* #CUSTOM_BLK_START FOOTER# */
/* #CUSTOM_BLK_END# */
}
