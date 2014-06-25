require 'active_record'
require 'active_support/inflector'

require 'active_record/comments/version'

module ActiveRecord::Comments; end

require 'active_record/comments/connection_adapters/comment_definition'
require 'active_record/comments/connection_adapters/abstract_adapter'
require 'active_record/comments/connection_adapters/postgresql_adapter'
require 'active_record/comments/connection_adapters/abstract_sqlite_adapter'
require 'active_record/comments/connection_adapters/sqlite_adapter'
require 'active_record/comments/connection_adapters/sqlite3_adapter'
require 'active_record/comments/connection_adapters/mysql_adapter'
require 'active_record/comments/connection_adapters/mysql2_adapter'

module ActiveRecord::Comments
  def self.setup
    _cls = ->(l) { l.join('::').constantize }

    ar_names = %w(ActiveRecord ConnectionAdapters AbstractAdapter)
    ar_class = _cls.(ar_names)
    arc_class = _cls.([self.name, *ar_names[1..-1]])
    ar_class.send :include, arc_class unless ar_class.ancestors.include? arc_class

    adapters = %w(PostgreSQL Mysql Mysql2)
    adapters << (::ActiveRecord::VERSION::MAJOR <= 3 ? 'SQLite' : 'SQLite3')
    adapters.each do |adapter|
      begin require "active_record/connection_adapters/#{adapter.downcase}_adapter"
      rescue LoadError => err; next; end

      to_inject = "#{adapter}Adapter"
      ar_class = _cls.([*ar_names[0..-2], to_inject])
      arc_class = _cls.([self.name, *ar_names[1..-2], to_inject])
      ar_class.module_eval do
        ar_class.send :include, arc_class unless ar_class.ancestors.include?(arc_class)
      end
    end
  end
end

ActiveRecord::Comments.setup
