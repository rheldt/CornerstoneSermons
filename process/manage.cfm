<!---
	Name:		manage.cfm
	Author:		Ryan J. Heldt
	Created:	2016-10-16
	Purpose:	I allow management of the sermon recordings.
--->

<cfquery name="qrySermons">
	SELECT TOP 50 S.SermonID, S.Name, SS.Name AS SeriesName, S.SermonDate, S.Length, S.Filename, S.IsActive, S.DateCreated
	FROM Sermons S
		INNER JOIN SermonSeries SS ON S.SermonSeriesID = SS.SermonSeriesID
	ORDER BY S.SermonDate DESC
</cfquery>

<cfset request.pagetitle="Manage Sermon Recordings" />
<cfinclude template="_header.cfm" />

<h2>Manage Sermon Recordings</h2>
<br />

<cfif structKeyExists(url,"result") and url.result is "success">
    <div class="alert alert-success" role="alert">
        The sermon recording has been updated.
    </div>
</cfif>

<cfif structKeyExists(url,"result") and url.result is "delete">
    <div class="alert alert-danger" role="alert">
        The sermon recording has been deleted.
    </div>
</cfif>

<cfif qrySermons.RecordCount>
    <table class="table table-hover table-condensed">
        <tr>
            <th>Date</th>
            <th>Topic</th>
            <th>Length</th>
            <th>Series</th>
            <th>File</th>
            <th style="text-align: center;">Actions</th>
        </tr>
        <cfoutput query="qrySermons">
            <tr>
                <td>#dateFormat(qrySermons.SermonDate,"mm/dd/yyyy")#</td>
                <td>#htmlEditFormat(qrySermons.Name)#</td>
                <td>#htmlEditFormat(qrySermons.Length)#</td>
                <td>#htmlEditFormat(qrySermons.SeriesName)#</td>
                <td><a href="../audio/#htmlEditFormat(qrySermons.Filename)#" target="_blank" title="#htmlEditFormat(qrySermons.Filename)#">Download</a></td>
                <td style="text-align: center; white-space: nowrap;">
                    <!--- <a href="toggle.cfm?SermonID=#qrySermons.SermonID#" class="btn btn-sm btn-default" title="Make this Recording <cfif qrySermons.IsActive>Inactive<cfelse>Active</cfif>"><em class="fa fa-<cfif qrySermons.IsActive>check-square-o <cfelse>square-o</cfif>"></em></a> --->
                    <a href="edit.cfm?SermonID=#qrySermons.SermonID#" class="btn btn-sm btn-success" title="Edit this Recording"><em class="fa fa-pencil"></em></a>
                    <a href="delete.cfm?SermonID=#qrySermons.SermonID#" class="btn btn-sm btn-danger" title="Delete this Recording" onclick="return confirm('Are you sure you wish to delete the recording \'#jsStringFormat("#qrySermons.Name#")#?\'');"><em class="fa fa-trash"></em></a>
                </td>
            </tr>
        </cfoutput>
    </table>
<cfelse>
    <p>Sorry, there are no sermon recordings in the system.</p>
</cfif>

<cfinclude template="_footer.cfm" />