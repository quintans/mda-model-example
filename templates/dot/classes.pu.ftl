<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
@startuml
<#list LOV as lov>
enum ${lov.name} {
<#list lov.items as item>
    ${item.name}
</#list>    
}
</#list>    

<#list Entity as entity>
<#if !entity.root>
class ${entity.name} {
    <#if entity.identity??>
        ${entity.identity.name} ${entity.identity.type} <&key>
    </#if>
    <#list entity.attributes as attr>
        <#assign uniqueL="">
        <#assign uniqueR="">
        <#if attr.key>
            <#assign uniqueR=" <&key>">
        <#elseif attr.unique>
            <#assign uniqueR=" <img:key.png>">
        <#else>
            <#list entity.uniqueGroups as uniqueGroup>
                <#assign params = ''>
                <#list uniqueGroup.members as member>
                    <#if member.name == attr.name>
                        <#assign uniqueL="<u>">
                        <#assign uniqueR="</u> <img:key_plus.png>">
                    </#if>
                </#list>
            </#list>
        </#if>
    ${uniqueL}<b>${attr.name}</b>${uniqueR} : <#if attr.lov??>${attr.lov.name}<#else>${attr.type}</#if><#if attr.nullable>?</#if>
    </#list>
<#if !entity.hasBehavior('AUDITLESS')>
    userCreationId : long
    userModificationId : long?
    creation : timestamp
    modification : timestamp?
</#if>
<#if (entity.associations?size > 0)>
    ..
    <#list entity.associations as association>
    <#-- associacao sem relacoes  && ( many to one || one to one (OWNER) )  -->
    <#if (!association.many && association.fromTarget.many || !association.many && !association.fromTarget.many && association.owner) && !association.relations??>
        <#if entity.fetchAttribute(association.alias)??>
            <#assign alias = entity.fetchAttribute(association.alias)>
    ${alias.name} : ${alias.type}<#if alias.nullable>?</#if>
        <#else>
            <#assign target=association.target>
            <#if target.singleKey??>
    ${association.name}Fk : ${target.singleKey.type}<#if association.nullable>?</#if>
            </#if>
        </#if>
    </#if>
    </#list>
    --
</#if>
<#list entity.operations as operation>
    ${operation.name}()
</#list>
}

</#if>
</#list>
<#list Entity as entity>
<#if !entity.root>
	<#list entity.associations as association>
		<#assign nilTail = "0..">
		<#assign nilHead = "0..">
		<#if !association.nullable><#assign nilHead=""></#if>
		<#if !association.fromTarget.nullable><#assign nilTail=""></#if>
		<#assign cascade = "o">
		<#if association.cascade><#assign cascade=""></#if>		
		<#-- one to one -->
		<#if !association.many && !association.fromTarget.many && association.owner>
${entity.name} "${nilTail}1" --> "${nilHead}1" ${association.target.name}: ${association.name}
		<#-- one to many -->
		<#elseif association.many && !association.fromTarget.many>
${entity.name} "${nilTail}1" -- "${nilHead}*" ${association.target.name}: ${association.name}
		<#-- many to many -->
		<#elseif association.many && association.fromTarget.many && association.owner>
${entity.name} "${nilHead}*" -- "${nilHead}*" ${association.target.name}: ${association.name}
		</#if>
	</#list>
</#if>
</#list>
@endum
