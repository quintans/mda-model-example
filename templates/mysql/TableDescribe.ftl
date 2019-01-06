<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<!DOCTYPE html>
<html>
	<head>
        <meta charset="utf-8">
	</head>
	<body>
<#list Entity as entity>
	<#if !entity.readOnly>
	<#if !entity.root>
		<h3>Tabela ${mylib.dbSchemaTableName(entity.alias)}</h3>
		<table border="1">
			<tr><th>Nome coluna</th><th>Descrição</th><th>Tipo de dados</th><td>Obrig.?</th></tr>
			<tr>
				<td><#if entity.identity??>${mylib.dbColumnName(entity.identity.alias)}<#else>ID</#if></td><td>record ID</td><td>${database['identity']}</td><td>X</td>
			</tr>
		<#list entity.attributes as attribute>
			<tr>
			<#if attribute.lov??>
				<#if attribute.lov.numeric>
				<td>${mylib.dbColumnName(attribute.alias)}</td><td><#if attribute.comments??>${attribute.comments}</#if></td><td>${database['integer']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)</td><td><#if !attribute.nullable>X</#if></td>
				<#else>
				<td>${mylib.dbColumnName(attribute.alias)}</td><td><#if attribute.comments??>${attribute.comments}</#if></td><td>${database['string']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)</td><td><#if !attribute.nullable>X</#if></td>
				</#if>
			<#elseif attribute.type == 'string'>
				<td>${mylib.dbColumnName(attribute.alias)}</td><td><#if attribute.comments??>${attribute.comments}</#if></td><td>${database['string']}(<#if attribute.length??>${attribute.length?c}<#else>255</#if>)</td><td><#if !attribute.nullable>X</#if></td>
			<#else>
				<#if !database[attribute.type]??>
			<@log out='UNDEFINED attribute: '+entity.name+'.'+attribute.name+':'+attribute.type/>
				</#if>
				<td>${mylib.dbColumnName(attribute.alias)}</td><td><#if attribute.comments??>${attribute.comments}</#if></td><td>${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if></td><td><#if !attribute.nullable>X</#if></td>
			</#if>
			</tr>
		</#list>
		<#list entity.associations as association>
			<#-- associacao sem relacoes  && ( many to one || one to one (OWNER) )  -->
			<#if (!association.many && association.fromTarget.many || !association.many && !association.fromTarget.many && association.owner) && !association.relations??>
			<tr><td>${mylib.dbColumnName(association.alias)}</td><td>Foreign Key para ${mylib.dbColumnName(association.target.alias)}</td><td>${database['identity'].type}</td><td><#if !association.nullable>X</#if></td></tr>
			</#if>
		</#list>
        <#if !entity.hasBehavior('AUDITLESS')>			
			<tr><td>VERSION</td><td>For Optimistic Locking</td><td>INTEGER</td><td>X</td></tr>
			<tr><td>USER_CREATION</td><td>Utilizador que criou o registo</td><td>${database['identity']}</td><td></td></tr>
			<tr><td>CREATION</td><td>Data/hora de criação do registo</td><td>TIMESTAMP</td><td></td></tr>
			<tr><td>USER_MODIFICATION</td><td>Utilizador que alterou o registo pela última vez</td><td>${database['identity']}</td><td></td></tr>
			<tr><td>MODIFICATION</td><td>Data/hora da última alteração ao registo</td><td>TIMESTAMP</td><td></td></tr>
		</#if>
		</table>
		<#list entity.associations as association>
			<#if association.many && association.fromTarget.many && association.owner && !association.relations??>
		
		<h3>Tabela ${mylib.dbSchemaTableName(association.alias)}</h3>
		<table border="1">
			<tr><th>Nome coluna</th><th>Descrição</th><th>Tipo de dados</th><td>Obrig.?</th></tr>
			<tr><td>${mylib.dbTable2ColumnName(entity.alias)}</td><td>Foreign Key para ${mylib.dbTable2ColumnName(entity.alias)}</td><td>${database['identity']}</td><td>X</td></tr>
			<tr><td>${mylib.dbTable2ColumnName(association.target.alias)}</td><td>Foreign Key para ${mylib.dbTable2ColumnName(association.target.alias)}</td><td>${database['identity']}</td><td>X</td></tr>
		</table>
			</#if>
		</#list>
	
	</#if>
	</#if>
</#list>
	</body>
</html>