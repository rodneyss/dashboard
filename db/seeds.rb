# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
email = 'test@site.com'
pass  = 'password'
org   = 'org-fbte'
api_u = '72db99d0-05dc-0133-cefe-22000a93862b'
api_p = '_cIOpimIoDi3RIviWteOTA'

User.create(email: email, 
            password: pass, 
            organization: org, 
            api_user: api_u,
            api_pass: api_p 
            )