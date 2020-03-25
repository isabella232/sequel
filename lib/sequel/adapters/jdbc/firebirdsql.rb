# frozen-string-literal: true

#SEQUEL5: Remove

Sequel::JDBC.load_driver('org.firebirdsql.jdbc.FBDriver')
Sequel.require 'adapters/shared/firebird'
Sequel.require 'adapters/jdbc/transactions'

module Sequel
  module JDBC
    Sequel.synchronize do
      unless DATABASE_SETUP[:firebirdsql]
        DATABASE_SETUP[:firebirdsql] = proc do |db|
          db.extend(Sequel::JDBC::Firebird::DatabaseMethods)
          db.extend_datasets Sequel::Firebird::DatasetMethods
          org.firebirdsql.jdbc.FBDriver
        end
      end
    end

    # Database and Dataset instance methods for Firebird specific
    # support via JDBC.
    module Firebird
      # Database instance methods for Firebird databases accessed via JDBC.
      module DatabaseMethods
        include Sequel::Firebird::DatabaseMethods
        include Sequel::JDBC::Transactions
        
        # Add the primary_keys and primary_key_sequences instance variables,
        # so we can get the correct return values for inserted rows.
        def self.extended(db)
          db.instance_eval do
            @primary_keys = {}
          end
        end
      end
    end
  end
end
