Rails.application.routes.draw do
  root 'home#index'
  devise_for :employees, controllers: {
    sessions: 'employees/sessions',
    registrations: 'employees/registrations',
    passwords: 'employees/passwords',
    confirmations: 'employees/confirmations'
  }
  devise_scope :employee do 
    get '/employee_detail/:id' => 'employees/registrations#employee_detail', as: :employee_detail
    get '/select_template' => 'employees/registrations#select_template', as: :select_template
    get '/preview_template/:id' => 'employees/registrations#preview_template', as: :preview_template
    get '/get_resume/:id' => 'employees/registrations#get_resume', as: :get_resume
  end
  namespace :employees do
    resources :profiles, only: [:show, :update]
  end
  
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
end
