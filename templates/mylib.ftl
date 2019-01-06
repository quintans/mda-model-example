<#macro exp seq sep=', '>
<@compress single_line=true>
<#list seq as s><#nested s, s_index><#if s_has_next>${sep}</#if></#list>
</@compress>
</#macro>

<#-- see: http://stackoverflow.com/questions/21102122/freemarker-compress-single-line-without-spaces -->
<#macro compress_single_line>
    <#local captured><#nested></#local>
${ captured?replace("^\\s+|\\s+$|\\n|\\r", "", "rm") }
</#macro>

<#macro beanAccessores type name defaultValue='-' comments=''>
	protected ${type} ${name}<#if defaultValue!='-'> = ${defaultValue}</#if>;

    <#if comments??>
    /**
     * getter for ${name}.<br>
     * ${comments?cap_first}
     */
    </#if>
	public ${type} get${name?cap_first}() {
		return ${name};
	}

    <#if comments??>
    /**
     * setter for ${name}.<br>
     * ${comments?cap_first}
     */
    </#if>
	public void set${name?cap_first}(${type} ${name}) {
		this.${name} = ${name};
	}
</#macro>

<#function concat original fragment separator>
	<#if original != "">
		<#return (original + separator + fragment)>
	<#else>
		<#return fragment>
	</#if>
</#function>

<#function mandatory mapping nullable>
    <#if nullable || !mapping.type??>
        <#return mapping.domain>
    <#else>
        <#return mapping.type>
    </#if>
</#function>

<#function dbUpperName name>
	<#if name??>
		<#local result = name?substring(0, 1)>
        <#local upper = result != result?lower_case>
		<#local x = name?length>
		<#list 2..x as i>
		  <#local letter = name?substring(i-1, i)>
		  <#if letter != letter?lower_case>
		      <#if !upper>
    		  	<#local result = result + "_">;
    		  	<#local upper = true>
    		  </#if>
    	  <#else>
              <#local upper = false>
		  </#if>
		  <#local result = result + letter>;
		</#list>
		<#return result?upper_case>
	</#if>
</#function>

<#function dbSchemaName name>
	<#if name??>
		<#local result = name?split(".")>
		<#local result = dbUpperName(result[0])>
		<#--return dbNameHash(result, 14)-->
		<#return chop(result, 30)>
	</#if>
</#function>

<#function pixWidth chars>
		<#return (chars * 10 + 10)?c>
</#function>

<#function pixHeight chars>
		<#return (chars * 22)?c>
</#function>

<#function dbColumnName name>
	<#if name??>
		<#local result = dbUpperName(name)>
		<#--return dbNameHash(result, 28)-->
		<#return chop(result, 30)>
	</#if>
</#function>

<#function dbSchemaTableName name>
	<#if name??>
		<#local result = name?split(".")>
		<#if (result?size > 1)>
			<#--assign sch = dbNameHash(dbUpperName(result[0]), 10)-->
			<#assign sch = chop(dbUpperName(result[0]), 28)>
			<#--assign tab = dbNameHash(dbUpperName(result[1]), 28)-->
			<#assign tab = chop(dbUpperName(result[1]), 30)>
			<#return sch+'.'+tab>
		<#else>
			<#--return dbNameHash(dbUpperName(result[0]), 28)-->
			<#return chop(dbUpperName(result[0]), 30)>
		</#if>
	</#if>
</#function>

<#function dbTable2ColumnName name>
	<#if name??>
		<#local result = name>
		<#list name?split(".") as x>
			<#local result = x>
		</#list> 
		<#local result = dbUpperName(result)>
		<#--return dbNameHash(result, 28)-->
		<#return chop(result, 30)>
	</#if>
</#function>

<#function boolDefault value>
	<#if value == 'true'>
		<#return 'true'>
	<#else> 
		<#return 'false'>
	</#if>
</#function>

<#function abs value>
	<#if (value < 0)>
		<#return -value>
	<#else> 
		<#return value>
	</#if>
</#function>

<#function wraplist test text>
	<#if test>
		<#return "java.util.List<" + text + ">">
	<#else> 
		<#return text>
	</#if>
</#function>

<#function dbName text>
	<#return chop(text, 30)>
</#function>

<#function chop text size>
	<#if (text?length > size)>
		<#return text?substring(0, size)>
	<#else> 
		<#return text>
	</#if>
</#function>
