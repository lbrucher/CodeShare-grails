
		<script>
		var lastOtherUpdateTime = ${otherTextLastUpdateTime};
		var otherUpdater = null;
		var myUpdater = null;

		function setOtherUpdater()
		{
			unsetOtherUpdater();
			otherUpdater = setTimeout("refreshOtherText()", 4000);
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
				//alert("["+lastOtherUpdateTime+"]");
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


		// Enables tabbing in text area
		// Credit goes to See[Mike]Code, http://i.seemikecode.com
		//		
		function textarea_onkeydown(evt)
		{
			var e = window.event || evt;
			var k = e.keyCode ? e.keyCode : e.charCode ? e.charCode : e.which;
			if (k == 9) {
				var t = e.target ? e.target : e.srcElement ? e.srcElement : e.which;
				if (t.setSelectionRange)
				{	// chrome 1.0...
					e.preventDefault();
					var ss = t.selectionStart;
					var se = t.selectionEnd;
					var pre = t.value.slice(0, ss);
					var post = t.value.slice(se, t.value.length);
					t.value = pre + "\t" + post;
					t.selectionStart = ss + 1;
					t.selectionEnd = t.selectionStart;
				}
				else
				{	// ie6...
					e.returnValue = false;
					var r = document.selection.createRange();
					r.text = "\t";
					r.setEndPoint("StartToEnd", r);
					r.select();
				}
			}
		}


		function textarea_textChanged()
		{
			if (myUpdater != null)
				clearTimeout(myUpdater);
			myUpdater = setTimeout("updateMyText()", 1000);
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
	
		<table border="0">
		<tr valign="top">
			<td>
				<b>${myScreenLabel}:</b><br/>
				<textarea id="myText" rows="20" cols="80" onkeydown="textarea_onkeydown(event)" onkeyup="textarea_textChanged()">${myText}</textarea>
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
