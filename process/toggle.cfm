<!---
	Name:		toggle.cfm
	Author:		Ryan J. Heldt
	Created:	2013-05-16
	Purpose:	I toggle sermon recordings.
--->

<cfparam name="url.SermonID" default="0" />

<cfquery name="qrySermon">
	UPDATE Sermons
	SET IsActive = CASE IsActive WHEN 0 THEN 1 ELSE 0 END
	WHERE SermonID = <cfqueryparam value="#val(url.SermonID)#" cfsqltype="cf_sql_integer" />
</cfquery>

<cflocation url="manage.cfm" addtoken="false" />