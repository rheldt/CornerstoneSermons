<!---
	Name:		edit.cfm
	Author:		Ryan J. Heldt
	Created:	2016-10-16
	Purpose:	I allow editing of sermon recordings.
--->

<cfif isDefined("url.SermonID")>
    <cfquery name="qrySermonSeries">
        SELECT SermonSeriesID, Name, IsCurrent
        FROM SermonSeries
        ORDER BY IsCurrent DESC, Name
    </cfquery>
    <cfquery name="qrySermon">
        SELECT SermonID, SermonSeriesID, Name, SermonDate, Length, Filename, IsActive
        FROM Sermons
        WHERE SermonID = <cfqueryparam value="#val(url.SermonID)#" cfsqltype="cf_sql_integer" />
    </cfquery>
    <cfif qrySermon.RecordCount neq 1>
        <cflocation url="manage.cfm" addtoken="false" />
    </cfif>
</cfif>

<cfset request.pagetitle="Edit Sermon Recording" />
<cfinclude template="_header.cfm" />

<h2>Edit Sermon Recording</h2>
<br />

<cfoutput>
    <form action="update.cfm" method="post" id="Update" class="row">
        <input type="hidden" name="SermonID" value="#htmlEditFormat(qrySermon.SermonID)#" />
        <div class="col-sm-6">
            <div class="form-group">
                <label>File:</label><br />
                <a href="../audio/#htmlEditFormat(qrySermon.Filename)#" target="_blank">#htmlEditFormat(qrySermon.Filename)#</a>
            </div>
            <div class="form-group">
                <label>Date:</label>
                <input type="text" name="SermonDate" id="SermonDate" value="#htmlEditFormat(dateFormat(qrySermon.SermonDate,"mm/dd/yyyy"))#" maxlength="10" size="12" class="form-control" />
            </div>
            <div class="form-group">
                <label>Series:</label>
                <select name="SermonSeriesID" id="SermonSeriesID" class="form-control">
                    <cfloop query="qrySermonSeries">
                        <option value="#qrySermonSeries.SermonSeriesID#" <cfif qrySermon.SermonSeriesID is qrySermonSeries.SermonSeriesID>selected="selected"</cfif>>#qrySermonSeries.Name#<cfif val(qrySermonSeries.IsCurrent)> (current)</cfif></option>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <label>Topic:</label>
                <input type="text" name="Name" id="Name" value="#htmlEditFormat(qrySermon.Name)#" maxlength="50" size="30" class="form-control" />
            </div>
            <div class="form-group">
                <label>Length:</label>
                <input type="text" name="Length" id="Length" value="#htmlEditFormat(qrySermon.Length)#" maxlength="10" size="12" class="form-control" />
            </div>
            <div class="form-group">
                <label>Status:</label>
                <select name="IsActive" id="IsActive" class="form-control">
                    <option value="1" <cfif qrySermon.IsActive>selected="selected"</cfif>>Available</option>
                    <option value="0" <cfif not qrySermon.IsActive>selected="selected"</cfif>>Hidden</option>
                </select>
            </div>
            <div class="form-group">
                <input type="submit" value="Save Changes" id="Submit" class="btn btn-primary" />
                <a href="manage.cfm" class="btn btn-default">Cancel</a>
            </div>
        </div>
    </form>
</cfoutput>

<script type="text/javascript">
    $(document).ready(function() {
        $("#SermonDate").datepicker();

        $("#Upload").submit(function (event) {
            if ($("#SermonDate").val().length == 0) {
                alert("Date is a required field.");
                return false;
            }
            if ($("#Name").val().length == 0) {
                alert("Topic is a required field.");
                return false;
            }
            if ($("#Length").val().length == 0) {
                alert("Length is a required field.");
                return false;
            }
            $("Submit").attr("disabled","disabled");
            $("Submit").attr("value","Processing...");
            return true;
        });
    });
</script>

<cfinclude template="_footer.cfm" />