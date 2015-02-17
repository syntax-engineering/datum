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

### Simple Examples

#### data_test: Data Driven Tests for Rails
To get started, we'll look at a simple Person Model app/models/person.rb:

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

Now let's create a test test/models/person_test.rb:

```ruby
require 'test_helper'
class PersonTest < ActiveSupport::TestCase
  test 'should confirm short_name' do
    person = Person.create first_name: "Marge", last_name: "Simpson"
    assert_equal "Marge S.", person.short_name
  end
end
```

Executing the test:

```console
# Running:

.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

To convert our test to be data-driven - test/models/person_test.rb:

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

In the data_test, the fixed values of the original test have been replaced with the usage of the @datum.[attribute] variables. For each dataset defined, the data_test will be called and @datum will provide access.

Next, we'll define our Datum and data in test/datum/data/should_confirm_shortname.rb:

```ruby
  # Sub-class the Datum struct with attributes we need for our test
  SimpleShortName = Datum.new(:first_name, :last_name, :short_name)

  # Define instances for our test cases
  SimpleShortName.new "Marge", "Simpson", "Marge S."
  SimpleShortName.new "Homer", "Simpson", "Homer S."
```

Executing:

```console
# Running:

..

2 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

Adding more datasets and thus more generated test cases test/datum/data/should_confirm_shortname.rb:

```ruby
  SimpleShortName = Datum.new(:first_name, :last_name, :short_name)

  # Define instances for our test cases
  SimpleShortName.new "Marge",  "Simpson", "Marge S."
  SimpleShortName.new "Homer",  "Simpson", "Homer S."
  SimpleShortName.new "Lisa",   "Simpson", "Lisa S."
  SimpleShortName.new "Bart",   "Simpson", "Bart S."
  SimpleShortName.new "Maggie", "Simpson", "Maggie S."
```

```console
# Running:

.....

5 runs, 5 assertions, 0 failures, 0 errors, 0 skips
```

#### Scenarios: On-demand Test Database Seeding
To get started, we'll look at a simple Person Model app/models/person.rb:

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

Now let's create a test test/models/person_test.rb:

```ruby
require 'test_helper'
class PersonTest < ActiveSupport::TestCase
  test 'should confirm short_name' do
    person = Person.create first_name: "Marge", last_name: "Simpson"
    assert_equal "Marge S.", person.short_name
  end
end
```

Instead of using a Fixture or defining our variables in-line, we'll modify our test to use a Scenario. First, let's define the Scenario test/datum/scenarios/simpsons_scenario.rb:

```ruby
 @marge = Person.create(first_name: "Marge", last_name: "Simpson")
 @homer = Person.create(__clone(@marge, {first_name: "Homer"}))
```

Now, let's modify our test, test/models/person_test.rb:

```ruby
require 'test_helper'
class PersonTest < ActiveSupport::TestCase
  test 'should confirm short_name' do
    process_scenario :simpsons_scenario
    assert_equal "Marge S.", @marge.short_name
    assert_equal "Homer S.", @homer.short_name
  end
end
```

#### Data-Driven Tests Combined with On-Demand Test DB Seeding
To get started, we'll look at a simple Person Model app/models/person.rb:

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

Now let's define a data_test test/models/person_test.rb:

```ruby
require 'test_helper'
class PersonTest < ActiveSupport::TestCase
  data_test 'should_confirm_shortname' do
    person = Person.create first_name: @datum.first_name, last_name: @datum.last_name
    assert_equal @datum.short_name, person.short_name
  end
end
```

Let's add some initial data test/datum/data/should_confirm_shortname.rb:

```ruby
  SimpleShortName = Datum.new(:first_name, :last_name, :short_name)

  # Define instances for our test cases
  m = SimpleShortName.new "Marge",  "Simpson", "Marge S."
  SimpleShortName.new "Homer",  m.last_name, "Homer S."
  SimpleShortName.new "Lisa",   m.last_name, "Lisa S."
  SimpleShortName.new "Bart",   m.last_name, "Bart S."
  SimpleShortName.new "Maggie", m.last_name, "Maggie S."
```

Now let's define a Scenario test/datum/scenarios/simpsons_scenario.rb:

```ruby
 @marge   = Person.create(first_name: "Marge", last_name: "Simpson")
 @homer   = Person.create(__clone(@marge, {first_name: "Homer"}))
 @lisa    = Person.create(__clone(@marge, {first_name: "Lisa"}))
 @bart    = Person.create(__clone(@marge, {first_name: "Bart"}))
 @maggie  = Person.create(__clone(@marge, {first_name: "Maggie"}))
```

Now let's update our data_test to make use of our Scenario test/models/person_test.rb:

```ruby
require 'test_helper'
class PersonTest < ActiveSupport::TestCase
  data_test 'should_confirm_shortname' do
    process_scenario :simpsons_scenario
    person = self.instance_variable_get("@#{@datum.first_name.downcase}")
    assert_equal @datum.first_name, person.first_name
    assert_equal @datum.last_name, person.last_name
    assert_equal @datum.short_name, person.short_name
  end
end
```

Executing the test:

```console
# Running:

.....

5 runs, 15 assertions, 0 failures, 0 errors, 0 skips
```

### Real-World Examples (Not Finished)
A Model Test to verify addresses from different countries:

```ruby
require 'test_helper'
class AddressLabelTest < ActiveSupport::TestCase

  # makes use of 'AddressLabel' Model
  data_test 'should_verify_address_labels' do
    # label = AddressLabel.create

    #assert_equal @datum.
    #assert_equal @datum.
    #assert_equal @datum.
  end
end
```

A Functional Test to verify CRUD with different permissions:

```ruby
require 'test_helper'
class AddressLabelTest < ActiveSupport::TestCase

  # makes use of 'AddressLabel' Model
  data_test 'should_verify_address_labels' do
    # label = AddressLabel.create

    #assert_equal @datum.
    #assert_equal @datum.
    #assert_equal @datum.
  end
end
```



### License

MIT License. Copyright 2012-2015 Tyemill. http://tyemill.com

You are not granted rights or licenses to the trademarks of Tyemill, including without limitation the Datum name or logo.

Datum struct uses ImprovedStruct and ImmutableStruct which are derivitive works based on ImmutableStruct by Theo Hultberg. This great class can be found here: [Immutable Struct](https://github.com/iconara/immutable_struct)