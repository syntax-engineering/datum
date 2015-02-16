## Datum: A flexible data-driven test solution for Rails

### Synopsis
Datum includes an easy-to-use mechanism for generating test cases based on data attributes. For more granular control when seeding the test database, Datum introduces Scenarios. By combining these features, Datum can be extremely useful and fun.


### Feature List
**1. Tests coupled with datasets**: Datum adds a data-driven extension to the default Rails testing infrastructure. When a data_test is defined, it is coupled with a dataset you define. For each dataset, a test case is generated greatly simplifying adding and removing additional cases.

**2. On-demand test database seeding**: Datum Scenarios are a per-test or per-test-class database seeding mechanism. Each Scenario can use any set of Models in a single file and can be self-contained or referenced via other Scenarios.

### Installing
Update your Gemfile with:

```ruby
gem 'datum'
```

Next run the bundle command:

```console
bundle install
```

### Usage

#### Data Driven Tests
To get started, let's assume we have a very simple Person Model in app/models/person.rb:

```ruby
class Person < ActiveRecord::Base

  validates_presence_of :first_name, :last_name

  # "John Doe" from first_name: "John", last_name: "Doe"
  def name
    "#{self.first_name} #{self.last_name}"
  end

  # "John D." from first_name: "John" last_name: "Doe"
  def short_name
    "#{self.first_name} #{self.last_name.capitalize[0]}."
  end
end
```

Now let's create a basic Person test in test/models/person_test.rb:

```ruby
require 'test_helper'
class PersonTest < ActiveSupport::TestCase
  test 'should confirm short_name' do
    person = Person.create first_name: "Marge", last_name: "Simpson"
    assert_equal "Marge S.", person.short_name
  end
end
```

When we execute this test, we get the following output:

```console
# Running:

.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

Now, let's say we want to make this test data-driven. First we'll go ahead and re-write our test:

```ruby
require 'test_helper'
class PersonTest < ActiveSupport::TestCase
  #test 'should confirm short_name' do
  #  person = Person.create first_name: "Marge", last_name: "Simpson"
  #  assert_equal "Marge S.", person.short_name
  #end

  data_test 'should_confirm_shortname' do
    person = Person.create first_name: @datum.first_name, last_name: @datum.last_name
    assert_equal @datum.short_name, person.short_name
  end
end
```

Here we replace our fixed values with @datum.[attribute]. To define our Datum, we'll create a file test/datum/data/should_confirm_shortname.rb:

```ruby
  # Sub-class the Datum struct with attributes we need for our test
  SimpleShortName = Datum.new(:first_name, :last_name, :short_name)

  # Define instances for our test cases
  SimpleShortName.new "Marge", "Simpson", "Marge S."
  SimpleShortName.new "Homer", "Simpson", "Homer S."
```

When we execute the data-driven test, we get the following output:

```console
# Running:

..

2 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

Of course as we add datasets, more test cases are generated.

test/datum/data/should_confirm_shortname.rb:

```ruby
  SimpleShortName = Datum.new(:first_name, :last_name, :short_name)

  # Define instances for our test cases
  SimpleShortName.new "Marge", "Simpson", "Marge S."
  SimpleShortName.new "Homer", "Simpson", "Homer S."
  SimpleShortName.new "Lisa", "Simpson", "Lisa S."
  SimpleShortName.new "Bart", "Simpson", "Bart S."
  SimpleShortName.new "Maggie", "Simpson", "Maggie S."
```

```console
# Running:

.....

5 runs, 5 assertions, 0 failures, 0 errors, 0 skips
```


### License

MIT License. Copyright 2012-2015 Tyemill. http://tyemill.com

You are not granted rights or licenses to the trademarks of Tyemill, including without limitation the Datum name or logo.

Datum struct uses ImprovedStruct and ImmutableStruct which are derivitive works based on ImmutableStruct by Theo Hultberg. This great class can be found here: [Immutable Struct](https://github.com/iconara/immutable_struct)