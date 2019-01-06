<#ftl encoding="UTF-8">
<#import "/mylib.ftl" as mylib>
<#if !entity.readOnly>
<#if !entity.root>
<#list entity.attributes as attrs>
    <#if attrs.lov??>
<#--has lovs -->
    <#assign tableName=mylib.dbSchemaTableName(entity.alias)>
-- CHECK CONSTRAINT TRIGGERS FOR ${tableName}
DROP TRIGGER IF EXISTS `T_BI_${tableName}`;
DROP TRIGGER IF EXISTS `T_BU_${tableName}`;

    <#assign triggers = ["`T_BI_"+tableName+"` BEFORE INSERT", "`T_BU_"+tableName+"` BEFORE UPDATE"]>
    <#list triggers as trigger>
DELIMITER $$
CREATE TRIGGER ${trigger} ON `${tableName}`
FOR EACH ROW
BEGIN
        <#assign values=''>
        <#list entity.attributes as attribute>
        <#if attribute.lov??>
            <#assign condition=''>
            <#if attribute.lov.numeric>
                <#assign condition="NEW.`"+mylib.dbColumnName(attribute.alias) + "` < 0 OR NEW.`"+mylib.dbColumnName(attribute.alias) + "` > "+(attribute.lov.items?size-1)>
                <#assign values="> 0 AND < " + (attribute.lov.items?size-1)>
            <#else>
                <#list attribute.lov.items as item>
                    <#if condition != ''>
                        <#assign condition=condition + " AND ">
                        <#assign values=values+', '>
                    </#if>
                    <#if item.key == ''>
                        <#assign key=item.name>
                    <#else>
                        <#assign key=item.key>
                    </#if>
                    <#assign condition=condition + "NEW.`"+mylib.dbColumnName(attribute.alias) + "` <> '"+key+"'">
                    <#assign values=values+key>
                </#list>
            </#if>
    IF ${condition} THEN
    set @msg = CONCAT('check constraint - invalid value on ${tableName}.${mylib.dbColumnName(attribute.alias)}: ', NEW.`${mylib.dbColumnName(attribute.alias)}`, '\nValid values: ${values}');
    SIGNAL SQLSTATE '12345'
        SET MESSAGE_TEXT = @msg;
    END IF;

        </#if>
        </#list>
END$$   
DELIMITER ;

    </#list>
        <#break>
    </#if>
</#list>

</#if>
</#if>