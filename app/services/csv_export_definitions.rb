# app/services/csv_export_definitions.rb
module CsvExportDefinitions
  TIME_LOG_HEADERS = ["ID", "Description", "Time in Hours", "Status", "Log Date", "Task Type", "Employee", "Task", "Project Title", "Created At", "Updated At"]
  TIME_LOG_MAPPINGS = [
    { method: ->(record) { record.id } },
    { method: ->(record) { record.description } },
    { method: ->(record) { record.time_in_hours } },
    { method: ->(record) { record.status } },
    { method: ->(record) { record.log_date } },
    { method: ->(record) { record.task_type } },
    { method: ->(record) { record.employee&.full_name } },
    { method: ->(record) { record.task&.title } },
    { method: ->(record) { record.employee_project&.project&.title } },
    { method: ->(record) { record.created_at } },
    { method: ->(record) { record.updated_at } }
  ]

  TASK_HEADERS = ["ID", "Title", "Number", "Project", "Created At"]
  TASK_MAPPINGS = [
    { method: ->(record) { record.id } },
    { method: ->(record) { record.title } },
    { method: ->(record) { record.number } },
    { method: ->(record) { record.project&.title } },
    { method: ->(record) { record.created_at } }
  ]
end
