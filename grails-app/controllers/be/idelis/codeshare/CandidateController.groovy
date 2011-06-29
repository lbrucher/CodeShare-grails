package be.idelis.codeshare

class CandidateController {

	def isDebug = false;

    def index = {
	}

	def register = {
		if (params.code == null || params.code.isEmpty())
		{
			chain(action:index, model:[errorMessage:"Missing code!"]); return
		}

		def code=null;
		try {
			code = params.code.toLong();
		}
		catch(e) {
			code = null;
		}
		
		
		// Find interview session
		def isession = code == null ? null : InterviewSession.findById(code);
		if (isession == null)
		{
			chain(action:index, model:[code:params.code, errorMessage:"Invalid code!"]); return
		}

		redirect(action:runSession, params:[id:code])
    }
	
	def runSession = {
		def isession = InterviewSession.findById(params.id);
		if (isession == null)
		{
			redirect(action:index); return
		}

		if (isession.status == InterviewSession.CLOSED)
		{
			redirect(action:sessionClosed); return;
		}
				
		
		[
			sessionId:isession.id,
			myText:isession.candidateText,
			otherText:isession.interviewerText,
			otherTextLastUpdateTime:isession.interviewerTextUpdateTime == null ? 0 : isession.interviewerTextUpdateTime.getTime(),

			isDebug: isDebug,
			urlRefreshOtherText:"../refreshOtherText",
			urlUpdateMyText:"../updateMyText",
			urlSessionClosed:"../sessionClosed",
			myScreenLabel:"Your screen",
			otherScreenLabel:"Interviewer screen",
		];
	}

	def sessionClosed = {
   	}
	
	def getRefreshInterviewerTextResponse = { isession, lastInterviewerUpdateTime ->
		// see if we need to return an updated interviewer text
		def returnMap;
		if (isession.interviewerTextUpdateTime != null && isession.interviewerTextUpdateTime.getTime() > lastInterviewerUpdateTime.toLong())
		{
			// return Interviewer text & its updated last update time, as JSON...
			[
				sessionOpen:true,
				hasOtherText:true,
				otherText:isession.interviewerText,
				lastOtherUpdateTime:isession.interviewerTextUpdateTime.getTime()
			]
		}
		else
		{
			[sessionOpen:true, hasOtherText:false]
		}
	}

	def updateMyText = {
		def isession = InterviewSession.findById(params.id);
		def model;
		if (isession == null || isession.status == InterviewSession.CLOSED)
		{
			model = [sessionOpen:false]
		}
		else
		{
			// update candidate text if one was provider
			if (params.hasMyText)
			{
				isession.candidateText = params.myText;
				isession.candidateTextUpdateTime = new Date();
				isession.save(flush:true);
			}

			model = getRefreshInterviewerTextResponse(isession, params.lastOtherUpdateTime)
		}
		
		render model.encodeAsJSON()
	}
	
	def refreshOtherText = {
		def model;
		def isession = InterviewSession.findById(params.id);
		if (isession == null || isession.status == InterviewSession.CLOSED)
		{
			model = [sessionOpen:false]
		}
		else
		{
			model = getRefreshInterviewerTextResponse(isession, params.lastOtherUpdateTime)
		}
		render model.encodeAsJSON()
	}
}
