<%@ page contentType="text/html;charset=ISO-8859-1" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
<meta name="layout" content="main"/>
<title>CodeShare</title>
</head>
<body>
	Welcome!
	<br/><br/>
	<g:form name="code">
		Please enter your code: <g:textField name="code" id="code" value="${code}" /> <g:actionSubmit value="Register" action="register" />
		<span style="color:red; padding-left:8px;">${errorMessage}</span>
	</g:form>
	<script>
	setTimeout('document.getElementById("code").focus()', 200);
	</script>
</body>
</html>
