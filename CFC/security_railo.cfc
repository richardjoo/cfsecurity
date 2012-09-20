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
			Therefore, for ACF8+ compatibility reason, ACF9+ features are commented out.
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
	
	
	
	
	
	/**
		Thie method will check if the user object passed via argument is qualified to meet specific rule for given site.
		In this method, I am dealing with two different site structure to handle two different sites.
		First platform I will name it "ABC" and the second platform, I will name it "DEF"
		
		Two platforms require two different set of standards and rules and database structure.
		You can modify this section to fit to your organization's business logic.
	
	*/
	function isArgQualified(argUser)
	{
		var isQualified = 0;
						
		if (isDefined('argUser.platform') AND CompareNoCase(argUser.platform, ''))
		{		
			if (isDefined('argUser.site') AND CompareNoCase(argUser.site, ''))
			{	
				// at this point, all the mandatory requirements are passed.
				if (NOT CompareNoCase(argUser.platform, 'ABC'))
				{	
					if (CompareNoCase(argUser.ABC_userid, ''))
					{	
						// now passed ABC requirements.
						// need one more check
						if (NOT CompareNoCase(argUser.ABC_user_level, 'interpreter'))
						{	
							// I am changing this to 0 because I am now setting the langauge id list from other method: userSecurityCheck()
							/*
							if (CompareNoCase(argUser.language_id_list, ''))
							{
								isQualified= 1;
							}
							*/
							isQualified = 1;
						}
						else
						{
							isQualified= 1;
						}
					}
				}
				else if (NOT CompareNoCase(argUser.platform, 'DEF'))
				{
					if (isDefined('argUser.DEF_userid') AND CompareNoCase(argUser.DEF_userid, ''))
					{
						if (isDefined('argUser.gip_roleid') AND CompareNoCase(argUser.gip_roleid, ''))
						{
							// this case needs to be revisited because of multiple account access for customers.
							// other than that, it is qualificed
							// need one more check
							// this is interpreter role
							if (NOT CompareNoCase(argUser.DEF_roleid, '8aa39ab6-4d3b-46a2-a2a8-5efb9bc66c2c'))
							{	
								// I am changing this to 0 because I am now setting the langauge id list from other method: userSecurityCheck()
								/*
								if (CompareNoCase(argUser.language_id_list, ''))
								{
									isQualified= 1;
								}
								*/
								isQualified = 1;
							}
							else
							{
								isQualified= 1;
							}
						}
					}
				}
			}
		} // end of checking required arguments
		
		return isQualified;
	} // function isArgQualified(argUser)
	
	
	
	
	
	
	
	
	/**
	* getting the user info from the security users table.
	
		REQUIRMENTS:
			this function will request different requirements depending on what platform it is, what user level it is.
			here are the list of requirements
			Railo compatible code.
			
			mandatory
				platform
				site
				
			if platform = IMSS
				imss_userid
				
				if imss_user_level = interpreter
					language_id_list
					
			
			if platform = GIP
				gip_userid
				gip_roleid
				
				if gip_roleid = GIP_Registry.dbo.Roles.ID WHERE Role='interpreter'
					language_id_list
	*/
	function getUserInfo(argUser)
	{
		// Declaration
		var userObj = CreateObject("component", "security");
		var isQualified=0;
		var objFactory ="";
		var objDataService = "";
		var objDataSource = "";
		var objConnection = "";
		var objStatement = "";
		var objResults = "";
		var retQuery = "";
		
		isQualified = userObj.isArgQualified(argUser);
			
		try
		{
			
			// checking required arguments
			if (isQualified)
			{
				
				if (Not CompareNoCase(Server.ColdFusion.ProductName, "Railo") )
				{
					if (Not CompareNoCase(argUser.platform, 'ABC'))
					{
						objStatement =  "SELECT `id`, `DEF_userid`, `DEF_roleid`, `ABC_userid`, `language_id_list`, " & 
										"`platform`, `remote_host`, `site`, `telephonic_allowed`, `timestamp`, `key` " &
										"FROM `users` " &
										"WHERE (`ABC_userid`=#argUser.ABC_userid#) AND (`ABC_user_level`='#argUser.ABC_user_level#') AND (`platform`='#argUser.platform#') AND (`site`='#argUser.site#')";
					}
					else if (Not CompareNoCase(argUser.platform, 'DEF'))
					{
						objStatement =  "SELECT `id`, `DEF_userid`, `DEF_roleid`, `ABC_userid`, `language_id_list`, " & 
										"`platform`, `remote_host`, `site`, `telephonic_allowed`, `timestamp`, `key` " &
										"FROM `users` " &
										"WHERE (`DEF_userid`='#argUser.DEF_userid#') AND (`DEF_roleid`='#argUser.DEF_roleid#') AND (`platform`='#argUser.platform#') AND (`site`='#argUser.site#')";
					}

					query datasource="security" name="objResults" 
					{
						writeOutput('#objStatement#');
					}
					
					retQuery = objResults;
				}
				else
				{
					// First, we need to get access to the ColdFusion service
					// factory. This is a Java object that we can instantiate.
					objFactory = CreateObject("java", "coldfusion.server.ServiceFactory");

					// Get the Data Source service from the service factory.
					objDataService = objFactory.DataSourceService;

					// The data service object has access to all data sources
					// running on the server. Let's get a connection to our
					// datasource before running the query.
					objDataSource = objDataService.GetDataSource("security");

					// Open the connection. Here, we have the option to pass
					// in a username and password. Since I am on the dev
					// server, no need to do so.
					//objConnection = objDataSource.GetConnection(
					// USERNAME, PASSWORD if needed //
					//);
					objConnection = objDataSource.GetConnection();

					// Prepare the SQL statement
					if (Not CompareNoCase(argUser.platform, 'ABC'))
					{
						objStatement = objConnection.PrepareStatement(
										"SELECT `id`, `DEF_userid`, `DEF_roleid`, `ABC_userid`, `language_id_list`, " & 
										"`platform`, `remote_host`, `site`, `telephonic_allowed`, `timestamp`, `key` " &
										"FROM `users` " &
										"WHERE (`ABC_userid`=#argUser.ABC_userid#) AND (`ABC_user_level`='#argUser.ABC_user_level#') AND (`platform`='#argUser.platform#') AND (`site`='#argUser.site#')");
					}
					else if (Not CompareNoCase(argUser.platform, 'DEF'))
					{
						objStatement = objConnection.PrepareStatement(
										"SELECT `id`, `DEF_userid`, `DEF_roleid`, `ABC_userid`, `language_id_list`, " & 
										"`platform`, `remote_host`, `site`, `telephonic_allowed`, `timestamp`, `key` " &
										"FROM `users` " &
										"WHERE (`DEF_userid`='#argUser.DEF_userid#') AND (`DEF_roleid`='#argUser.DEF_roleid#') AND (`platform`='#argUser.platform#') AND (`site`='#argUser.site#')");
					}


					// Execute the prepared SQL statement. This line alone returns
					// the java class: "macromedia.jdbc.base.BaseResultSet". In order
					// to work with this most effectively, we have to turn it into
					// the Java class "coldfusion.sql.QueryTable". This is the class
					// of object that is returned from the CFQuery tag, and the type
					// of object that we are all used to working with.
					objResults = CreateObject("java","coldfusion.sql.QueryTable").Init( objStatement.ExecuteQuery() );
					
					retQuery = objResults;

					// Close the connection.
					objConnection.Close();
				}
				
			} // end of if (isArgQualified(argUser))
			
			
		}
		catch (any e)
		{
			writeoutput("<script language='JavaScript'>
							<!-- 
								alert('error occurred: #e.detail#\n\n #e.type#\n\n code:\n942212051317621003067'); 
							//--></script>");
		}
		
		return retQuery;
	}
</cfscript>
</cfcomponent>
