<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
drop SCHEMA if exists ${project} cascade;
CREATE SCHEMA ${project};

<#list Entity as entity>
    <#include "Table.ftl">
</#list>