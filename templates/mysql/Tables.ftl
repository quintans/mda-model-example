<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
drop SCHEMA if exists ${groupkey} cascade;
CREATE SCHEMA ${groupkey};

<#list Entity as entity>
    <#include "Table.ftl">
</#list>