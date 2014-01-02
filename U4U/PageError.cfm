<cfmail 
    to="info@advmediaproductions.com" 
    from="#request.Admin_Email#"
    server="#request.Email_Server#" 
    subject="#request.SiteName# Site Error"
    type="html"
>
<table border="0" cellpadding="0" cellspacing="0">   
    <tr>
        <td>
            By Who:
            <CFIF isdefined("Arguments.FrontEnd")>
				<CFIF #Arguments.FrontEnd# EQ 1>
                    User
                <CFELSE>
                    Admin
                </CFIF>
            <CFELSE>
                User
            </CFIF>
        </td>
    </tr>
    <tr><td height="10"></td></tr>
    <tr>
        <td>
            Error Type: #cfcatch.type#
        </td>
    </tr>
    <tr><td height="10"></td></tr>
    <tr>
        <td>
            Event: #cgi.QUERY_STRING#
        </td>
    </tr>
    <tr><td height="10"></td></tr>
    <tr>
        <td>
            Error: #cfcatch.message #
        </td>
    </tr>      
   <CFIF #cfcatch.type# IS "database">
		 <tr><td height="10"></td></tr>
        <tr>
        	<td>SQL Call:</td>
        </tr>
        <tr>
        	<td>
            	#cfcatch.Sql#
            </td>
        </tr>
        <tr>
        	<td>Query Error:</td>
        </tr>
        <tr>
        	<td>
            	#cfcatch.queryError#
            </td>
        </tr>
	</CFIF> 
     <tr><td height="10"></td></tr>
    <tr>
        <td>
         Form Fields:
        </td>
    </tr>  
    <CFLOOP list="#FieldNames#" index="i">
        <tr>
            <td>
                <CFIF #i# DOES NOT CONTAIN "CardNumber">
					#i#: #evaluate(i)#
				</CFIF>
            </td>
        </tr>
    </CFLOOP>
    
</table>                                        
</cfmail>
