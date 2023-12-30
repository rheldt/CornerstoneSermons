<!---
	Name:		update.cfm
	Author:		Ryan J. Heldt
	Created:	2016-10-17
	Purpose:	I update changes to sermon audio records.
--->

<cftry>
	<!--- Add to database --->
	<cfquery>
		UPDATE Sermons
        SET
			SermonSeriesID = <cfqueryparam value="#form.SermonSeriesID#" cfsqltype="cf_sql_integer" />,
			Name = <cfqueryparam value="#form.Name#" cfsqltype="cf_sql_varchar" />,
			SermonDate = <cfqueryparam value="#form.SermonDate#" cfsqltype="cf_sql_date" />,
			Length = <cfqueryparam value="#form.Length#" cfsqltype="cf_sql_varchar" />,
			IsActive = <cfqueryparam value="#form.IsActive#" cfsqltype="cf_sql_bit" />
        WHERE SermonID = <cfqueryparam value="#form.SermonID#" cfsqltype="cf_sql_integer" />
	</cfquery>

	<cflocation url="manage.cfm?result=success" addtoken="false" />

	<cfcatch>
		<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
		<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
				<title>Error Processing Request</title>
				<link href="https://fonts.googleapis.com/css?family=Roboto" rel="stylesheet" type="text/css" />
				<style>
					* {
						font-family: 'Roboto', sans-serif;
					}
					h1 {
						font-weight: normal;
					}
				</style>
			</head>
			<body>
				<h1>Error Processing Request</h1>
				<cfoutput>
					<p><strong>#cfcatch.message#</strong></p>
					<p>#cfcatch.detail#</p>
				</cfoutput>
			</body>
		</html>
		<cfabort />
	</cfcatch>
</cftry>

<cffunction name="createFilename" returntype="string">
    <cfargument name="text" type="string" required="true" />
    <cfset var strFilename = "" />
    <cfset var strExtension = "." & listLast(arguments.text,".") />
    <cfset var intCurrentCharacter = 0 />
	<cfset arguments.text = trim(lCase(arguments.text)) />
    <cfloop index="strIndex" from="1" to="#len(arguments.text)#">
        <cfset intCurrentCharacter = asc(mid(arguments.text,strIndex,1)) />
        <cfif intCurrentCharacter is 32 or intCurrentCharacter is 45 or intCurrentCharacter is 58 or intCurrentCharacter is 95>
            <!--- Space, Dash, Colon, or Underscore --->
            <cfset strFilename = strFilename & "-" />
        <cfelseif intCurrentCharacter gte 48 and intCurrentCharacter lte 57>
            <!--- Numbers 0-9 --->
            <cfset strFilename=strFilename & chr(intCurrentCharacter) />
        <cfelseif (intCurrentCharacter gte 97 and intCurrentCharacter lte 122)>
            <!--- Letters a-z --->
            <cfset strFilename=strFilename & chr(intCurrentCharacter) />
        <cfelse>
            <!--- Skip Everything Else--->
        </cfif>
    </cfloop>
    <cfreturn left(strFilename,50) & "_" & lCase(listFirst(createUUID(),"-")) />
</cffunction>