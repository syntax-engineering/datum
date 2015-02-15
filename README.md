# Datum: A flexible data-driven test solution for Rails

## Synopsis
Datum is a data-driven test solution for Rails. It enables an easy-to-use mechanism for generating test cases based on data attributes as well as a streamlined test database seeding method.

## Feature List

**1. Data structures as a source for test generation**: Datum adds a data-driven extension to the default Rails testing infrastructure. It includes the new data_test method which couples data structure definitions with test generation.

**2. On-demand (per test, per test class, etc) test db seeding**: Datum Scenarios are a load-on-demand test database seeding mechanism. Each Scenario serves as a self-contained seeding mechanism for any and all supported tables in a test db.

**3. Test helpers and library functions loaded as needed**: To reduce the clutter of utility code, data-driven test generation and Scenario loading is further extended to enable per test and per test class libraries.

## Installing
Update your Gemfile with:

```ruby
gem 'datum'
```

Next run the bundle command:

```console
bundle install
```

## Usage

```ruby
 ## coming soon
```





## License

MIT License. Copyright 2012-2015 Tyemill. http://tyemill.com

You are not granted rights or licenses to the trademarks of Tyemill, including without limitation the Datum name or logo.

Datum struct uses ImprovedStruct and ImmutableStruct which are derivitive works based on ImmutableStruct by Theo Hultberg. This great class can be found here: [Immutable Struct](https://github.com/iconara/immutable_struct)