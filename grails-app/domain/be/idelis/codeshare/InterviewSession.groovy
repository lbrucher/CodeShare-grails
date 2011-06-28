package be.idelis.codeshare

class InterviewSession {

	static transient OPEN = 'O';
	static transient CLOSED = 'C';

	Integer id;
	User interviewer;
	String candidateName;

	Date startTime = new Date();
	char status = 'O';		// O=open, C=closed

	String interviewerText;
	Date interviewerTextUpdateTime = null;
	String candidateText;
	Date candidateTextUpdateTime = null;

	static belongsTo = User

    static constraints = {
		id(unique:true)
    	candidateName(nullable:true)
    	interviewerText(nullable:true)
    	interviewerTextUpdateTime(nullable:true)
    	candidateText(nullable:true)
    	candidateTextUpdateTime(nullable:true)
    }
	
//	public boolean isOpen()
//	{
//		return status == 'O';
//	}
}
