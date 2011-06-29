import java.util.Date;

import be.idelis.codeshare.User
import be.idelis.codeshare.InterviewSession

class BootStrap {

    def init = { servletContext ->
		if (!User.count())
		{
			new User(username:"laurent").save(failOnError: true)
		}
		
		User laurent = User.findByUsername("laurent");
		
		if (!InterviewSession.count())
		{
			new InterviewSession(id:1,interviewer:laurent).save(failOnError: true)
		}
    }

    def destroy = {
    }
}
