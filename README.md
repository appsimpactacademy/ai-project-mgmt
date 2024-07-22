# AI-Project Management Project

Please go through the readme to setup this project locally on your system.

## Dependencies
* Ruby - 3.0 or later
* Rails - 7.0 or later
* NodeJS - 14.0 or later
* Yarn 1.22 or later

# Installation

To setup the project first clone it:
```
git clone https://github.com/appsimpactacademy/ai-project-mgmt.git
```
Install gems
```
cd ai-project-mgmt
bundle install
```
Run all migrations:
```
rails db:create
rails db:migrate
```
Install yarn packages:
```
yarn install
```

Build the application css:
```
yarn build:css
```

And the run the rails server to see the project on localhost:
```
rails server
```

And then open the project in the browser with [http://localhost:3000]
