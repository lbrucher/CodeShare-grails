<%@ page contentType="text/html;charset=ISO-8859-1" %>
<!DOCTYPE html>
<html>
    <head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1"/>
        <title><g:layoutTitle default="CodeShare" /></title>
        <link rel="stylesheet" href="${resource(dir:'css',file:'main.css')}" />
        <link rel="shortcut icon" href="${resource(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
        <g:layoutHead />
        <g:javascript library="application" />
		<g:javascript library="prototype" />

		<script>
		var lastOtherUpdateTime = ${otherTextLastUpdateTime};
		var otherUpdater = null;
	
		function setOtherUpdater()
		{
			unsetOtherUpdater();
			otherUpdater = setTimeout("refreshOtherText()", 5000);
		}
	
		function unsetOtherUpdater()
		{
			if (otherUpdater != null)
				clearTimeout(otherUpdater);
			otherUpdater = null;
		}
	
		function updateOtherText(data)
		{
			if (!data.sessionOpen)
			{
				window.location.href = "${urlSessionClosed}";
				return;
			}

			log("Updated other data: "+data.hasOtherText);
			if (data.hasOtherText)
			{
				lastOtherUpdateTime = data.lastOtherUpdateTime;
				document.getElementById("otherText").value = data.otherText;
			}
		}
	
		function refreshOtherText()
		{
			try
			{
				log("Requesting other text update...");
	
				new Ajax.Request('${urlRefreshOtherText}', {
					method:'post',
					parameters:{
						id:${sessionId},
						lastOtherUpdateTime:lastOtherUpdateTime
					},
					onSuccess: function(transport){
						updateOtherText(transport.responseText.evalJSON());
						setOtherUpdater();
					},
					onFailure: function() {
						log("FAILED updating other text!");
						setOtherUpdater();
					}
				});
			}
			catch(e)
			{
				setOtherUpdater();
			}
		}
	
	
		function updateMyText()
		{
			unsetOtherUpdater();
	
			try
			{
				log("Sending updated my text...");
	
				new Ajax.Request('${urlUpdateMyText}', {
					method:'post',
					parameters:{
						id:${sessionId},
						hasMyText:true,
						myText:document.getElementById("myText").value,
						lastOtherUpdateTime:lastOtherUpdateTime
					},
					onSuccess: function(transport){
						updateOtherText(transport.responseText.evalJSON());
						setOtherUpdater();
					},
					onFailure: function() {
						log("FAILED updating my text!");
						setOtherUpdater();
					}
				});
			}
			catch(e)
			{
				setOtherUpdater();
			}
		}
	
	<g:if test="${isDebug}">
		var logCounter = 0;
		function log(msg)
		{
			var el = document.getElementById("log");
			el.innerHTML = (++logCounter) + ": " + msg + "<br/>" + el.innerHTML;
		}
	</g:if>
	<g:else>
		function log(msg)
		{
		}
	</g:else>
	
		setOtherUpdater(true);
		</script>
    </head>

    <body>
		<div style="background-color:#999; color:#EEE; padding:4px 4px;">
			<table border="0" width="100%">
			<tr valign="middle">
				<td>
					<span style="font-size:12pt;">CodeShare</span>
				</td>
				<td align="right">
					Session #${sessionId}.
					Close session.
					Logout
				</td>
			</tr>
			</table>
		</div>

		<div style="padding:8px;">
	        <g:layoutBody />
	
	<a href="javascript:updateMyText();">Refresh</a>
	<br/><br/>
	
			<table border="0">
			<tr valign="top">
				<td>
					<b>${myScreenLabel}:</b><br/>
					<textarea id="myText" rows="20" cols="80">${myText}</textarea>
				</td>
				<td style="width:20px;"></td>
				<td>
					<b>${otherScreenLabel}:</b><br/>
					<textarea id="otherText" rows="20" cols="80" readonly="readonly">${otherText}</textarea>
				</td>
	<g:if test="${isDebug}">
				<td style="padding-left:5px;">
					<div id="log" class="log"></div>
				</td>
	</g:if>		
			</tr>
			</table>
		</div>
    </body>
</html>
