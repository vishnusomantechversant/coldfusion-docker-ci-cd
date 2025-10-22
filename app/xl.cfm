<cfset usersObj = new Users()>
<cfset usersQuery = usersObj.readUsers()> 
<cfheader name="Content-Disposition" value="attachment; filename=data_export.csv">
<cfcontent type="text/csv" reset="true">
id,"first_name","last_name","email","phone"
<cfoutput query="usersQuery" >
#usersQuery.id#,"#usersQuery.first_name#","#usersQuery.last_name#","#usersQuery.email#","#usersQuery.phone#"
</cfoutput>