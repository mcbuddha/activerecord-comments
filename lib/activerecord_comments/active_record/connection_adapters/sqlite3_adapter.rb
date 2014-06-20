module ActiveRecord::Comments::ConnectionAdapters
  module SQLite3Adapter
    include ActiveRecord::Comments::ConnectionAdapters::AbstractSQLiteAdapter

    def create_table(table_name, options = {})
      td = create_table_definition table_name, options[:temporary], options[:options]
      td.base = self

      unless options[:id] == false
        pk = options.fetch(:primary_key) {
          ActiveRecord::Base.get_primary_key table_name.to_s.singularize
        }

        td.primary_key pk, options.fetch(:id, :primary_key), options
      end
      td.comment options[:comment] if options.has_key?(:comment)

      yield td if block_given?

      if options[:force] && table_exists?(table_name)
        drop_table(table_name, options)
      end

      execute schema_creation.accept td
      td.indexes.each_pair { |c,o| add_index table_name, c, o }
    end
  end
end
