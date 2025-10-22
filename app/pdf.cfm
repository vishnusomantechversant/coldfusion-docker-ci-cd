<cfdocument format="PDF" filename="file.pdf" overwrite="Yes">
<body>
    <head>
        <link rel="stylesheet" href="styles.css">
        <style>
            table,td,tr{
                border: 1px solid;
            }
        </style>
    </head>
    <header>
      <h1>User Details</h1>    
    </header>
    <section>
      <article class="main">
        <h4>Lorem ipsum dolor
        </h4>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>
     </article>

        <article>
                  <table class="second">
                      <thead>
                        <tr>
                            <th>ID</th>
                            <th>First Name</th>
                            <th>Last Name</th>
                            <th>Email</th>
                            <th>Phone</th>
                        </tr>
                      </thead>
                      <tbody>
                            <cfset usersObj = new Users()>
                            <cfset usersQuery = usersObj.readUsers()>
                          <cfloop query="#usersQuery#">
                            <tr>
                                <td><cfoutput>#id#</cfoutput></td>
                                <td><cfoutput>#first_name#</cfoutput></td>
                                <td><cfoutput>#last_name#</cfoutput></td>
                                <td><cfoutput>#email#</cfoutput></td>
                                <td><cfoutput>#phone#</cfoutput></td>
                            </tr>
                        </cfloop>
                      </tbody>
              </table>
      </article>      
      
      </section>
      <footer>
      <p>&copy; 2023</p>
      </footer>
  </body>
</cfdocument>
<cflocation url="/file.pdf" addtoken="false">
