<!---
	Name:		sync.cfm
	Author:		Ryan J. Heldt
	Created:	2016-10-16
	Purpose:	I manage the sync of sermons with WordPress.
--->

<cffunction name="generateSlug" output="false" returnType="string">
    <cfargument name="str" default="">
    <cfargument name="spacer" default="-">
    <cfset var ret= ListFirst(arguments.str,":,(") />
    <cfset ret = replace(ret,"'", "", "all")>
    <cfset ret = trim(ReReplaceNoCase(ret, "<[^>]*>", "", "ALL"))>
    <cfset ret = ReplaceList(ret, "À,Á,Â,Ã,Ä,Å,Æ,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,Ø,Ù,Ú,Û,Ü,Ý,à,á,â,ã,ä,å,æ,è,é,ê,ë,ì,í,î,ï,ñ,ò,ó,ô,õ,ö,ø,ù,ú,û,ü,ý,&nbsp;,&amp;", "A,A,A,A,A,A,AE,E,E,E,E,I,I,I,I,D,N,O,O,O,O,O,0,U,U,U,U,Y,a,a,a,a,a,a,ae,e,e,e,e,i,i,i,i,n,o,o,o,o,o,0,u,u,u,u,y, , ")>
    <cfset ret = trim(rereplace(ret, "[[:punct:]]"," ","all"))>
    <cfset ret = rereplace(ret, "[[:space:]]+","!","all")>
    <cfset ret = ReReplace(ret, "[^a-zA-Z0-9!]", "", "ALL")>
    <cfset ret = trim(rereplace(ret, "!+", arguments.Spacer, "all"))>
    <cfreturn lcase(ret)>
</cffunction>

<cfset request.pagetitle="WordPress Sync" />
<cfinclude template="_header.cfm" />

<h2>WordPress Sync</h2>
<br />

<h3>Sermon Series</h3>
<cfquery name="qryTerms" datasource="cstone_website">
	SELECT t.term_id, t.name, t.slug, t.term_group
	FROM wp_terms t
        INNER JOIN wp_term_taxonomy tt ON t.term_id = tt.term_id
    WHERE tt.taxonomy = 'th_sermons_cat'
    ORDER BY t.name
</cfquery>
<cfquery name="qrySermonSeries" datasource="cstone_sermons">
	SELECT SS.*
	FROM SermonSeries SS
    WHERE SS.SermonSeriesID IN (
        SELECT DISTINCT S.SermonSeriesID
        FROM Sermons S
    )
</cfquery>    
<cfloop query="qrySermonSeries">
    <cfquery name="qryTerm" dbtype="query">  
        SELECT *
        FROM qryTerms
        WHERE name = <cfqueryparam value="#qrySermonSeries.Name#" cfsqltype="CF_SQL_VARCHAR" />
    </cfquery>
    <cfif qryTerm.RecordCount is 0>
        <cfquery datasource="cstone_website" result="stcResult">
            INSERT INTO wp_terms (
                name,
                slug,
                term_group
            )
            VALUES (
                <cfqueryparam value="#qrySermonSeries.Name#" cfsqltype="CF_SQL_VARCHAR" />,
                <cfqueryparam value="#generateSlug(qrySermonSeries.Name)#" cfsqltype="CF_SQL_VARCHAR" />,
                0
            )
        </cfquery>
        <cfquery datasource="cstone_website">
            INSERT INTO wp_term_taxonomy (
                term_id,
                taxonomy,
                description,
                parent,
                count
            )
            VALUES (
                <cfqueryparam value="#stcResult.GENERATED_KEY#" cfsqltype="CF_SQL_INTEGER" />,
                'th_sermons_cat',
                '',
                0,
                0
            )
        </cfquery>
        <cfoutput>#qrySermonSeries.Name#</cfoutput> - ADDED<br />
    </cfif>
</cfloop>
<p><strong>Sermon series sync complete.</strong></p>

<h3>Sermons</h3>
<cfquery name="qryPosts" datasource="cstone_website">
	SELECT ID, post_name
	FROM wp_posts
    WHERE post_type = 'th_sermons'
</cfquery>
<cfquery name="qrySermons" datasource="cstone_sermons">
	SELECT TOP 10 S.*, SS.Name AS CategoryName
	FROM Sermons S
        INNER JOIN SermonSeries SS ON S.SermonSeriesID = SS.SermonSeriesID
	ORDER BY S.SermonDate DESC
</cfquery>
<cfquery name="qryCategories" datasource="cstone_website">
	SELECT t.term_id, t.name
	FROM wp_terms t
        INNER JOIN wp_term_taxonomy tt ON t.term_id = tt.term_id
    WHERE tt.taxonomy = 'th_sermons_cat'
    ORDER BY t.name
