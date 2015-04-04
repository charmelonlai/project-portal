# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#ADMIN-------------------------------
u = User.create({
  fname: "Admin",
  lname: "Admin",
  admin: true,
  email: "admin@admin.com",
  password: "password"
  })
u.confirmed_at = Time.now
u.save

#DEVELOPER
mc_user = User.create({
  fname: "Michelle",
  lname: "Chow",
  admin: false,
  email: "callmemc@gmail.com",
  password: "password"
  })
mc_user.confirmed_at = Time.now
mc_user.save
mc = Developer.create
mc_user.rolable = mc
mc_user.rolable_type = mc.class.name
mc_user.save


#ORGANIZATION: CS169------------------------
cs169_user = User.create({
  fname: "David",
  lname: "Patterson",
  admin: false,
  email: "pattrsn@eecs.berkeley.edu",
  password: "password",
  })
cs169_user.confirmed_at = Time.now
cs169_user.save
cs169 = Organization.create({
  sname: 'cs169',
  name: "UC Berkeley CS169 Software Engineering Course",
  description: "Over the course of a semester, students complete a course project in teams of four or five. Groups will be assigned to an external customer from a campus or non-profit organization to build a SaaS application.",
  website: "https://sites.google.com/site/ucbsaas/",
})
cs169_user.rolable = cs169
cs169_user.rolable_type = cs169.class.name
cs169_user.save

cs169_questions = Question.create([
  { question: "If selected, is the contact listed above available to speak on a weekly basis with a student from CS169?",
    input_type: "boolean"
  },
  { question: "If selected, will you and your organization fully commit to an engagement with CS169 for 8 weeks in Spring 2014?",
    input_type: "boolean"
  },
  { question: "Does the contact above have the ability to implement software solutions developed by the CS169 team?",
    input_type: "boolean"
  },
  { question: "Is this a software project?",
    input_type: "boolean"
  }
])
cs169.questions << cs169_questions

#ORGANIZATION: BLUEPRINT------------------------
bp_user = User.create({
  fname: "Kevin",
  lname: "Gong",
  admin: false,
  email: "calblueprint@gmail.com",
  password: "password",
  })
bp_user.confirmed_at = Time.now
bp_user.save
bp = Organization.create({
  sname: 'blueprint',
  name: "Blueprint, Technology for Non-Profits",
  description: "Our mission is to make beautiful engineering accessible and useful for those who create communities and promote public welfare.",
  website: "http://bptech.berkeley.edu",
})

bp_user.rolable = bp
bp_user.rolable_type = bp.class.name
bp_user.save

bp_questions = Question.create([
  { question: "Do you have the technical capabilities to deploy any solutions that Blueprint makes? (eg if Blueprint makes a website, will you be able to set up the domain name and server? Or will you require assistance from the Blueprint team?)",
    input_type: "boolean"
  },
  { question: "If selected, will you and your organization fully commit to an engagement with Blueprint for 11 weeks in Spring 2014?",
    input_type: "boolean"
  },
  { question: " If selected, will a representative of your company be available to meet at two-week intervals with the project team that Blueprint assigns to you?",
    input_type: "boolean"
  }
])
bp.questions << bp_questions

#CLIENT: ALTBREAKS-------------------------
altbreaks_user = User.create({
  fname: "Meena",
  lname: "Nagappan",
  admin: false,
  email: "client@admin.com",
  password: "password"
  })
altbreaks_user.confirmed_at = Time.now
altbreaks_user.save
altbreaks = Client.create({
  company_name: 'Alternative Breaks',
  company_site:'http://publicservice.berkeley.edu/alternativebreaks',
  company_address: '102 Sproul Hall, Berkeley, CA 94720',
  nonprofit: true,
  five_01c3: true,
  mission_statement: 'Alternative Breaks is a service-learning program for students to explore social issues through meaningful service, education, and reflection during their academic breaks.',
  contact_email: 'client@admin.com',
  contact_number: 'N/A'
  })
altbreaks_user.rolable = altbreaks
altbreaks_user.rolable_type = altbreaks.class.name
altbreaks_user.save

#PROJECT: ALTBREAKS SITE-------------------------
proj = Project.create({
  title: "AltBreaks Site",
  github_site: "https://github.com/callmemc/altbreaks",
  application_site: "http://publicservice.berkeley.edu/alternativebreaks",
  short_description: "Multipurpose website that serves both marketing purposes and internal purposes",
  long_description: "We want an interactive map to show all the trips, so that if you hover over a trip location, a pop-up is displayed with the trip information. We also want trip pages. And we want an internal forum where people from trips can communicate with each other and with people from other trips.",
  problem: "Solve communication issues internally within and between different break groups, as well as externally in creating a beautiful site that will increase our reputation and attract more applicants."
  })
proj.client = altbreaks
proj.organizations << bp
proj.questions = {'question_1' => true, 'question_2' => true, 'question_3' => true}
proj.project_type = "Web App"
proj.sector = "Community"
proj.approved = nil
proj.save

#PROJECT: PROJECT PORTAL REVAMP-------------------------
proj2 = Project.create({
  title: "Project Portal Revamp",
  github_site: "https://github.com/chrisbrown/project-portal",
  application_site: "http://projectportal.herokuapp.com/",
  short_description: "Web app that allows non-profit clients to propose software projects and developers to browse available projects to work on.",
  long_description: "Our existing app doesn't perform its core capacities very well, and we are hoping for a revamp that improves on 2 basic fronts: 1) allowing admins to properly view all projects and approve/deny in the app and 2) allows developers to browse in an easy way and decide which projects to work on.",
  problem: "Revamp the current project portal so both students and admins can use it easily and efficiently."
  })
proj2.client = altbreaks
proj2.organizations << bp
proj2.questions = {'question_1' => true, 'question_2' => true, 'question_3' => true}
proj2.project_type = "Design"
proj2.sector = "Technology"
proj2.approved = false
proj2.save

#PROJECT: VOLUNTEER MARKETPLACE----------------------------
proj3 = Project.create({
  title: "Volunteer Marketplace",
  github_site: "https://github.com/nitika_daga",
  application_site: "http://nitikadaga.com/",
  short_description: "Mobile app that allows potential volunteers to find opportunities that match their interests and skills.",
  long_description: "We are hoping to build an mobile app (on iOS) that allows potential volunteers to find opportunities near by to give back to their communinity. We have a large database of opportunities, so we are looking for a user-friendly way for community members to find opportunities on their phone.",
  problem: "Make our database of volunteer opportunities more available to the public."
  })
proj3.client = altbreaks
proj3.organizations << bp
proj3.questions = {'question_1' => true, 'question_2' => true, 'question_3' => true}
proj3.project_type = "Mobile"
proj3.sector = "Health"
proj3.approved = true
proj3.save