<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#-- first, the drops (Objects with the same name can be created). -->
<#list Migrate as entity>
<#if !entity.root>
<#if entity.drop || entity.old??>
	<#if entity.drop>
-- the entity "${entity.name}" was removed
DROP TABLE ${mylib.dbSchemaTableName(entity.alias)};
DROP SEQUENCE ${mylib.chop(mylib.dbUpperName(entity.alias), 4)}_GEN;
	<#elseif entity.old??>
		<#-- attributes -->
		<#list entity.attributes as attribute>
			<#if attribute.drop>
-- the attribute "${entity.old.name}.${attribute.name}" was removed
ALTER TABLE ${mylib.dbSchemaTableName(entity.old.alias)} DROP COLUMN ${mylib.dbColumnName(attribute.alias)};
			</#if> 
		</#list>
		<#-- associations -->
		<#list entity.associations as association>
			<#if association.drop>
				<#if association.many && association.fromTarget.many && association.owner>
-- drop tabela intermedia entre "${association.fromTarget.target.name}[${mylib.dbSchemaTableName(association.fromTarget.target.alias)}]"(owner) e "${association.target.name}[${mylib.dbSchemaTableName(association.target.alias)}]"
DROP TABLE ${mylib.dbSchemaTableName(association.alias)};
				<#elseif !association.many && association.fromTarget.many>
-- a association "${association.entity.name}.${association.alias}" foi removida 
ALTER TABLE ${mylib.dbSchemaTableName(association.entity.alias)} DROP COLUMN ${mylib.dbColumnName(association.alias)};
				</#if>
			</#if>
		</#list>
	</#if>
<#flush>
	</#if>
</#if>
</#list>
<#-- agora as criações e alterações -->
<#list Migrate as entity>
<#if !entity.root>
<#if entity.drop || entity.old??>
	<#if entity.old??>
		<#-- attributes -->
		<#list entity.attributes as attribute>
			<#if attribute.old??>
				<#if attribute.nullable??>
-- o atributo "${entity.old.name}.${attribute.old.name}" é agora<#if attribute.nullable> não</#if> obrigatório
ALTER TABLE ${mylib.dbSchemaTableName(entity.old.alias)} MODIFY ${mylib.dbColumnName(attribute.old.alias)} <#if !attribute.nullable> NOT</#if> NULL<#if !attribute.nullable> DEFAULT</#if>;
				</#if> 
				<#if attribute.lov?? || attribute.type??>
-- o tipo de "${entity.old.name}.${attribute.old.name}" foi mudado de "${attribute.old.type}" para "${attribute.type}"
<@compress single_line=true>
ALTER TABLE ${mylib.dbSchemaTableName(entity.old.alias)} MODIFY ${mylib.dbColumnName(attribute.old.alias)} 
					<#if attribute.lov??>
						<#if attribute.lov.numeric>
