module SchemaComments::ActiveRecord::ConnectionAdapters
  module PostgreSQLAdapter
    def comments_supported?
      true
    end

    def independent_comments?
      true
    end

    def set_table_comment(table_name, comment_text)
      execute CommentDefinition.new(self, table_name, nil, comment_text).to_sql
    end

    def set_column_comment(table_name, column_name, comment_text)
      execute CommentDefinition.new(self, table_name, column_name, comment_text).to_sql
    end

    def retrieve_table_comment(table_name)
      result = select_rows(table_comment_sql(table_name))
      result[0].nil? ? nil : result[0][0]
    end

    def retrieve_column_comments(table_name, *column_names)
      result = select_rows(column_comment_sql(table_name, *column_names))
      return {} if result.nil?
      return result.inject({}){|m, row| m[row[0].to_sym] = row[1]; m}
    end

    def comment_sql(comment_definition)
      "COMMENT ON #{comment_target(comment_definition)} IS #{escaped_comment(comment_definition.comment_text)}"
    end

    private

    def comment_target(comment_definition)
      comment_definition.table_comment? ?
          "TABLE #{quote_table_name(comment_definition.table_name)}" :
          "COLUMN #{quote_table_name(comment_definition.table_name)}.#{quote_column_name(comment_definition.column_name)}"
    end

    def escaped_comment(comment)
      comment.nil? ? 'NULL' : "'#{comment.gsub("'", "''")}'"
    end

    def table_comment_sql(table_name)
      <<SQL
SELECT d.description FROM (
#{table_oids(table_name)}) tt
JOIN pg_catalog.pg_description d
  ON tt.oid = d.objoid AND tt.tableoid = d.classoid AND d.objsubid = 0;
SQL
    end

    def column_comment_sql(table_name, *column_names)
      col_matcher_sql = column_names.empty? ? "" : " a.attname IN (#{column_names.map{|c_name| "'#{c_name}'"}.join(',')}) AND "
      <<SQL
SELECT a.attname, pg_catalog.col_description(a.attrelid, a.attnum)
FROM pg_catalog.pg_attribute a
JOIN (
#{table_oids(table_name)}) tt
  ON tt.oid = a.attrelid
WHERE #{col_matcher_sql} a.attnum > 0 AND NOT a.attisdropped;
SQL
    end

    def table_oids(table_name)
      <<SQL
SELECT c.oid, c.tableoid
FROM pg_catalog.pg_class c
WHERE c.relname = '#{table_name}'
  AND c.relkind = 'r'
  AND pg_catalog.pg_table_is_visible(c.oid)
SQL
    end
  end
end
