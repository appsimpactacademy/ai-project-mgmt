# config/initializers/active_storage.rb
Rails.application.reloader.to_prepare do
  ActiveStorage::Current.url_options = {
    host: 'http://localhost:3000' # Replace with the correct host for your environment
  }
end
