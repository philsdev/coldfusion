<div id="breadcrumb">
	<a href="/">Home</a><span>Shopping Cart</span>
</div>
<!--- contentContainer nessesary for liquid layouts with static and percentage columns --->
<div id="contentContainer" class="fullPage">
  <div id="content" class="contentSection">
    <div id="proceedOption" class="leftCheckoutBox">
    <h2>Proceed as a Guest</h2>
      <div class="formContainer">
        <p>You don't need to register for an account to check out - just click "Continue Checkout". You can 
          still register once your order is complete, to enjoy faster checkouts and other benefits.</p>
        <form name="CFForm_1" id="CFForm_1" action="checkout.html" method="post" onsubmit="return _CF_checkCFForm_1(this)">
          <div class="buttonLeft">
            <input id="ContinueCheckoutSubmit" type="submit" name="submit" class="button" value="Continue Checkout">
          </div>
        </form>
      </div>
    </div>
    <div class="rightCheckoutBox">
    <h2>Existing Members Sign-In</h2>
      <div class="formContainer">
        <p class="mb">Sign in for a faster checkout with saved information.</p>
		
		<cfif IsDefined("SESSION.User.Failed") and Session.User.Failed eq 'yes'>
			<p class="message alert cb">That is not the correct username or password.  Please try again.</p>
		</cfif>
        <form name="CFForm_2" id="CFForm_2" action="index.cfm?event=Customer.Profile.VerifyLogin" method="post" onsubmit="return _CF_checkCFForm_2(this)">
		<input type="hidden" name="ErrorUrl" id="ErrorUrl" value="/shopping-cart-proceed.html" />
		<input type="hidden" name="ReturnUrl" id="ReturnUrl" value="/checkout.html" />
          <ul class="form">
            <li>
              <label>Email:</label>
              <input name="Username" type="text" maxlength="255" class="usernameField textInput" id="Username" width="200">
            </li>
            <li>
              <label>Password:</label>
              <input name="Password" type="password" maxlength="10" class="passwordField textInput" id="Password" width="200">
            </li>
			<li>
				<label>Type of Account:</label>                        
				<input type="Radio" value="1" name="UserType" checked>Customer
			</li>
			<li>
				<label></label> 
				<input type="Radio" value="2" name="UserType" >Corporate 
			</li>
            <li>
              <label></label>
              <input id="SignInSubmit" type="submit" name="submit" class="button" value="Sign-In">
              <a href="/forget-password.html" class="leftNote"><small>Forgot Password?</small></a> </li>
          </ul>
        </form>
      </div>
    </div>
  </div>
</div>

