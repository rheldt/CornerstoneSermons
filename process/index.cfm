<!---
	Name:		process.cfm
	Author:		Ryan J. Heldt
	Created:	2016-10-16
	Purpose:	I allow sermons recording uploads.
--->

<cfquery name="qrySermonSeries">
	SELECT SermonSeriesID, Name, IsCurrent
	FROM SermonSeries
	ORDER BY IsCurrent DESC, Name
</cfquery>

<cfset request.pagetitle="Upload Sermon Recording" />
<cfinclude template="_header.cfm" />

<h2>Upload Sermon Recording</h2>
<br />

<cfif structKeyExists(url,"result") and url.result is "success">
    <div class="alert alert-success" role="alert">
        The sermon recording has been uploaded.
    </div>
</cfif>

<form action="process.cfm?requesttimeout=1000" method="post" enctype="multipart/form-data" id="Upload" class="row">
    <div class="col-sm-6">
        <div class="form-group">
            <label class="btn btn-default btn-file">
                Select File
                <input type="file" name="Filename" id="Filename" />
            </label>
            <small id="SelectedFilename">MP3 Audio</small>
        </div>
        <div class="form-group">
            <label>Date:</label>
            <input type="text" name="SermonDate" id="SermonDate" maxlength="10" size="12" class="form-control" />
            <small>mm/dd/yyyy</small>
        </div>
        <div class="form-group">
            <label>Series:</label>
            <select name="SermonSeriesID" id="SermonSeriesID" class="form-control">
                <cfoutput query="qrySermonSeries">
                    <option value="#qrySermonSeries.SermonSeriesID#">#qrySermonSeries.Name#<cfif val(qrySermonSeries.IsCurrent)> (current)</cfif></option>
                </cfoutput>
            </select>
        </div>
        <div class="form-group">
            <label>Topic:</label>
            <input type="text" name="Name" id="Name" maxlength="50" size="30" class="form-control" />
            <small>Bookname 1:23-45</small>
        </div>
        <div class="form-group">
            <label>Length:</label>
            <input type="text" name="Length" id="Length" maxlength="10" size="12" class="form-control" />
            <small>mm:ss</small>
        </div>
        <div class="form-group">
            <input type="submit" value="Upload Recording" id="Submit" class="btn btn-primary" />
        </div>
    </div>
    <div class="col-sm-2"></div>
    <div class="col-sm-4">
        <img src="../images/cover_2021.jpg" alt="Cover Art" class="img-responsive" />
    </div>
</form>

<script type="text/javascript">
    $(document).ready(function() {
        $("#SermonDate").datepicker();
        
        $("#Filename").on("change", function() { 
            $("#SelectedFilename").html($("#Filename").val().replace("C:\\fakepath\\",""));
        });

        $("#Upload").submit(function (event) {
            if ($("#Filename").val().length == 0) {
                alert("File is a required field.");
                return false;
            }
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