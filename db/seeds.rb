# Seed data for Companies
Company.create!(
  name: "ABC Inc.",
  about: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  email: "info@abcinc.com",
  contact_number: "+1234567890",
  domain: "abcinc.com"
)
Company.create!(
  name: "XYZ Corp.",
  about: "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  email: "info@xyzcorp.com",
  contact_number: "+1987654321",
  domain: "xyzcorp.com"
)

# Seed data for Projects
Project.create!(
  title: "Website Redesign",
  client_name: "Big Client Co.",
  client_company: "Big Client Inc.",
  start_date: Date.today - 30,
  end_date: Date.today + 30,
  status: "In Progress",
  company_id: 1
)

Project.create!(
  title: "Mobile App Development",
  client_name: "New Startup",
  client_company: "Startup Inc.",
  start_date: Date.today - 45,
  end_date: Date.today + 60,
  status: "Pending",
  company_id: 2
)

# Create skills, hobbies, education records, and work experiences to associate with the employee
skills = [
  Skill.create!(name: 'Ruby on Rails'),
  Skill.create!(name: 'JavaScript'),
  Skill.create!(name: 'Project Management')
]

hobbies = [
  Hobby.create!(name: 'Reading'),
  Hobby.create!(name: 'Hiking')
]

# Seed data for Employees
Employee.create!(
  first_name: "John",
  last_name: "Doe",
  email: "john.doe@example.com",
  contact_number: "9867895645",
  job_title: "Developer",
  company_id: 1,
  password: "111111",
)

Employee.create!(
  first_name: "Jane",
  last_name: "Smith",
  email: "jane.smith@example.com",
  contact_number: "9087654323",
  job_title: "Designer",
  company_id: 2,
  password: "111111",
)

work_experiences = [
  WorkExperience.create!(
    job_title: 'Software Developer',
    company_name: 'ABC Ltd',
    start_date: '2018-01-01',
    end_date: '2020-01-01',
    employee_id: 1,
    role: 'Developer',
    description: 'Worked on building web applications using Ruby on Rails, contributed to backend and frontend development.'
  ),
  WorkExperience.create!(
    job_title: 'Project Manager',
    company_name: 'XYZ Corp',
    start_date: '2020-02-01',
    end_date: '2023-01-01',
    employee_id: 1,
    role: 'Manager',
    description: 'Led multiple software development teams, responsible for project planning, resource allocation, and client communication.'
  )
]

education_records = [
  EducationRecord.create!(college_or_university: 'XYZ University', course_name: 'BSc Computer Science', start_year: '2014', end_year: '2018', employee_id: 1, marks: 40),
  EducationRecord.create!(college_or_university: 'XYZ University', course_name: 'MSc Computer Science', start_year: '2019', end_year: '2020', employee_id: 1, marks: 90)
]



# Seed data for EmployeeSkills
EmployeeSkill.create!(
  employee_id: 1,
  skill_id: 1
)

EmployeeSkill.create!(
  employee_id: 2,
  skill_id: 2
)

# Seed data for EmployeeProjects
EmployeeProject.create!(
  employee_id: 1,
  project_id: 1,
  start_date: Date.today - 20,
  end_date: Date.today + 10,
  role: "Developer",
  current_status: "Active"
)

EmployeeProject.create!(
  employee_id: 2,
  project_id: 2,
  start_date: Date.today - 30,
  end_date: Date.today + 30,
  role: "Designer",
  current_status: "Active"
)

# Seed data for Tasks
Task.create!(
  number: "T001",
  title: "Implement Login Page",
  project_id: 1,
  employee_id: 1
)

Task.create!(
  number: "T002",
  title: "Design UI Mockups",
  project_id: 2,
  employee_id: 2
)


# Generate Time Logs for Different Periods

# Past 7 Days
(1..15).each do |i|
  TimeLog.create!(
    description: "Task #{i} progress update - Past 7 Days",
    time_in_hours: rand(1.0..8.0).round(1),
    status: ["Completed", "In Progress", "Pending"].sample,
    log_date: Date.today - rand(1..7),
    task_type: ["Development", "Design", "Testing"].sample,
    employee_id: Employee.pluck(:id).sample,
    task_id: Task.pluck(:id).sample,
    employee_project_id: EmployeeProject.pluck(:id).sample
  )
end

# Past 15 Days
(1..15).each do |i|
  TimeLog.create!(
    description: "Task #{i} progress update - Past 15 Days",
    time_in_hours: rand(1.0..8.0).round(1),
    status: ["Completed", "In Progress", "Pending"].sample,
    log_date: Date.today - rand(8..15),
    task_type: ["Development", "Design", "Testing"].sample,
    employee_id: Employee.pluck(:id).sample,
    task_id: Task.pluck(:id).sample,
    employee_project_id: EmployeeProject.pluck(:id).sample
  )
end

# This Month
(1..15).each do |i|
  TimeLog.create!(
    description: "Task #{i} progress update - This Month",
    time_in_hours: rand(1.0..8.0).round(1),
    status: ["Completed", "In Progress", "Pending"].sample,
    log_date: Date.today.beginning_of_month + rand(0..Date.today.day - 1),
    task_type: ["Development", "Design", "Testing"].sample,
    employee_id: Employee.pluck(:id).sample,
    task_id: Task.pluck(:id).sample,
    employee_project_id: EmployeeProject.pluck(:id).sample
  )
end

# Previous Month
(1..15).each do |i|
  TimeLog.create!(
    description: "Task #{i} progress update - Previous Month",
    time_in_hours: rand(1.0..8.0).round(1),
    status: ["Completed", "In Progress", "Pending"].sample,
    log_date: Date.today.prev_month.beginning_of_month + rand(0..Date.today.prev_month.end_of_month.day - 1),
    task_type: ["Development", "Design", "Testing"].sample,
    employee_id: Employee.pluck(:id).sample,
    task_id: Task.pluck(:id).sample,
    employee_project_id: EmployeeProject.pluck(:id).sample
  )
end

# Overall Data
(1..20).each do |i|
  TimeLog.create!(
    description: "Task #{i} progress update - Overall",
    time_in_hours: rand(1.0..8.0).round(1),
    status: ["Completed", "In Progress", "Pending"].sample,
    log_date: Date.today - rand(1..90),  # Random date within the last 90 days
    task_type: ["Development", "Design", "Testing"].sample,
    employee_id: Employee.pluck(:id).sample,
    task_id: Task.pluck(:id).sample,
    employee_project_id: EmployeeProject.pluck(:id).sample
  )
end