</cfquery>
<cfloop query="qrySermons">
    <cfquery name="qryPost" dbtype="query">  
        SELECT *
        FROM qryPosts
        WHERE post_name = <cfqueryparam value="#ListFirst(qrySermons.Filename, "_")#" cfsqltype="CF_SQL_VARCHAR" />
    </cfquery>
    <cfif qryPost.RecordCount is 0>
        <cfquery datasource="cstone_website" result="stcResult">
            INSERT INTO wp_posts (
                post_author,
                post_date,
                post_date_gmt,
                post_content,
                post_title,
                post_excerpt,
                post_status,
                comment_status,
                ping_status,
                post_password,
                post_name,
                to_ping,
                pinged,
                post_modified,
                post_modified_gmt,
                post_content_filtered,
                post_parent,
                guid,
                menu_order,
                post_type,
                post_mime_type,
                comment_count
            )
            VALUES (
                1,
                <cfqueryparam value="#qrySermons.SermonDate#" cfsqltype="CF_SQL_DATE" />,
                <cfqueryparam value="#DateConvert("local2utc", qrySermons.SermonDate)#" cfsqltype="CF_SQL_DATE" />,
                <cfqueryparam value="Message for #DateFormat(qrySermons.SermonDate, "dddd, mmmm d, yyyy")# from the <em>#qrySermons.CategoryName#</em> sermon</cfq> series." cfsqltype="CF_SQL_VARCHAR" />,
                <cfqueryparam value="#qrySermons.Name#" cfsqltype="CF_SQL_VARCHAR" />,
                '',
                'publish',
                'closed',
                'closed',
                '',
                <cfqueryparam value="#ListFirst(qrySermons.Filename, "_")#" cfsqltype="CF_SQL_VARCHAR" />,
                '',
                '',
                <cfqueryparam value="#qrySermons.DateCreated#" cfsqltype="CF_SQL_DATE" />,
                <cfqueryparam value="#DateConvert("local2utc", qrySermons.DateCreated)#" cfsqltype="CF_SQL_DATE" />,
                '',
                0,
                '',
                0,
                'th_sermons',
                '',
                0
            )
        </cfquery>
        <cfquery datasource="cstone_website">
            UPDATE wp_posts 
            SET guid = <cfqueryparam value="https://www.cornerstonezearing.org/?post_type=th_sermons&##038;p=#stcResult.GENERATED_KEY#" cfsqltype="CF_SQL_VARCHAR" />
            WHERE id = <cfqueryparam value="#stcResult.GENERATED_KEY#" cfsqltype="CF_SQL_INTEGER" />
        </cfquery>
        <cfquery datasource="cstone_website">
            INSERT INTO wp_postmeta (
                post_id,
                meta_key,
                meta_value
            )
            VALUES (
                <cfqueryparam value="#stcResult.GENERATED_KEY#" cfsqltype="CF_SQL_INTEGER" />,
                'ch_sermon_audio',
                <cfqueryparam value="https://sermons.cornerstonezearing.org/audio/#qrySermons.Filename#" cfsqltype="CF_SQL_VARCHAR" />
            )
        </cfquery>
        <cfquery datasource="cstone_website">
            INSERT INTO wp_term_relationships (
                object_id,
                term_order,
                term_taxonomy_id
            )
            VALUES (
                <cfqueryparam value="#stcResult.GENERATED_KEY#" cfsqltype="CF_SQL_INTEGER" />,
                0,
                54
            )
        </cfquery>
        <cfquery name="qryCategory" dbtype="query">  
            SELECT *
            FROM qryCategories
            WHERE name = <cfqueryparam value="#qrySermons.CategoryName#" cfsqltype="CF_SQL_VARCHAR" />
        </cfquery>
        <cfif qryCategory.RecordCount gt 0>
            <cfquery datasource="cstone_website">
                INSERT INTO wp_term_relationships (
                    object_id,
                    term_order,
                    term_taxonomy_id
                )
                VALUES (
                    <cfqueryparam value="#stcResult.GENERATED_KEY#" cfsqltype="CF_SQL_INTEGER" />,
                    0,
                    <cfqueryparam value="#qryCategory.term_id#" cfsqltype="CF_SQL_INTEGER" />
                )
            </cfquery>
            <cfquery datasource="cstone_website">
                UPDATE wp_term_taxonomy
                SET count = count + 1
                WHERE term_id = <cfqueryparam value="#qryCategory.term_id#" cfsqltype="CF_SQL_INTEGER" />
            </cfquery>
        </cfif>
        <cfoutput>#qrySermons.Name#</cfoutput> - ADDED<br />
    </cfif>
</cfloop>
<p><strong>Sermon sync complete.</strong></p>
        
<cfinclude template="_footer.cfm" />