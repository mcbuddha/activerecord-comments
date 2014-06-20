require 'spec_helper'

describe ActiveRecord::Comments do
  describe '#setup' do
    subject { described_class.setup }
    it 'should include table methods' do
      ActiveRecord::Schema.define do
        set_table_comment :test, 'comment'
        retrieve_table_comment :test
        remove_table_comment :test
      end
    end

    it 'should include column methods' do
      ActiveRecord::Schema.define do
        set_column_comment :test, :field1, 'comment'
        retrieve_column_comment :test, :field1
        retrieve_column_comments :test, :field1, :field2
        remove_column_comment :test, :field1
      end
    end
  end
end
