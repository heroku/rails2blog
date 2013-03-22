# Blog

Example of a Rails2 blog. This repo is used for testing Rails2 deploys.

## Local testing and development

Install system dependencies:

    $ gem install bundler
    $ bundle install

Copy `.env.sample`

    $ cp .env.sample .env


To start a server:

    $ foreman start


Run console on Heroku:

    $ heroku run ./script/console