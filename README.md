#NGO FRONT APP + API

## Table of Contents

1. [Ruby Version](#ruby-version)
2. [Rails Version](#rails-version)
3. [Install System Dependencies](#install-system-dependencies)
4. [Install the App](#install-the-app)
5. [Assets](#assets)
6. [Running Tests](#running-tests)
7. [Deploying](#deploying)


### Ruby Version

Ruby version is specified in both the `Gemfile` and `.ruby-version`. As of this writing, the Ruby version used is 2.3.1.


### Rails Version

Rails version is specified in the `Gemfile`. As of this writing, the Rails version used is 4.2.7.1


### Install System Dependencies

#### Install Homebrew:
Ensure you have [Homebrew](http://brew.sh/) installed on your machine. We'll use this to install further dependencies.

#### Install PostgreSQL:
```
  brew install postgresql
```

#### Install PostGIS:
```
  brew install postgis
```

#### Install Redis:
```
  brew install redis
```

#### Install rbenv (or any ruby version manager):
```
  brew install rbenv
  rbenv init
```
It is recommended that you double-check the [installation instructions](https://github.com/rbenv/rbenv#homebrew-on-mac-os-x) for installing rbenv with Homebrew. There is a git alternative to installing rbenv as well.

#### Install NVM:
It is recommended that you use [NVM](https://github.com/creationix/nvm) to install and manage your [Node](http://nodejs.org/) and corresponding npm versions.

```
  brew install nvm
```

The node version is documented in `.nvmrc`.  As of this writing, the Node version has been set to 0.10.29.


### Install the App

#### Repo
To get started, clone this repo:

```
  git clone git@github.com:InterActionNGO/ngoaidmap.git
```

#### Ruby
Install Ruby `2.3.1` with rbenv:
```
  rbenv install 2.3.1
```

#### Bundler
Install Bundler for gem dependencies:
```
  gem install bundler
```

Then run install to fetch the dependencies:
```
  bundle install
```

#### PostgreSQL
Start PostgreSQL:
```
  brew services start postgresql
```

Later, you may need to restart or stop PostgreSQL:
```
  #Restart PostgreSQL
  brew services restart postgresql

  #Stop PostgresQL
  brew services stop postgresql
```

#### Redis
Start redis:
```
  brew services start redis
```

Later, you may need to restart or stop redis:
```
  #Restart Redis
  brew services restart redis

  #Stop Redis
  brew services stop redis
```

#### Config files
Some application configuration should not be checked into source control. You need to create copies to run the app locally.

For the database:
```
  cp config/database.yml.sample config/database.yml
```

Then, update `config/database.yml` to match your setup. Here's what worked for me:

```
development:
  adapter: postgis
  encoding: unicode
  host: localhost
  database: iom_development
  username:
  password:
```

For your environment:
```
  cp .env.sample .env
```
Fill in this file as necessary.


#### Setup the database
We'll use `rake` to setup the database. This dependency should have been installed when you ran `bundle install` earlier on.

```
  bundle exec rake db:create
  bundle exec rake db:migrate
  bundle exec rake db:seed
```

#### Install NPM dependencies
We'll use NPM to install Bower and other npm dependencies. All dependency versions are locked to one version and recorded in `package.json`.

```
  # If using nvm, npm commands are not available 
  # until you install nvm
  nvm install

  npm install
```

NPM should have installed everything we need (including Bower). Now that Bower is installed, use it to install further vendor files:
```
  npm run bower
```
These vendor files will install at the directory `/public/app/vendor`.


#### Run the app
At this point, the application should be ready to run locally. Start the server:
```
  bundle exec rails s
```
Visit [http://localhost:3000](http://localhost:3000) in the browser. 🚀

If you ever need to access the Rails console while working, start that with:
```
  bundle exec rails c
```

### Assets
Work with assets in the `/app/assets` directory. The Rails pipeline will compile the assets as you work in development mode.


### Running Tests
TBD

### Deploying

Near as I can tell, production uses `rvm` to manage Ruby versions while staging uses `rbenv`. You'll need to alternate which
of [these lines](https://github.com/InterActionNGO/ngoaidmap/blob/master/Capfile#L17-L18) is commented out depending on the environment you're deploying to.

### License
Copyright (c) 2010 - 2017, InterAction

This program is free software: you can redistribute it and/or modify
it under the terms of the **GNU Affero General Public License** as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details. The full license text may be found in the project's [LICENSE](LICENSE) file or at http://www.gnu.org/licenses/.

### Credits
[![Browserstack](app/assets/images/browserstack.jpg)](http://browserstack.com/)
