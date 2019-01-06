<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
digraph G {
        fontname = "Sans Not-Rotated"
        fontsize = 8
        pad = 0.5
        
        graph [splines=true overlap=false]
        node [fontname="Sans Not-Rotated" fontsize=12 shape="record" style=filled fillcolor=lightyellow color=black]
        edge [dir=both]
<#list Entity as entity>
<#if !entity.root>
        "${entity.name}" [label="{${entity.name}<#if (entity.operations?size > 0)>|<#list entity.operations as op>@ ${op.name}<#if op_has_next>\l</#if></#list></#if>}"]
</#if>
</#list>
<#list Entity as entity>
<#if !entity.root>
	<#list entity.associations as association>
		<#-- one to one -->
		<#if !association.many && !association.fromTarget.many && association.owner>
			<#assign arrowhead = "empty">
			<#assign arrowtail = "empty">
			<#if !association.nullable><#assign arrowhead="normal"></#if>
			<#if !association.fromTarget.nullable><#assign arrowtail="normal"></#if>
        edge [arrowhead="${arrowhead}" arrowtail="${arrowtail}"]                
        "${entity.name}" -> "${association.target.name}"
		<#-- many to one -->
		<#elseif !association.many && association.fromTarget.many>
			<#assign arrowhead = "empty">
			<#assign arrowtail = "odot">
			<#if !association.nullable><#assign arrowhead="normal"></#if>
			<#if !association.fromTarget.nullable><#assign arrowtail="dot"></#if>
        edge [arrowhead="${arrowhead}" arrowtail="${arrowtail}"]                
        "${entity.name}" -> "${association.target.name}"
		<#-- many to many -->
		<#elseif association.many && association.fromTarget.many && association.owner>
			<#assign arrowhead = "odot">
			<#assign arrowtail = "odot">
			<#if !association.nullable><#assign arrowhead="dot"></#if>
			<#if !association.fromTarget.nullable><#assign arrowtail="dot"></#if>
        edge [arrowhead="${arrowhead}" arrowtail="${arrowtail}"]                
        "${entity.name}" -> "${association.target.name}"
		</#if>
	</#list>
</#if>
</#list>
}
