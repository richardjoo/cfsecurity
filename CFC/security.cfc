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
</cfscript>
</cfcomponent>
