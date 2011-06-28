<!DOCTYPE html>
<html>
    <head>
        <title><g:layoutTitle default="Grails" /></title>
        <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
        <g:javascript library="application" />
        <g:layoutHead />
    </head>
    <body>
		<div style="background-color:#DDD; color:#444; padding:2px 4px; border-bottom:1px solid #AAA;">
			<table border="0" width="100%">
			<tr valign="middle">
				<td>
					<span style="font-size:120%; font-style:italic;">CodeShare</span>
				</td>
				<td align="right">
					<g:pageProperty name="page.headerRight"/>
				</td>
			</tr>
			</table>
		</div>

		<div style="padding:8px;">
	        <g:layoutBody />
		</div>
    </body>
</html>