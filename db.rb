# frozen_string_literal: true

require 'sequel'

DB = Sequel.postgres(database: 'sequel_test',
                     host: 'localhost',
                     user: 'postgres')
