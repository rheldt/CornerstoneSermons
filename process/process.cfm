<!---
	Name:		process.cfm
	Author:		Ryan J. Heldt
	Created:	2013-05-15
	Purpose:	I process sermon audio uploads.
--->

<cftry>
	<!--- Upload file --->
	<!--- accept="audio/mpeg,audio/mpeg3,audio/x-mpeg-3" --->
	<cffile action="upload"
		filefield="form.Filename"
		destination="#variables.directory#"
		nameconflict="makeunique" />

	<!--- Rename file --->
	<cfset destination = "#dateFormat(form.SermonDate,"yyyymmdd")#_#createFilename(form.Name)#.#cffile.ServerFileExt#" />
	<cffile action="rename"
	    source="#cffile.ServerDirectory#\#cffile.ServerFile#"
	    destination="#cffile.ServerDirectory#\#destination#" />

	<!--- Add to database --->
	<cfquery>
		INSERT INTO Sermons (
			SermonSeriesID,
			Name,
			SermonDate,
			Length,
			Filename,
			IsActive,
			DateCreated
		)
		VALUES (
			<cfqueryparam value="#form.SermonSeriesID#" cfsqltype="cf_sql_integer" />,
			<cfqueryparam value="#form.Name#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#form.SermonDate#" cfsqltype="cf_sql_date" />,
			<cfqueryparam value="#form.Length#" cfsqltype="cf_sql_varchar" />,
			<cfqueryparam value="#destination#" cfsqltype="cf_sql_varchar" />,
			1,
			GETDATE()
		)
	</cfquery>

	<cflocation url="index.cfm?result=success" addtoken="false" />

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