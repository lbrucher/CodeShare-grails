package be.idelis.codeshare

class User {

	String username;
	Byte[] password;
	String lastname;
	String firstname;
	Date creationDate = new Date();
	Date lastLogin;
	
    static constraints = {
		username(unique:true)
		lastname(nullable:true)
		firstname(nullable:true)
		lastLogin(nullable:true)
		password(nullable:true)
    }
}
