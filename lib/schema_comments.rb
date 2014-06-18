require 'active_record'
require 'active_support/inflector'

require 'schema_comments/version'

module SchemaComments::ActiveRecord; end

require 'schema_comments/active_record/connection_adapters/comment_definition'
require 'schema_comments/active_record/connection_adapters/abstract_adapter'
require 'schema_comments/active_record/connection_adapters/postgresql_adapter'
require 'schema_comments/active_record/connection_adapters/abstract_sqlite_adapter'
require 'schema_comments/active_record/connection_adapters/sqlite_adapter'
require 'schema_comments/active_record/connection_adapters/sqlite3_adapter'
require 'schema_comments/active_record/connection_adapters/mysql_adapter'
require 'schema_comments/active_record/connection_adapters/mysql2_adapter'

module SchemaComments
  def self.setup
    _cls = ->(l) { l.join('::').constantize }

    ar_names = %w(ActiveRecord ConnectionAdapters)
    ar_prefix = [''] + ar_names
    arc_prefix = [self.name] + ar_names
    base_names = %w(AbstractAdapter).each do |name|
      to_inject = [name]
      ar_class = _cls.(ar_prefix + to_inject)
      arc_class = _cls.(arc_prefix + to_inject)
      ar_class.send :include, arc_class unless ar_class.ancestors.include? arc_class
    end

    adapters = %w(PostgreSQL Mysql Mysql2)
    adapters << (::ActiveRecord::VERSION::MAJOR <= 3 ? 'SQLite' : 'SQLite3')
    adapters.each do |adapter|
      begin require "active_record/connection_adapters/#{adapter.downcase}_adapter"
      rescue LoadError => err; next; end

      to_inject = ["#{adapter}Adapter"]
      ar_class = _cls.(ar_prefix + to_inject)
      arc_class = _cls.(arc_prefix + to_inject)
      ar_class.module_eval do
        ar_class.send :include, arc_class unless ar_class.ancestors.include?(arc_class)
      end
    end
  end
end

SchemaComments.setup
