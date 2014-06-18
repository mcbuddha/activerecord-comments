module SchemaComments::ActiveRecord::ConnectionAdapters
  module Mysql2Adapter
    def self.included(base)
      base.class_eval do
        include SchemaComments::ActiveRecord::ConnectionAdapters::MysqlAdapter
      end
    end
  end
end
