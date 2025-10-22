<cfcomponent>
	<!--- Create a new user record in the database. --->
	<cffunction name="createUser" access="remote" returntype="void">
		<cfargument name="firstName" type="string" required="true">
		<cfargument name="lastName" type="string" required="true">
		<cfargument name="email" type="string" required="true">
		<cfargument name="phone" type="string" required="true">

		<cfquery datasource="mydatabase">
			INSERT INTO users (first_name, last_name, email, phone)
			VALUES ('#arguments.firstName#', '#arguments.lastName#', '#arguments.email#', '#arguments.phone#')
		</cfquery>
	</cffunction>

	<!--- Retrieve a user record from the database by ID. --->
	<cffunction name="readUser" access="remote" returntype="query">
		<cfargument name="userId" type="numeric" required="true">

		<cfquery name="userQuery" datasource="mydatabase">
			SELECT * FROM users WHERE id = #arguments.userId#
		</cfquery>

		<cfreturn userQuery>
	</cffunction>

    <cffunction name="readUsers" access="remote" returntype="query">
        <cfquery name="userQuery" datasource="mydatabase">
            SELECT * FROM users
        </cfquery>
    
        <cfreturn userQuery>
    </cffunction>

	<!--- Update an existing user record in the database. --->
	<cffunction name="updateUser" access="remote" returntype="void">
		<cfargument name="userId" type="numeric" required="true">
		<cfargument name="firstName" type="string" required="false">
		<cfargument name="lastName" type="string" required="false">
		<cfargument name="email" type="string" required="false">
		<cfargument name="phone" type="string" required="false">

		<cfquery datasource="mydatabase">
			UPDATE users SET
				first_name = <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar" null="#NOT len(trim(arguments.firstName))#">,
				last_name  = <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar" null="#NOT len(trim(arguments.lastName))#">,
				email      = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar" null="#NOT len(trim(arguments.email))#">,
				phone      = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar" null="#NOT len(trim(arguments.phone))#">
			WHERE id = #arguments.userId#
		</cfquery>
	</cffunction>

	<!--- Delete a user record from the database. --->
	<cffunction name="deleteUser" access="remote" returntype="boolean">
		<cfargument name="userId" type="numeric" required="true">
	
		<cfquery datasource="mydatabase" name="total">
			SELECT COUNT(*) AS rowCount from users
		</cfquery>

		<cfquery datasource="mydatabase" name="deleteRow">
			DELETE FROM users WHERE id = #arguments.userId#
		</cfquery>

		<cfquery datasource="mydatabase" name="totalAfter">
			SELECT COUNT(*) AS rowCount from users
		</cfquery>
	
		<cfif total.rowCount EQ totalAfter.rowCount>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>
	
	
</cfcomponent>
