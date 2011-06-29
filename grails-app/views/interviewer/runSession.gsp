<%@ page contentType="text/html;charset=ISO-8859-1" %>
<html>
<head>
	<meta name="layout" content="main"/>
	<title>Interviewer</title>
	<g:javascript library="prototype" />
</head>
<content tag="headerRight">
	Session #${sessionId} |
	<g:link action="toggleDebug" id="${sessionId}">Debug <g:if test="${isDebug}">Off</g:if><g:else>On</g:else></g:link> |
	<g:link action="closeSession" id="${sessionId}">Close session</g:link> |
	<g:link controller="user" action="logout">Logout</g:link>
</content>
<body>
	<g:render template="/shared/runSession" />
</body>
</html>
