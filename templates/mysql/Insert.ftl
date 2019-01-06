<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#if (Role?size > 0)>
	<#assign cnt = 1>
	<#list Role as role>
INSERT INTO `ROLE` (`ID`, `NAME`, `VERSION`, `CREATION`, `USER_CREATION`) VALUES(${cnt}, 'ROLE_${role.name?upper_case}', 1, NOW(), 0);
		<#assign cnt = cnt + 1>
	</#list>
</#if>