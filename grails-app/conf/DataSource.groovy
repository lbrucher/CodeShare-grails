
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}

// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "create-drop" // one of 'create', 'create-drop','update'
            url = "jdbc:hsqldb:mem:devDB"
		    pooled = true
		    driverClassName = "org.hsqldb.jdbcDriver"
		    username = "sa"
		    password = ""
        }
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:hsqldb:mem:testDb"
		    pooled = true
		    driverClassName = "org.hsqldb.jdbcDriver"
		    username = "sa"
		    password = ""
        }
    }
    production {
        dataSource {
		    pooled = true
            dbCreate = "create-drop"
            url = "jdbc:mysql://localhost/codeshare-grails"
		    driverClassName = "com.mysql.jdbc.Driver"
			dialect = org.hibernate.dialect.MySQL5InnoDBDialect
		    username = "root"
		    password = ""
        }
    }
}
