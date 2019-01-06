<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
digraph G {
        fontname = "Sans Not-Rotated"
        fontsize = 8
        pad = 0.5
        
        graph [splines=ortho overlap=false]

        node [fontname="Sans Not-Rotated" fontsize=8 shape="record" style=filled fillcolor=lightyellow color=black]

        edge [color=gray52 fontname = "Sans Not-Rotated" fontsize=8 labeldistance=1]
<#list Entity as entity>
<#if !entity.root>

        "${entity.name}" [label="{&lt;&lt;${entity.stereotype}&gt;&gt;\n${entity.name}|<#list entity.attributes as x>+ ${x.name} : ${x.type} <#if x.nullable>[0..1]</#if>\l</#list>|<#list entity.queries as query>@ ${query.name}()\l</#list>}"]
<#--        "${entity.name}" [label="{${entity.name}|<#list entity.attributes as x>+ ${x.name} : ${x.type}\l</#list>|<#list entity.queries as query>@ ${query.name}(<@mylib.exp seq=query.parameters; x>${x.name} : ${x.type}<#if !x.single>[]</#if></@mylib.exp>) : ${query.type}<#if !query.single>[]</#if>\l</#list>}"]-->
</#if>
</#list>
<#list Entity as entity>
<#if !entity.root>
	<#list entity.associations as association>
		<#assign nilTail = "0">
		<#assign nilHead = "0">
		<#if !association.nullable><#assign nilHead="1"></#if>
		<#if !association.fromTarget.nullable><#assign nilTail="1"></#if>
		<#assign cascade = "o">
		<#if association.cascade><#assign cascade=""></#if>		
		
		<#-- one to one -->
		<#if !association.many && !association.fromTarget.many && association.owner>
        edge [arrowhead="none" arrowtail="${cascade}diamond" taillabel="[${nilTail}..1] ${association.name}" headlabel="[${nilHead}..*] ${association.fromTarget.name}"]                
        "${entity.name}" -> "{association.target.name}"
		<#-- one to many -->
		<#elseif association.many && !association.fromTarget.many>
        edge [arrowhead="none" arrowtail="${cascade}diamond" taillabel="[${nilTail}..1] ${association.name}" headlabel="[${nilHead}..*] ${association.fromTarget.name}"]                
        "${entity.name}" -> "${association.target.name}"
		<#-- many to many -->
		<#elseif association.many && association.fromTarget.many && association.owner>
        edge [arrowhead="none" taillabel="[${nilTail}..*] ${association.name}" headlabel="[${nilHead}..*] ${association.fromTarget.name}"]                
        "${entity.name}" -> "${association.target.name}"
		</#if>
	</#list>
</#if>
</#list>
}
