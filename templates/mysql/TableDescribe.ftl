<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<!DOCTYPE html>
<html>
	<head>
        <meta charset="utf-8">
		<style>
		body {
			font-family: Arial, Helvetica, sans-serif;
		}
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
		.special {
		    color: lightgray;
		}		
		</style>        
	</head>
	<body>
<#list Entity as entity>
	<#if !entity.readOnly>
	<#if !entity.root>
		<h3>${mylib.dbSchemaTableName(entity.alias)} Table</h3>
		<table border="1">
			<tr><th>Column</th><th>Description</th><th>Type</th><th>Not Null</th></tr>
			<tr>
				<td><#if entity.identity??>${mylib.dbColumnName(entity.identity.alias)}<#else>ID</#if></td><td>record ID</td><td>${database['identity']}</td><td align="center">&check;</td>
			</tr>
		<#list entity.attributes as attribute>
			<tr>
			<#if attribute.lov??>
				<#if attribute.lov.numeric>
				<td>${mylib.dbColumnName(attribute.alias)}</td><td><#if attribute.comments??>${attribute.comments}</#if></td><td>${database['integer']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)</td><td align="center"><#if !attribute.nullable>&check;</#if></td>
				<#else>
				<td>${mylib.dbColumnName(attribute.alias)}</td><td><#if attribute.comments??>${attribute.comments}</#if></td><td>${database['string']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)</td><td align="center"><#if !attribute.nullable>&check;</#if></td>
				</#if>
			<#elseif attribute.type == 'string'>
				<td>${mylib.dbColumnName(attribute.alias)}</td><td><#if attribute.comments??>${attribute.comments}</#if></td><td>${database['string']}(<#if attribute.length??>${attribute.length?c}<#else>255</#if>)</td><td align="center"><#if !attribute.nullable>&check;</#if></td>
			<#else>
				<#if !database[attribute.type]??>
			<@log out='UNDEFINED attribute: '+entity.name+'.'+attribute.name+':'+attribute.type/>
				</#if>
				<td>${mylib.dbColumnName(attribute.alias)}</td><td><#if attribute.comments??>${attribute.comments}</#if></td><td>${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if></td><td align="center"><#if !attribute.nullable>&check;</#if></td>
			</#if>
			</tr>
		</#list>
		<#list entity.associations as association>
			<#-- association whithout relationships  && ( many to one || one to one (OWNER) )  -->
			<#if (!association.many && association.fromTarget.many || !association.many && !association.fromTarget.many && association.owner) && !association.relations??>
			<tr><td>${mylib.dbColumnName(association.alias)}</td><td>Foreign Key para ${mylib.dbColumnName(association.target.alias)}</td><td>${database['identity'].type}</td><td align="center"><#if !association.nullable>&check;</#if></td></tr>
			</#if>
		</#list>
        <#if !entity.hasBehavior('AUDITLESS')>			
			<tr class="special"><td>VERSION</td><td>For Optimistic Locking</td><td>INTEGER</td><td align="center">&check;</td></tr>
			<tr class="special"><td>USER_CREATION</td><td>user that created this record</td><td>${database['identity']}</td><td></td></tr>
			<tr class="special"><td>CREATION</td><td>creation timestamp</td><td>TIMESTAMP</td><td></td></tr>
			<tr class="special"><td>USER_MODIFICATION</td><td></td><td>${database['identity']}</td><td></td></tr>
			<tr class="special"><td>MODIFICATION</td><td>modification timestamp</td><td>TIMESTAMP</td><td></td></tr>
		</#if>
		</table>
		<#list entity.associations as association>
			<#if association.many && association.fromTarget.many && association.owner && !association.relations??>
		
		<h3>Tabela ${mylib.dbSchemaTableName(association.alias)}</h3>
		<table border="1">
			<tr><th>Nome coluna</th><th>Descrição</th><th>Tipo de dados</th><td>Obrig.?</th></tr>
			<tr><td>${mylib.dbTable2ColumnName(entity.alias)}</td><td>Foreign Key para ${mylib.dbTable2ColumnName(entity.alias)}</td><td>${database['identity']}</td><td align="center">&check;</td></tr>
			<tr><td>${mylib.dbTable2ColumnName(association.target.alias)}</td><td>Foreign Key para ${mylib.dbTable2ColumnName(association.target.alias)}</td><td>${database['identity']}</td><td align="center">&check;</td></tr>
		</table>
			</#if>
		</#list>
	
	</#if>
	</#if>
</#list>
	</body>
</html>