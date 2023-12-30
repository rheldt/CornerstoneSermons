<cfsilent>
	<!---
		Name:		rss.cfm
		Author:		Ryan J. Heldt
		Created:	2013-05-16
		Purpose:	I generate RSS for the sermons podcast.
	--->

	<cfquery datasource="cstone_sermons" name="qrySermons">
		SELECT TOP 50 Name, SermonDate, Length, Filename, DateCreated
		FROM Sermons
		WHERE IsActive = 1
		ORDER BY SermonDate DESC
	</cfquery>

	<cfdirectory action="list"
		directory="#expandPath("audio")#"
		filter="*.mp3"
		name="qryFiles" />

	<cfcontent type="application/xml; charset=UTF-8" />
	<cfsetting showdebugoutput="false" />

</cfsilent><?xml version="1.0" encoding="UTF-8"?>
<rss xmlns:atom="http://www.w3.org/2005/Atom" xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd" xmlns:media="http://search.yahoo.com/mrss/" version="2.0">
	<channel>
		<title>Cornerstone Church of Zearing Sermons</title>
		<link>https://www.cornerstonezearing.org</link>
		<copyright>Copyright <cfoutput>#year(now())#</cfoutput> Cornerstone Church of Christ</copyright>
		<description><![CDATA[Join our Senior Minister, Chuck Ryan, for his weekly sermons of biblical truth from Cornerstone Church of Christ in Zearing Iowa. To know Him and make Him known.]]></description>
		<language>en</language>
		<category>Religion &amp; Spirituality</category>
		<category>Christianity</category>
		<generator><cfoutput>#cgi.http_host#</cfoutput></generator>
		<ttl>60</ttl>
		<image>
			<url>https://<cfoutput>#cgi.http_host#</cfoutput>/images/cover_2021.jpg</url>
			<title>Cornerstone Church of Zearing Sermons</title>
			<link>https://www.cornerstonezearing.org</link>
			<width>1440</width>
			<height>1440</height>
		</image>
		<itunes:subtitle></itunes:subtitle>
		<itunes:author>Cornerstone Church of Christ</itunes:author>
		<itunes:summary>Join our Senior Pastor, Chuck Ryan, for his weekly sermons of biblical truth from Cornerstone Church of Christ in Zearing Iowa. To know Him and make Him known.</itunes:summary>
		<itunes:owner>
			<itunes:name>Cornerstone Church of Christ</itunes:name>
			<itunes:email>technology@cornerstonezearing.org</itunes:email>
		</itunes:owner>
		<itunes:image href="https://<cfoutput>#cgi.http_host#</cfoutput>/images/cover_2021.jpg"/>
		<itunes:explicit>no</itunes:explicit>
		<itunes:keywords></itunes:keywords>
		<itunes:category text="Religion &amp; Spirituality">
			<itunes:category text="Christianity"/>
		</itunes:category>
		<cfoutput query="qrySermons">
			<cfquery name="qryFile" dbtype="query">
				SELECT Size
				FROM qryFiles
				WHERE Name = <cfqueryparam value="#qrySermons.Filename#" cfsqltype="cf_sql_varchar" />
			</cfquery>
			<item>
				<title>#dateFormat(qrySermons.SermonDate,"mmmm d, yyyy")#</title>
				<itunes:author>Cornerstone Church of Christ</itunes:author>
				<itunes:summary>#xmlFormat(qrySermons.Name)#</itunes:summary>
				<description><![CDATA[#xmlFormat(qrySermons.Name)#]]></description>
				<enclosure url="https://#cgi.http_host#/audio/#qrySermons.Filename#" type="audio/mpeg" length="#val(qryFile.Size)#"/>
				<itunes:duration>#xmlFormat(qrySermons.Length)#</itunes:duration>
				<guid isPermaLink="true">https://#cgi.http_host#/audio/#qrySermons.Filename#</guid>
				<pubDate>#dateFormat(qrySermons.SermonDate,"ddd, d mmm yyyy")# #timeFormat(qrySermons.DateCreated,"HH:mm:ss")# -0000</pubDate>
				<link>https://#cgi.http_host#/audio/#qrySermons.Filename#</link>
				<itunes:explicit>no</itunes:explicit>
				<itunes:image href="https://#cgi.http_host#/images/cover_2021.jpg"/>
				<media:thumbnail url="https://#cgi.http_host#/images/cover_2021.jpg"/>
			</item>
		</cfoutput>
	</channel>
</rss>