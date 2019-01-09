<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
digraph G {
        fontname = "Sans Not-Rotated"
        fontsize = 8
        pad = 0.5

        graph [splines=ortho overlap=false]
        node [fontname="Sans Not-Rotated" shape="record" style=filled fillcolor=lightyellow color=black]
<#list Entity as entity>
<#if !entity.root>

<@mylib.compress_single_line>
        "${entity.name}" [label="{${mylib.dbTable2ColumnName(entity.alias)}|ID ${database['identity']} NOT NULL (PK)\l
<#list entity.attributes as attribute>
<#if !attribute.key>
	<#if attribute.lov??>
		<#if attribute.lov.numeric>
${mylib.dbColumnName(attribute.alias)} ${database['integer']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>\l
		<#else>
${mylib.dbColumnName(attribute.alias)} ${database['string']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>\l
		</#if>
	<#elseif attribute.type == 'string'>
${mylib.dbColumnName(attribute.alias)} ${database['string']}(<#if attribute.length??>${attribute.length?c}<#else>255</#if>)<#if !attribute.nullable> NOT NULL</#if>\l
	<#else>
		<#if !database[attribute.type]??>
	<@log out='UNDEFINED attribute: '+entity.name+'.'+attribute.name+':'+attribute.type/>
		</#if>
${mylib.dbColumnName(attribute.alias)} ${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if><#if !attribute.nullable> NOT NULL</#if>\l
	</#if>
</#if>
</#list>
<#assign sep="0">
<#list entity.associations as x>
	<#-- ONE to ONE (not owner) ou MANY to ONE-->
	<#if !x.many && !x.fromTarget.many && !x.owner || !x.many && x.fromTarget.many>
	<#if sep == "0"><#assign sep="1">|</#if>${mylib.dbTable2ColumnName(x.alias)} ${database['identity']}<#if !x.nullable> NOT NULL</#if> (FK)\l
	</#if>
</#list>}"]
</@mylib.compress_single_line>
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
