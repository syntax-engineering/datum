##### Datum is currently under development and pre-1.0

## Datum

Datum is a simple take on Data Driven Testing for Rails. Datum:

* Enables a table to drive a test case
* Quick conversion from data-driven via a database to via a file
* Dump tables to fixtures for scc storage
* Load tables from fixtures
* Generate datum specific migrations and models

## Rails 3

Datum is still in development. Currently, we're working with Rails 3.2.6 and Ruby 1.9.3. 

For now, our target test framework is <b>Test::Unit</b>.

## Getting Started

Datum is a simple tool for data driven testing. If you have a test case that you can parameterize and want to manage your parameters via a database, Datum is fun.

### Setting Up

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

Additionally, Enable will further prompt you for permission to verify all core Datum functionality. Verification will include all basic Datum rake tasks along with execution of tests that use Datum's drive_with. 

<span style="color: red;">WARNING:</span> Enable's verification <b>WILL DROP the Datum Database</b>. If you are re-installing Datum, be sure to back-up your Datum store BEFORE running Enable.

When finished, you are ready to create a Datum specific database and add migrations and models. 

### Creating a Datum Specific Database and Tables

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

You are now ready to put data in a newly created table.

### Binding a Test Case to a Table

When writing a unit test or functional test with <b>Test::Unit</b>, bind your test case to your table with drive_with.

```ruby
test "vote_counter should count positive votes" do
  drive_with :table_items
```

Once bound to your table, drive_with will work with the Datum infrastructure so that your test case will execute once for every row in the table.

To access the current row, use the datum accessor:

```ruby
test "vote_counter should count positive votes" do
  drive_with :table_items
  puts "starting test case..."
  puts "the current id of the row: #{datum.id}"
```

Will output:

```console
  starting test case...
  1
  
  starting test case...
  2
  
  starting test case...
  3
```
### Move Datum Table Data Beyond the Datum Database

To convert your Datum tables to fixtures (for storage in scc, etc)

```console
rake datum:db:dump
```

To get Datum data from fixtures into the Datum specific database:

```console
rake datum:db:load
```

To convert a Datum table into a file so that drive_with does <b>not</b> use the table (and is thus <b>not</b> dependent on a Datum database / settings / etc) 

```console
rake datum:db:localize[table_items]
```

## Troubleshooting

### In Development
Datum is still being created and isn't officially *ready*. It's likely that we have code paths that are not fully tested and some that are plain broken. Stay tuned for a 1.0.

## Additional Information

### Tyemill
Tyemill is a technology company in Seattle, Washington. We make a few line-of-business applications and love Ruby, Rails and Open Source.

## License
(The MIT License)

Copyright 2012 Tyemill LLC. http://tyemill.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.