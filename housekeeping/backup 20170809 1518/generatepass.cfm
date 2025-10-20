


<!---
	We have to start out be defining what the sets of valid
	character data are. While this might not look elegant,
	notice that it gives a LOT of power over what the sets
	are without writing a whole lot of code or "condition"
	statements.
--->
 
<!--- Set up available lower case values. --->
<cfset strLowerCaseAlpha = "abcdefghijklmnopqrstuvwxyz" />
 
<!---
	Set up available upper case values. In this instance, we
	want the upper case to correspond to the lower case, so
	we are leveraging that character set.
--->
<cfset strUpperCaseAlpha = UCase( strLowerCaseAlpha ) />
 
<!--- Set up available numbers. --->
<cfset strNumbers = "0123456789" />
 
<!--- Set up additional valid password chars. --->
<cfset strOtherChars = "~!@##$%^&*" />
 
<!---
	When selecting random value, we want to be able to easily
	choose from the entire set. To this effect, we are going
	to concatenate all the previous valid character sets.
--->
<cfset strAllValidChars = (
	strLowerCaseAlpha &
	strUpperCaseAlpha &
	strNumbers &
	strOtherChars
	) />
 
 
<!---
	Create an array to contain the password ( think of a
	string as an array of character).
--->
<cfset arrPassword = ArrayNew( 1 ) />
 
 
<!---
	When creating a password, there are certain rules that we
	need to follow (as deemed by the business logic). That is,
	the password must:
 
	- must be exactly 8 characters in length
	- must have at least 1 number
	- must have at least 1 uppercase letter
	- must have at least 1 lower case letter
--->
 
 
<!--- Select the random number from our number set. --->
<cfset arrPassword[ 1 ] = Mid(
	strNumbers,
	RandRange( 1, Len( strNumbers ) ),
	1
	) />
 
<!--- Select the random letter from our lower case set. --->
<cfset arrPassword[ 2 ] = Mid(
	strLowerCaseAlpha,
	RandRange( 1, Len( strLowerCaseAlpha ) ),
	1
	) />
 
<!--- Select the random letter from our upper case set. --->
<cfset arrPassword[ 3 ] = Mid(
	strUpperCaseAlpha,
	RandRange( 1, Len( strUpperCaseAlpha ) ),
	1
	) />
 
 
<!---
	ASSERT: At this time, we have satisfied the character
	requirements of the password, but NOT the length
	requirement. In order to do that, we must add more
	random characters to make up a proper length.
--->
 
 
<!--- Create rest of the password. --->
<cfloop
	index="intChar"
	from="#(ArrayLen( arrPassword ) + 1)#"
	to="8"
	step="1">
 

	<cfset arrPassword[ intChar ] = Mid(
		strAllValidChars,
		RandRange( 1, Len( strAllValidChars ) ),
		1
		) />
 
</cfloop>
<cfset CreateObject( "java", "java.util.Collections" ).Shuffle(
	arrPassword
	) />
<cfset strPassword = ArrayToList(
	arrPassword,
	""
	) />