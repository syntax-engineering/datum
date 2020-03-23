require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

module Datum
  module Transactions

    def self.included(klass)
      klass.class_eval do
        class_attribute :datum_transactions
        self.datum_transactions = true
      end
      klass.use_transactional_fixtures = false
    end

    def load_scenarios
    end

    def around_all
      return super unless self.class.datum_transactions

      DatabaseCleaner.cleaning do
        record_ivars do
          load_scenarios
        end
        super
      end
    end

    def around
      return super unless self.class.datum_transactions

      restore_ivars
      DatabaseCleaner.cleaning do
        super
      end
    end

    def record_ivars
      pre = instance_variables
      yield
      post = instance_variables
      serialize_ivars(post - pre)
    end

    def serialize_ivars(ivars_to_serialize)
      ivar_hsh = {}
      ivars_to_serialize.each do |ivar_name|
        value = instance_variable_get(ivar_name)
        ivar_hsh[ivar_name] = value
      end
      @_serialized_ivars = Marshal.dump(ivar_hsh)
    end

    def restore_ivars
      ivar_hsh = Marshal.load(@_serialized_ivars)
      ivar_hsh.each do |ivar_name, value|
        instance_variable_set(ivar_name, value)
      end
    end
  end
end