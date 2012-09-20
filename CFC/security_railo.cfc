<cfcomponent output="true">
<cfscript>
	/**
	* this method will create random number and return
	* this key will be assigned to each user session and stored onto either the file or database (up to you to choose)
	* if the key is not matching between user session key vs. stored key for this specific user, then something is not right.
	* that would mean it is either session is expired, new session, or possible hack attack.
	*/
	function generateKey()
	{
		var randNum = createObject("java", "java.util.Random").init();
	
		randNum = '' & randNum.nextInt(javaCast("int",(99999999))) & '' & GetTickCount() & '';

		return randNum;
	}
	
	
	
	
	/**
			When security authentication fails, 
			this one will be called and do all the proper procedures to handle unauthorized user with unauthorized access
			At this point, I am not sure if I can utilize this method or not.
			What I am looking for is only supported from ACF 9+ and Railo 3.2+
	*/
	function securityAuthenticationFailed()
	{
		writeoutput('there was an error<br>');
		
		// this is for cf9+ 
		// Create an instance of the mail object
		//mail=new mail();

		// Set it's properties
		//mail.setSubject( "Sample Email" );
		//mail.setTo( "richardjoo@gmail.com" );
		//mail.setFrom( "richardjoo@gmail.com" );
		//mail.setCC( "richardjoo@gmail.com" );

		// Add an attachment
		//mail.addParam( file="C:\foo.txt" );

		// Add email body content in text and HTML formats
		//mail.addPart( type="text", charset="utf-8", wraptext="72", body="This is a test message." );
		//mail.addPart( type="html", charset="utf-8", body="<p>This is a test message.</p>" );

		// Send the email
		// mail.send();
		
		
		// this is my alert() script in cfscript
		/*
		writeoutput('redirect to other page<br>');
		writeoutput("
			<script language='JavaScript'>
			<!--
				alert('relocating...');
			//-->
			</script>
		");
		*/
		
		// location and abort is cf9+
		//location=(url='http://www.voxeo.com');
		//abort;
		
		return false;

	}
</cfscript>
</cfcomponent>
