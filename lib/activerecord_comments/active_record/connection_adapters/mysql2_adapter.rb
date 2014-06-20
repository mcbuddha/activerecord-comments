module ActiveRecord::Comments::ConnectionAdapters
  module Mysql2Adapter
    def self.included(base)
      base.class_eval do
        include ActiveRecord::Comments::ConnectionAdapters::MysqlAdapter
      end
    end
  end
end
