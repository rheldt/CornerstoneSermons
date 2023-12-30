<!---
	Name:		Application.cfc
	Author:		Ryan J. Heldt
	Created:	2017-01-25
	Purpose:	I am the Application component.
--->

<cfcomponent output="false">
	<cfscript>
		this.name = "cornerstonezearing_sermons";
		this.datasource = "cstone_sermons";
        this.clientManagement = false;
		this.sessionManagement = false;
		this.setDomainCookies = false;
		this.scriptProtect = "all";
        this.javaSettings = { loadPaths: [ "/lib/" ], loadColdFusionClassPath: true };
	</cfscript>

	<cffunction name="onRequest" access="public" returntype="void" output="true">
		<cfargument name="request" type="string" required="true" />
		<cfset variables.directory = "D:\home\cornerstonezearing.org\subdomains\sermons\audio\" />
        <cfset variables.token = "a61c0e59-56c0-4199-875f-e64fc1229137" />
		<cfinclude template="#arguments.request#" />
		<cfreturn />
	</cffunction>

</cfcomponent>