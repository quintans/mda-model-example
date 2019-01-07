<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#if !entity.readOnly>
<#if !entity.root>
<#assign tableName = mylib.dbSchemaTableName(entity.alias)>
CREATE TABLE `${tableName}` (
<#if entity.identity??>
	`${mylib.dbColumnName(entity.identity.alias)}` ${database['identity']} NOT NULL AUTO_INCREMENT,
	PRIMARY KEY(${mylib.dbColumnName(entity.identity.alias)}),
</#if>
<#list entity.attributes as attribute>
    <#if attribute.key>
    ${mylib.dbColumnName(attribute.alias)} ${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if> NOT NULL,
    PRIMARY KEY(${mylib.dbColumnName(attribute.alias)}),
	<#elseif attribute.deleter>
	`${mylib.dbColumnName(attribute.alias)}` ${database['integer']} NOT NULL,
	<#elseif attribute.lov??>
		<#if attribute.lov.numeric>
	`${mylib.dbColumnName(attribute.alias)}` ${database['integer']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>,
		<#else>
	`${mylib.dbColumnName(attribute.alias)}` ${database['string']}(<#if attribute.lov.keylen??>${attribute.lov.keylen?c}<#else>2</#if>)<#if !attribute.nullable> NOT NULL</#if>,
		</#if>
	<#elseif attribute.type == 'string'>
	`${mylib.dbColumnName(attribute.alias)}` ${database['string']}(<#if attribute.length??>${attribute.length?c}<#else>255</#if>)<#if !attribute.nullable> NOT NULL</#if>,
    <#elseif attribute.type == 'timestamp'>
    `${mylib.dbColumnName(attribute.alias)}` ${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if><#if attribute.nullable> NULL DEFAULT NULL<#else> NOT NULL</#if>,
	<#else>
		<#if !database[attribute.type]??>
	<@log out='UNDEFINED attribute: '+entity.name+'.'+attribute.name+':'+attribute.type/>
		</#if>
	`${mylib.dbColumnName(attribute.alias)}` ${database[attribute.type]}<#if attribute.length??>(${attribute.length?c})</#if><#if !attribute.nullable> NOT NULL</#if>,
	</#if>
</#list>
<#list entity.associations as association>
	<#-- associacao sem relacoes  && ( many to one || one to one (OWNER) )  -->
	<#if (!association.many && association.fromTarget.many || !association.many && !association.fromTarget.many && association.owner) && !association.relations?? 
	&& !entity.fetchAttribute(association.alias)??>
    	<#assign target=association.target>
        <#if target.identity??>
    `${mylib.dbColumnName(association.alias)}` ${database['identity'].type}<#if !association.nullable> NOT NULL</#if>,
        <#else>
            <#assign target=association.target.singleKey>
    `${mylib.dbColumnName(association.alias)}` ${database[target.type]}<#if target.length??>(${target.length?c})</#if><#if !association.nullable> NOT NULL</#if>,
	    </#if>
	</#if>
</#list>
<#if !entity.hasBehavior('AUDITLESS')>
	`CREATION` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	`MODIFICATION` TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
	`USER_CREATION` ${database['identity']} NOT NULL DEFAULT 0,
	`USER_MODIFICATION` ${database['identity']} NULL,
</#if>
    `VERSION` INTEGER NOT NULL DEFAULT 1
)
ENGINE=InnoDB 
DEFAULT CHARSET=utf8;

<#list entity.associations as association>
	<#if association.many && association.fromTarget.many && association.owner && !association.relations??>

-- tabela intermedia entre ${entity.name} e ${association.target.name}
CREATE TABLE `${mylib.dbSchemaTableName(association.alias)}` (
	`${mylib.dbTable2ColumnName(entity.alias)}` ${database['identity']} NOT NULL
	,`${mylib.dbTable2ColumnName(association.target.alias)}` ${database['identity']} NOT NULL
)
ENGINE=InnoDB 
DEFAULT CHARSET=utf8;
	</#if>
</#list>
</#if>
</#if>