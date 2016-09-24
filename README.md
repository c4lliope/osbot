# Osbot

## Getting Started

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    %> ./bin/setup

It assumes you have a machine equipped with at least Ruby (2.3.0), Postgres, and XCode (possibly some others). If not, set up your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

## Setting up GitHub authentication

Sign into GitHub,
then [register for an OAuth ID and secret][github new app]
for your application's development environment.
Use the details:

* Application Name: Osbot Development
* Homepage URL: `http://localhost:3000`
* Authorization Callback URL: `http://localhost:3000`

On the confirmation screen,
copy the Client ID and Client Secret
to `GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`
in the `.env.local` file.

[github new app]: https://github.com/settings/applications/new

## Running the App

After setting up, you can run the application using [Heroku Local]:

    %> heroku local

Visit <http://localhost:3000/gh/graysonwright/osbot> to see the site in action.

For something a bit more exciting, try:

* <http://localhost:3000/gh/thoughtbot/administrate>
* <http://localhost:3000/gh/codeforamerica/streetmix>

Also try to visit the repo page
for a repository that you have admin permissions on.
You should be able to see information about the access rights that people have.

The first time you load the page for a repository,
the app will take a significant amount of time
to request all of the contributor activity on the repository.
Requests are cached in the `cache` folder at the root of the repository,
so following requests will complete in a more reasonable time.

You can watch the logs to see the cache-writing process –
it should look like:

```ruby
CACHE: Miss, cache/graysonwright/osbot/contributors.yml does not exist
CACHE: Miss, cache/graysonwright/osbot/github/issues_comments.yml does not exist
CACHE: Writing repsonse to cache/graysonwright/osbot/github/issues_comments.yml
CACHE: Miss, cache/graysonwright/osbot/github/issues.yml does not exist
CACHE: Writing repsonse to cache/graysonwright/osbot/github/issues.yml
CACHE: Miss, cache/graysonwright/osbot/github/pulls.yml does not exist
CACHE: Writing repsonse to cache/graysonwright/osbot/github/pulls.yml
CACHE: Miss, cache/graysonwright/osbot/github/pull_comments.yml does not exist
CACHE: Writing repsonse to cache/graysonwright/osbot/github/pull_comments.yml
CACHE: Miss, cache/graysonwright/osbot/github/collaborators.yml does not exist
CACHE: Writing repsonse to cache/graysonwright/osbot/github/collaborators.yml
CACHE: Writing repsonse to cache/graysonwright/osbot/contributors.yml
```

[Heroku Local]: https://devcenter.heroku.com/articles/heroku-local

## Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
