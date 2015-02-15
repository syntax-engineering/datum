## Datum: A flexible data-driven test solution for Rails

### Synopsis
Datum includes an easy-to-use mechanism for generating test cases based on data attributes. For more granular control when seeding the test database, Datum introduces Scenarios. By combining these features, Datum can be extremely useful and fun.


### Feature List
**1. Data structures as a source for test generation**: Datum adds a data-driven extension to the default Rails testing infrastructure. The data_test method creates a data-driven test and cases are generated via the use of a simple data structure.

**2. Scenarios for improved test db seeding**: Datum Scenarios are a per-test or per test class database seeding mechanism. Each Scenario can use any Model, can be self-container or use smaller Scenarios.

**3. Test helpers and library functions loaded as needed**: To reduce the clutter of utility code, data-driven test generation and Scenario loading is further extended to enable per test and per test class libraries.


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



### License

MIT License. Copyright 2012-2015 Tyemill. http://tyemill.com

You are not granted rights or licenses to the trademarks of Tyemill, including without limitation the Datum name or logo.

Datum struct uses ImprovedStruct and ImmutableStruct which are derivitive works based on ImmutableStruct by Theo Hultberg. This great class can be found here: [Immutable Struct](https://github.com/iconara/immutable_struct)