package be.idelis.codeshare
import grails.converters.*

class InterviewerController {

	private static boolean isDebug = false;

    def index = {
		def interviewer = User.findByUsername("laurent");
		[interviews: InterviewSession.findByInterviewer(interviewer)];
	}

	def toggleDebug = {
		isDebug = !isDebug
		redirect(action:runSession, params:[id:params.id])
	}	

	def createNew = {
		def interviewer = User.findByUsername("laurent");
		def isession = new InterviewSession(id:1,interviewer:laurent,candidateName:"joe").save(failOnError: true)

		redirect(action:runSession, params:[id:isession.id])
	}

	def runSession = {
		def isession = getOpenSession(params.id);
		if (isession == null || isession.status == InterviewSession.CLOSED)
		{
			redirect(action:index); return;
		}

		[
			sessionId:isession.id,
			myText:isession.interviewerText,
			otherText:isession.candidateText,
			otherTextLastUpdateTime:isession.candidateTextUpdateTime == null ? 0 : isession.candidateTextUpdateTime.getTime(),

			isDebug:isDebug,
			urlRefreshOtherText:"../refreshOtherText",
			urlUpdateMyText:"../updateMyText",
			urlSessionClosed:"..",
			myScreenLabel:"Interviewer screen",
			otherScreenLabel:"Candidate screen",
		];
	}

	def closeSession = {
		def isession = getOpenSession(params.id);
		if (isession == null)
		{
			redirect(action:index); return;
		}

		isession.status = InterviewSession.CLOSED;
		isession.save(flush:true);

		redirect(action:index)
	}
	
	def reopenSession = {
		def isession = InterviewSession.findById(params.id);
		if (isession == null)
		{
			redirect(action:index); return;
		}

		isession.status = InterviewSession.OPEN;
		isession.save(flush:true);

		redirect(action:runSession, params:[id:isession.id])
	}

	def deleteSession = {
		def isession = InterviewSession.findById(params.id);
		if (isession == null)
		{
			redirect(action:index); return;
		}

		isession.delete(flush:true);

		redirect(action:index)
	}

	def getOpenSession = { id ->
		def isession = InterviewSession.findById(id);
		if (isession != null)
		{
			if (isession.status == InterviewSession.OPEN)
				return isession;
		}
		return null;
    }

	def getRefreshCandidateTextResponse = { isession, lastCandidateUpdateTime ->
		// see if we need to return an updated candidate text
		def returnMap;
		if (isession.candidateTextUpdateTime != null && isession.candidateTextUpdateTime.getTime() > lastCandidateUpdateTime.toLong())
		{
			// return candidate text & its updated last update time, as JSON...
			[
				sessionOpen:true,
				hasOtherText:true,
				otherText:isession.candidateText,
				lastOtherUpdateTime:isession.candidateTextUpdateTime.getTime()
			]
		}
		else
		{
			[sessionOpen:true, hasOtherText:false]
		}
	}

	def updateMyText = {
		def model;
		def isession = InterviewSession.findById(params.id);
		if (isession == null || isession.status == InterviewSession.CLOSED)
		{
			model = [sessionOpen:false]
		}
		else
		{
			// update interviewer text if one was provider
			if (params.hasMyText)
			{
				isession.interviewerText = params.myText;
				isession.interviewerTextUpdateTime = new Date();
				isession.save(flush:true);
			}
	
			model = getRefreshCandidateTextResponse(isession, params.lastOtherUpdateTime)
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
			model = getRefreshCandidateTextResponse(isession, params.lastOtherUpdateTime)
		}
		render model.encodeAsJSON()
	}
}
