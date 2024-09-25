Rails.application.routes.draw do
  root 'home#index'
  devise_for :employees, controllers: {
    sessions: 'employees/sessions',
    registrations: 'employees/registrations',
    passwords: 'employees/passwords',
    confirmations: 'employees/confirmations'
  }
  namespace :admin do 
    resources :projects
    resources :employees
    resources :employee_projects
    resources :skills
    resources :templates
  end

  namespace :employee do
    get 'dashboard' => 'dashboard#index'
    get 'assignments' => 'dashboard#assignments'
    get 'dashboard/export_time_logs/:id', to: 'dashboard#export_time_logs', as: :export_time_logs
    get 'timesheets' => 'timesheets#index'
    get 'log_time' => 'timesheets#log_time'
    get 'project_time_sheet' => 'timesheets#project_time_sheet'
    get 'assign_task' => 'tasks#assign_task'
    post 'assign_task_to_employee' => 'tasks#assign_task_to_employee'
    resources :tasks do
      collection do 
        get :fetch_project_tasks
      end
    end
    resources :time_logs do 
      collection do
        get :fetch_logged_dates
      end
    end
  end
  get 'select-template' => 'home#select_template'
  get 'get_resume/:id' => 'home#get_resume', as: :get_resume
  get 'download_template/:id' => 'home#download_template', as: :download_template
end
