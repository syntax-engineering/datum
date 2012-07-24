# Datum is currently under development and pre-1.0

## Datum

Datum is a simple take on Data Driven Testing for Rails. Datum:

* Enables a table to drive a test case
* Quick conversion from data-driven via a database to via a file
* Dump tables to fixtures for scc storage
* Load tables from fixtures
* Generate datum specific migrations and models

## Rails 3

Datum is still in development. Currently, we're working with Rails 3.2.6 and Ruby 1.9.3.

### Getting Started

Add Datum to your Gemfile:

```ruby
  gem 'datum'
```

Run the bundle command to install it.

After you install Datum and add it to your Gemfile, you need to enable it:

```console
rake datum:enable
```

Enable will create several directories in your test directory. It will also prompt you to ask for permission to update your database.yml and application.rb. You MUST review both files even if you have Enable update them for you.

When finished, you are ready to create a Datum specific database and add migrations and models. 

To create a Datum specific database:

```console
rake datum:db:create
```

To generate Datum specific migrations and models, the command and options are similar to using Rails scaffolds.

```console
rails generate datum ModelName column_one:type column_two:type
```

Models and migrations are placed in your application under test/lib/datum/models and test/lib/datum/migrate. Edit these files as needed. When you are ready to migrate use the Datum migration command.

```console
rake datum:db:migrate
```

You are now ready to put data in the table. 
