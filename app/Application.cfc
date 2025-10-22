<cfcomponent>

	<cffunction name="onApplicationStart" returnType="boolean" output="false">
        <cfscript>
            datasourceName = "mydatabase";
            databaseHost = "mymysql";
            portNumber = "3306";
            databaseName = "mydatabase";
            databaseUsername = "root";
            databasePassword = "root";
            
            adminObj = createObject("component","CFIDE.adminapi.administrator");
            adminObj.login("Pwd4cf!23");
            
            datasource = createObject("component", "CFIDE.adminapi.datasource");
            datasource.setMySQL5(
                name=datasourceName,
                host="#databaseHost#",
                database=databaseName,
                username=databaseUsername,
                password=databasePassword
            );
            return true;
        </cfscript>
        

	</cffunction>


	
	<!--- Define other application methods --->
	<cffunction name="onSessionStart" returnType="void" output="false">
		<!--- Code to run when a new session starts --->
	</cffunction>
	
    <cffunction name="onRequestStart" returnType="boolean" output="false">
        <cfreturn true>
    </cffunction>
	
	
	<cffunction name="onRequestEnd" returnType="boolean" output="false">
		<!--- Code to run at the end of each request --->
        <cfreturn true>
	</cffunction>
	
	<cffunction name="onSessionEnd" returnType="void" output="false">
		<!--- Code to run when a session ends --->
	</cffunction>
	
	<cffunction name="onApplicationEnd" returnType="void" output="false">
		<!--- Code to run when the application ends --->
	</cffunction>

    <cffunction name="onError">
		<cfargument name="Exception" required=true/>
		<cfargument type="String" name="EventName" required=true/>
		<cfdump  var="#arguments#" abort>
		
	</cffunction>

    
    

</cfcomponent>
