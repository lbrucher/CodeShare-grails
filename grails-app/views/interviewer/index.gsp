<%@ page contentType="text/html;charset=ISO-8859-1" %>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
	<meta name="layout" content="main"/>
	<title>Interviewer - Dashboard</title>
</head>
<content tag="headerRight">
	<g:link controller="user" action="logout">Logout</g:link>
</content>
<body>
  <div class="body">
    Interview sessions:<br/>
    <table border="1" cellspacing="0" cellpadding="4">
    <thead>
	    <td>id</td>
	    <td>date</td>
	    <td>status</td>
	    <td></td>
    </thead>
	<tbody>
<g:each var="interview" in="${interviews}">
		<tr valign="middle">
			<td>${interview.id}</td>
			<td>${interview.startTime}</td>
			<td>${interview.status}</td>
			<td>
				<g:if test="${interview.status == 'O'}">
					<g:link action="runSession" id="${interview.id}">Resume</g:link> |
					<g:link action="closeSession" id="${interview.id}">Close</g:link> |
					<g:link action="deleteSession" id="${interview.id}">Delete</g:link>
				</g:if>
				<g:else>
					<g:link action="reopenSession" id="${interview.id}">Reopen</g:link> |
					<g:link action="deleteSession" id="${interview.id}">Delete</g:link>
				</g:else>
			</td>
		</tr>
</g:each>  
	</tbody>    
    </table>
  	<br/>
  	<g:link action="createNew">Create new session</g:link>
  </div>
</body>
</html>