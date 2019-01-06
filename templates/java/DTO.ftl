<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#if !dto.hasBehavior('TYPESCRIPT')>
/**
 * WARNING: Generated code! Changes will be overriden!
 * Generated by: java/DTO.ftl
 */
package ${subnamespace}.${dto.namespace};

<#if dto.comments??>
/**
 * ${dto.comments}
 */
</#if>
public class ${dto.name}
    <#if dto.parent??>
    extends ${subnamespace}.${dto.parent.namespace}.${dto.parent.name}
    <#elseif dto.hasBehavior('CRITERIA')>
    extends pt.efacec.toolkit.common.service.Criteria
    <#elseif dto.hasBehavior('SECURED')>
    extends pt.efacec.scadabt.common.gateway.Input
    <#elseif dto.hasBehavior('FAULT')>
    extends pt.efacec.scadabt.common.gateway.Fault
    <#else>
    implements java.io.Serializable
    </#if>{
    private static final long serialVersionUID = 1L;

    public ${dto.name}(){}

<#list dto.attributes as attribute>
    <#if attribute.comments??>
    /*
     * ${attribute.comments}
     */
    </#if>
    <#if attribute.lov??>
        <#assign type = subnamespace+'.'+attribute.lov.namespace+'.'+attribute.lov.name>
    <#elseif attribute.type?contains(".")>
        <#assign type = attribute.type> 
    <#else>
        <#assign type = mylib.mandatory(java[attribute.type], attribute.nullable)>
    </#if>
    <#if !attribute.single>
        <#assign type = type+'[]'>
    </#if>
    <#if attribute.comments??>//${attribute.comments}</#if>
<#if !attribute.key && attribute.defaultValue??>
    <#if attribute.lov??>
        <#assign defaultValue = type+'.'+attribute.defaultValue>
    <#else>
		<#if attribute.nullable>
       		<#assign defaultValue = 'new ' + type+'('+attribute.defaultValue+')'>
		<#else>
        	<#assign defaultValue = attribute.defaultValue>
	    </#if>
    </#if>
    <@mylib.beanAccessores type=type name=attribute.name defaultValue=defaultValue comments=attribute.comments/>
<#else>
    <@mylib.beanAccessores type=type name=attribute.name comments=attribute.comments/>
</#if>
    
</#list>
<#list dto.references as ref>
    <#if ref.comments??>
    /*
     * ${ref.comments}
     */
    </#if>
    <#if ref.model.lov??>
        <#assign type = subnamespace+'.'+ref.model.lov.namespace+'.'+ref.model.lov.name>
    <#else>
        <#assign type = subnamespace+'.'+ref.model.namespace+'.'+ref.model.name>
    </#if>
    <#if ref.paginate>
        <#assign type = 'pt.armis.toolkit.common.service.Page<' + type + '>'>
    </#if>
    <#if !ref.single>
        <#assign type = type+'[]'>
    </#if>        
<@mylib.beanAccessores type=type name=ref.name?uncap_first comments=ref.comments/>
    
</#list>
    @Override 
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("{");
<#if dto.parent??>
    <#list dto.parent.attributes as attribute>
        sb.append("<#if multi??>, </#if>${attribute.name}: ").append(${attribute.name});
        <#assign multi=1>
    </#list>
</#if>
<#if dto.attributes??>
    <#list dto.attributes as attribute>
        sb.append("<#if multi??>, </#if>${attribute.name}: ").append(${attribute.name});
        <#assign multi=1>
    </#list>
</#if>
<#list dto.references as ref>
    <#if !ref.paginate>
        sb.append("<#if multi??>, </#if>${ref.name}: ").append(${ref.name?uncap_first});
        <#assign multi=1>
    </#if>
</#list>
        sb.append("}");
        return sb.toString();
    }
}
</#if>