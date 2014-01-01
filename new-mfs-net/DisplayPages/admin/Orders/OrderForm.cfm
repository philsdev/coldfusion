<script type="text/javascript" src="/Javascript/Orders.js"></script>
      		                 
<div id="OrderForm" class="inputForm">
	<form action="index.cfm?event=Admin.Order.Submit" method="post" id="OrderEditForm">
		<cfoutput>
		<input type="hidden" name="OrderID" id="OrderID" value="<cfif Request.Order.OrderID GT 0>#Request.Order.OrderID#<cfelse>0</cfif>" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="" />
		<ul class="form">                        
			<li>
				<label>Order ID:</label>
				#request.Order.OrderID#
			</li>
			<li>
				<label>Date Ordered:</label>
				#DateFormat(request.Order.DateOrdered, 'full')# @ #TimeFormat(request.Order.DateOrdered, 'short')#
			</li>
			<li>
				<label>PawFlowPro Transaction ID:</label>
				#request.Order.PayFlowProComments#
			</li>
			<li>
				<label>Admin Order Notes:</label>
				<textarea class="textinput" name="OrderNotes" id="OrderNotes"><cfif LEN(request.Order.OrderNotes)>#request.Order.OrderNotes#<cfelse>#request.orderDefaultAdminNotes#</cfif></textarea>
			</li>
		</ul>
		#Request.SubmitButtons#
		</cfoutput>
	</form>
</div>