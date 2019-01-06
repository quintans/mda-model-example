<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<!DOCTYPE html>
<html>
	<head>
        <meta charset="utf-8">
		<style>
		table {
		    border-collapse: collapse;
		}
		
		table, td, th {
		    border: 1px solid black;
		}
		
		th {
		    text-align: left;
		    color: white;
		    background-color: gray;
		}		
		</style>        
	</head>
	<body>
<#list Service as service>
		<h3>Service ${service.name}</h3>
	<#if service.comments??>
		<p>${service.comments?cap_first?replace(".", ".<br>\n")}</p>
	</#if>
		<table>
			<tr><th>Name</th><th>Roles</th><th>Description</th></tr>
	<#list service.operations as operation>
			<tr>
				<td>${operation.name}</td><td><#list operation.roles as role><#if (role_index > 0)>, </#if>${role.name?upper_case}</#list></td><td><#if operation.comments??>${operation.comments?cap_first}</#if></td>
			</tr>
	</#list>
		</table>
		<br>
</#list>
	</body>
</html>