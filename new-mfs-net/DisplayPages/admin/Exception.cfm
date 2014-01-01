<!---
<fusedoc fuse="exception.cfm" language="ColdFusion/MachII" version="1.07">
   <responsibilities>
      This page will display any error information that can't be redirected to 
      another page.
   </responsibilities>
   <properties>
      <history author="Chad McCue" date="3Dec2003" role="Architect" type="Create" />
   </properties>
</fusedoc> 
--->


<cfset message = request.event.getArg('message','') />
<cfset exception = request.event.getArg('exception') />

<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%"> 
	<tr>
		<td width="100%" align="center">								
				<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%"> 
					<tr><td>&nbsp;</td></tr>
					<Tr>
						<td width="5%">&nbsp;</td>
						<td width="90%">						
							<CFOUTPUT>
							<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%"> 
								<tr>
									<td align="center">
										<font face="Arial, Helvetica, sans-serif" size="2">
											<CFIF isdefined("Message") AND Message IS NOT "">
												#message#
											<CFELSE>
                                            	<cfset MessageVal = #exception.getMessage()# />
												<cfif #trim(MessageVal)# contains "<">
                                                 <cflocation url="#Request.webroot#DisplayPages/custom404.cfm" addtoken="no" />
                                                <cfelse>
                                                 #exception.getMessage()# <br>
                                                #exception.getDetail()#
                                                </cfif>   
											</CFIF>
										</font>
									</td>
								</tr>
								<tr><td height="15"></td></tr>
								<tr>
									<td align="center">
										<input type="Button" value="Go Back" onClick="history.back();">
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>								
							</TABLE>
							</CFOUTPUT>							
						</td>
						<td width="5%">&nbsp;</td>
					</TR>
				</TABLE>
		</td>
	</tr>
</TABLE>
