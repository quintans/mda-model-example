<#ftl encoding="UTF-8">
drop SCHEMA if exists ${groupkey} cascade;
CREATE SCHEMA ${groupkey};

<#list Group as entity>
    <#include "Table.ftl">
</#list>