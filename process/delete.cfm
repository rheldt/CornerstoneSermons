<!---
	Name:		delete.cfm
	Author:		Ryan J. Heldt
	Created:	2013-05-16
	Purpose:	I delete sermon recordings.
--->

<cfparam name="url.SermonID" default="0" />

<cfquery name="qrySermon">
	SELECT Filename
	FROM Sermons
	WHERE SermonID = <cfqueryparam value="#val(url.SermonID)#" cfsqltype="cf_sql_integer" />
</cfquery>

<cfif qrySermon.RecordCount>
	<cfif fileExists(variables.directory & qrySermon.Filename)>
		<cfset fileDelete(variables.directory & qrySermon.Filename) />
	</cfif>
	<cfquery name="qrySermon">
		DELETE FROM Sermons
		WHERE SermonID = <cfqueryparam value="#val(url.SermonID)#" cfsqltype="cf_sql_integer" />
	</cfquery>
</cfif>

<cflocation url="manage.cfm?result=delete" addtoken="false" />