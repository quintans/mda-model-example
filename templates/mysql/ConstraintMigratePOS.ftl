<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
/*
Creating all constraints for the entire NEW model 
*/
<#list NewEntities as entity>
<#if !entity.readOnly>
<#if !entity.root>
<#include "Constraint.ftl">
</#if>
</#if>
</#list>