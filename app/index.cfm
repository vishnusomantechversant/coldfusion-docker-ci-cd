<!-- Add the Bootstrap CSS file -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">

<!-- Add jQuery and the Bootstrap JavaScript files -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.3/dist/umd/popper.min.js"
    integrity="sha256-cQ/nXyZSn3xj1TC5VdK7eMuUr6b+QoWlNk+NYGp50eI=" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<!--- <cfdump var="test" abort > --->
<cfset usersObj = new Users()>
<cfset errors = []>



<cfif structKeyExists(form, "firstName") AND structKeyExists(form, "lastName") AND structKeyExists(form, "email") AND structKeyExists(form, "phone")>
	<!--- Validate form data --->
	<cfif len(trim(form.firstName)) EQ 0>
		<cfset arrayAppend(errors, "Please enter your first name.")>
	</cfif>
	<cfif len(trim(form.lastName)) EQ 0>
		<cfset arrayAppend(errors, "Please enter your last name.")>
	</cfif>
	<cfif len(trim(form.email)) EQ 0 OR NOT reFind("^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$", form.email)>
		<cfset arrayAppend(errors, "Please enter a valid email address.")>
	</cfif>
	<cfif len(trim(form.phone)) EQ 0 OR NOT reFind("^\d{10}$", form.phone)>
		<cfset arrayAppend(errors, "Please enter a valid phone number (10 digits).")>
	</cfif>
	
	<!--- If there are no errors, create or update the user based on whether an ID is present --->
	<cfif arrayLen(errors) EQ 0>
		<cfset usersObj = new Users()>
		
		<cfif structKeyExists(form, "id") AND isNumeric(form.id)>
			<cfset id = form.id>
			<cfset usersObj.updateUser(userId=id, firstName=form.firstName, lastName=form.lastName, email=form.email, phone=form.phone)>
			<cfset successMessage = "User updated successfully.">
		<cfelse>
			<cfset usersObj.createUser(firstName=form.firstName, lastName=form.lastName, email=form.email, phone=form.phone)>
			<cfset successMessage = "User created successfully.">
		</cfif>
	</cfif>
</cfif>


<cfset usersObj = new Users()>
<cfset usersQuery = usersObj.readUsers()>

<div  class="container mt-5">
	<a href="/" class="btn btn-primary mb-2">Add</a>
	<a href="/xl.cfm" class="btn btn-primary mb-2 float-right">CSV</a>
	<a href="/pdf.cfm" class="btn btn-primary mb-2 float-right mr-2">PDF</a>	
    <cfif structKeyExists(url, "delete_id") AND isNumeric(url.delete_id)>
        <cfset id = url.delete_id>
        
        <cfset usersObj = new Users()>
        <cfset user = usersObj.deleteUser(id)>
		<cfif user eq true>
			<cflocation url="/?delete_id=#id#" addtoken="false">
		</cfif>
        <div class="alert alert-success" role="alert">
            User with ID <cfoutput>#id#</cfoutput> deleted successfully.
        </div>

    </cfif>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>ID</th>
                <th>First Name</th>
                <th>Last Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="#usersQuery#">
                <tr>
                    <td><cfoutput>#id#</cfoutput></td>
                    <td><cfoutput>#first_name#</cfoutput></td>
                    <td><cfoutput>#last_name#</cfoutput></td>
                    <td><cfoutput>#email#</cfoutput></td>
                    <td><cfoutput>#phone#</cfoutput></td>
                    <td>
                        <a href="?id=<cfoutput>#id#</cfoutput>" class="btn btn-primary">Edit</a>
                        <a href="?delete_id=<cfoutput>#id#</cfoutput>" class="btn btn-danger">Delete</a>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
</div>

<cfset formData = structNew()>
<cfset formData.firstName = "">
<cfset formData.lastName = "">
<cfset formData.email = "">
<cfset formData.phone = "">

<cfset editMode = false> <!--- Assume not in edit mode by default --->

<!--- Check if an "id" parameter is present in the URL --->
<cfif structKeyExists(url, "id") AND isNumeric(url.id)>
	<cfset id = url.id>
	
	<!--- Get the user data for the specified ID --->
	<cfset usersObj = new Users()>
	<cfset user = usersObj.readUser(id)>
	
	<!--- If a user is found, pre-fill the form fields with their data --->
	<cfif structKeyExists(user, "id")>
		<cfset editMode = true> <!--- Set edit mode to true --->
		
		<cfset formData.firstName = user.first_name>
		<cfset formData.lastName = user.last_name>
		<cfset formData.email = user.email>
		<cfset formData.phone = user.phone>
	</cfif>
</cfif>

<cfif structCount(formData) GT 0>
    <!--- Check if there is submitted form data and update the form data struct accordingly --->
    <cfif structKeyExists(form, "firstName")>
        <cfset formData.firstName = trim(form.firstName)>
    </cfif>

    <cfif structKeyExists(form, "lastName")>
        <cfset formData.lastName = trim(form.lastName)>
    </cfif>

    <cfif structKeyExists(form, "email")>
        <cfset formData.email = trim(form.email)>
    </cfif>

    <cfif structKeyExists(form, "phone")>
        <cfset formData.phone = trim(form.phone)>
    </cfif>
</cfif>

<form method="post" class="container mt-5">
	<!--- Display error messages (if any) --->
	<cfif arrayLen(errors) GT 0>
		<div class="alert alert-danger" role="alert">
			<ul>
				<cfloop array="#errors#" index="error">
					<li><cfoutput>#error#</cfoutput></li>
				</cfloop>
			</ul>
		</div>
	</cfif>

	<!--- Display success message (if any) --->
	<cfif structKeyExists(variables, "successMessage")>
		<div class="alert alert-success" role="alert"><cfoutput>#successMessage#</cfoutput></div>
	</cfif>

	<!--- If in edit mode, show a message indicating that we're editing an existing user --->
	<cfif editMode eq true>
		<div class="alert alert-info" role="alert">Editing user with ID <cfoutput>#id#</cfoutput>.</div>
        <input type="hidden" name="id" value="<cfoutput>#user.id#</cfoutput>">
    </cfif>

	<div class="form-group">
		<label for="firstName">First Name:</label>
		<input type="text" name="firstName" id="firstName" class="form-control" value="<cfoutput>#formData.firstName#</cfoutput>">
	</div>
	<div class="form-group">
		<label for="lastName">Last Name:</label>
		<input type="text" name="lastName" id="lastName" class="form-control" value="<cfoutput>#formData.lastName#</cfoutput>">
	</div>
	<div class="form-group">
		<label for="email">Email:</label>
		<input type="text" name="email" id="email" class="form-control" value="<cfoutput>#formData.email#</cfoutput>">
	</div>
	<div class="form-group">
		<label for="phone">Phone:</label>
		<input type="text" name="phone" id="phone" class="form-control" value="<cfoutput>#formData.phone#</cfoutput>">
	</div>
	<button type="submit" class="btn btn-primary">Submit</button>
</form>