${database['integer']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>;
						<#else>
${database['string']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>;
						</#if>
					<#elseif attribute.type == 'string' || attribute.type == 'flags'>
${database['string']}(<#if attribute.length??>${attribute.length?c}<#else>255</#if>)<#if attribute.defaultValue??> DEFAULT ${attribute.defaultValue}</#if>;
					<#else>
						<#if !database[attribute.type]??>
					<@log out='UNDEFINED attribute: '+entity.name+'.'+attribute.name+':'+attribute.type/>
						</#if>
${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if><#if attribute.defaultValue??> DEFAULT ${attribute.defaultValue}</#if>;
					</#if>
</@compress>

				<#elseif attribute.length??>
-- o tamanho de "${entity.old.name}.${attribute.old.name}" foi alterado
<@compress single_line=true>
ALTER TABLE ${mylib.dbSchemaTableName(entity.old.alias)} MODIFY ${mylib.dbColumnName(attribute.old.alias)} 
${database[attribute.old.type]}<#if attribute.length??>(${attribute.length?c})</#if><#if attribute.old.defaultValue??> DEFAULT ${attribute.old.defaultValue}</#if>;
</@compress>

				</#if>
				<#-- tem que ser o ultimo, pois as outras modificacoes dependem do nome antigo --> 
				<#if attribute.alias??>
-- alteração do nome do atributo de "${entity.old.name}.${attribute.old.name}" para "${entity.old.name}.${attribute.name}"
ALTER TABLE ${mylib.dbSchemaTableName(entity.old.alias)} RENAME COLUMN ${mylib.dbColumnName(attribute.old.alias)} TO ${mylib.dbColumnName(attribute.alias)};
				</#if>
			<#elseif !attribute.drop> 
-- novo atributo "${entity.old.name}.${attribute.name}"
<@compress single_line=true>
ALTER TABLE ${mylib.dbSchemaTableName(entity.old.alias)} 
				<#if attribute.lov??>
					<#if attribute.lov.numeric>
ADD	${mylib.dbColumnName(attribute.alias)} ${database['integer']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>;
					<#else>
ADD ${mylib.dbColumnName(attribute.alias)} ${database['string']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>;
					</#if>
				<#elseif attribute.type == 'string' || attribute.type == 'flags'>
ADD ${mylib.dbColumnName(attribute.alias)} ${database['string']}(<#if attribute.length??>${attribute.length?c}<#else>255</#if>)<#if attribute.defaultValue??> DEFAULT ${attribute.defaultValue}</#if>;
				<#else>
					<#if !database[attribute.type]??>
				<@log out='UNDEFINED attribute: '+entity.name+'.'+attribute.name+':'+attribute.type/>
					</#if>
ADD ${mylib.dbColumnName(attribute.alias)} ${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if><#if attribute.defaultValue??> DEFAULT ${attribute.defaultValue}</#if>;
				</#if>
</@compress>

<#if !attribute.nullable>
-- coloque aqui as alterações pertinentes #--
-- #CUSTOM_BLK_START COLUMN_${entity.old.name?upper_case}_${attribute.name?upper_case}#
-- UPDATE ${mylib.dbSchemaTableName(entity.old.alias)} SET ${mylib.dbColumnName(attribute.alias)} = 
-- #CUSTOM_BLK_END#
<@compress single_line=true>
ALTER TABLE ${mylib.dbSchemaTableName(entity.old.alias)} 
				<#if attribute.lov??>
					<#if attribute.lov.numeric>
MODIFY	${mylib.dbColumnName(attribute.alias)} ${database['integer']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>;
					<#else>
MODIFY ${mylib.dbColumnName(attribute.alias)} ${database['string']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>;
					</#if>
				<#elseif attribute.type == 'string' || attribute.type == 'flags'>
MODIFY ${mylib.dbColumnName(attribute.alias)} ${database['string']}(<#if attribute.length??>${attribute.length?c}<#else>255</#if>) NOT NULL<#if attribute.defaultValue??> DEFAULT ${attribute.defaultValue}</#if>;
				<#else>
					<#if !database[attribute.type]??>
				<@log out='UNDEFINED attribute: '+entity.name+'.'+attribute.name+':'+attribute.type/>
					</#if>
MODIFY ${mylib.dbColumnName(attribute.alias)} ${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if> NOT NULL<#if attribute.defaultValue??> DEFAULT ${attribute.defaultValue}</#if>;
				</#if>
</@compress>

</#if>
			</#if> 
		</#list>
		<#if entity.alias??>
-- renaming "${entity.old.name}[${mylib.dbSchemaTableName(entity.old.alias)}]" entity table to "${entity.name}[${mylib.dbColumnName(entity.alias)}]"
ALTER TABLE ${mylib.dbSchemaTableName(entity.old.alias)} RENAME TO ${mylib.dbColumnName(entity.alias)};
		</#if>
		<#-- associations -->
		<#list entity.associations as association>
			<#if association.old??>
				<#-- associacao sem relacoes -->
				<#if association.alias??>
					<#if !association.old.many && association.old.fromTarget.many && !association.old.relations??>
-- target entity mudou de "${association.old.target.alias}" para "${association.alias}"
ALTER TABLE ${mylib.dbSchemaTableName(entity.alias)} RENAME COLUMN ${mylib.dbColumnName(association.old.alias)} TO ${mylib.dbColumnName(association.alias)};
					<#elseif association.old.owner>
						<#if association.old.many && association.old.fromTarget.many && 
							(association.old.many != association.many || association.old.fromTarget.many != association.fromTarget.many)>
<#-- it's many to many anymore -->
-- drop da tabela intermedia entre "${association.old.entity.name}"(owner) e "${association.old.target.name}"
DROP TABLE ${mylib.dbSchemaTableName(association.old.alias)};
						<#elseif association.old.many && association.old.fromTarget.many>
-- mudar nome da tabela intermedia entre "${association.old.entity.name}"(owner) e "${association.old.target.name}"
ALTER TABLE ${mylib.dbSchemaTableName(association.old.alias)} RENAME TO ${mylib.dbSchemaTableName(association.alias)};
						</#if>
					</#if>
				</#if>
			<#elseif !association.drop>
				<#if association.many && association.fromTarget.many && association.owner>
-- tabela intermedia entre "${association.entity.name}[${mylib.dbSchemaTableName(association.entity.alias)}]"(owner) e "${association.target.name}[${mylib.dbSchemaTableName(association.target.alias)}]"
CREATE TABLE ${mylib.dbSchemaTableName(association.alias)} (
	${mylib.dbTable2ColumnName(association.entity.alias)} ${database['identity']} NOT NULL
	,${mylib.dbTable2ColumnName(association.target.alias)} ${database['identity']} NOT NULL
);
				<#elseif !association.many && association.fromTarget.many>
-- nova association "${entity.old.name}.${association.name}"
ALTER TABLE ${mylib.dbSchemaTableName(association.entity.alias)} ADD ${mylib.dbColumnName(association.alias)} ${database['identity']};
-- #CUSTOM_BLK_START ASSOCIATION_${association.entity.name?upper_case}_${association.name?upper_case}#
-- UPDATE ${mylib.dbSchemaTableName(association.entity.alias)} SET ${mylib.dbColumnName(association.alias)} = 
-- #CUSTOM_BLK_END#
					<#if !association.nullable>
ALTER TABLE ${mylib.dbSchemaTableName(association.entity.alias)} MODIFY ${mylib.dbColumnName(association.alias)} NOT NULL;
					</#if>
				</#if>
			</#if>
		</#list>
	</#if>
<#flush>
	<#else>
-- nova entidade "${entity.name}"
<#include "Table.ftl">
CREATE SEQUENCE ${mylib.chop(mylib.dbUpperName(entity.alias), 4)}_GEN;
	</#if>
</#if>
</#list>