Rails.application.routes.draw do
  root 'home#index'
  devise_for :employees
  namespace :admin do 
    resources :projects
    resources :employees
    resources :employee_projects
    resources :skills
  end

  namespace :employee do 
    get 'dashboard' => 'dashboard#index'
    get 'assignments' => 'dashboard#assignments'
    get 'timesheets' => 'timesheets#index'
    get 'log_time' => 'timesheets#log_time'
    get 'project_time_sheet' => 'timesheets#project_time_sheet'
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
