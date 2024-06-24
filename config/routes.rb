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
  end
end
