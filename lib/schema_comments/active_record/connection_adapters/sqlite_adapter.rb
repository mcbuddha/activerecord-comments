module SchemaComments::ActiveRecord::ConnectionAdapters
  module SQLiteAdapter
    include SchemaComments::ActiveRecord::ConnectionAdapters::AbstractSQLiteAdapter

    def create_table(table_name, options = {})
      td = ::ActiveRecord::ConnectionAdapters::TableDefinition.new(self)
      td.primary_key(options[:primary_key] || ActiveRecord::Base.get_primary_key(table_name.to_s.singularize)) unless options[:id] == false
      td.comment options[:comment] if options.has_key?(:comment)
      td.base = self

      yield td if block_given?

      if options[:force] && table_exists?(table_name)
        drop_table(table_name)
      end

      create_sql = "CREATE#{' TEMPORARY' if options[:temporary]} TABLE "
      create_sql << "#{quote_table_name(table_name)}#{td.table_comment} ("
      create_sql << td.columns.map do |column|
        column.to_sql + column.comment.to_s
      end * ", "
      create_sql << ") #{options[:options]}"
      execute create_sql
    end
  end
end
