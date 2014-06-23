require 'spec_helper'

TEST_COMMENTS =
  [
   %q{some "comment" with 'quotes'},
   %q{other ; special \\ characters \' \"},
  ]

describe ActiveRecord::Comments do
  subject { ActiveRecord::Base.connection }
  let(:table) { :test }
  describe '#setup' do
    context 'should define' do
      it('set_table_comment') { expect(subject).to respond_to(:set_table_comment) }
      it('retrieve_table_comment') { expect(subject).to respond_to(:retrieve_table_comment) }
      it('remove_table_comment') { expect(subject).to respond_to(:remove_table_comment) }

      it('set_column_comment') { expect(subject).to respond_to(:set_column_comment) }
      it('retrieve_column_comment') { expect(subject).to respond_to(:retrieve_column_comment) }
      it('retrieve_column_comments') { expect(subject).to respond_to(:retrieve_column_comments) }
      it('remove_column_comment') { expect(subject).to respond_to(:remove_column_comment) }
    end
  end

  describe 'table comments' do
    let(:comment) { 'test comment' }
    let(:comment2) { 'other test comment' }

    before { subject.set_table_comment table, comment }

    it 'should read same comment' do
      expect(subject.retrieve_table_comment table).to eq(comment)
    end

    it 'should read last version' do
      expect(subject.retrieve_table_comment table).to eq(comment)
      subject.set_table_comment table, comment2
      expect(subject.retrieve_table_comment table).to eq(comment2)
    end

    it 'should read nil after remove' do
      subject.remove_table_comment table
      expect(subject.retrieve_table_comment table).to be_nil
    end
  end

  describe 'test_comments' do
    TEST_COMMENTS.each do |comment|
      it do
        subject.set_table_comment table, comment
        expect(subject.retrieve_table_comment table).to eq(comment)
      end
    end
  end

  describe 'column comments' do
    let(:comment) { 'some comment' }
    let(:comment2) { 'some other comment' }
    let(:comment3) { 'another comment' }

    let(:col) { :field1 }
    let(:col2) { :field2 }

    context 'should read' do
      it do
        subject.set_column_comment table, col, comment
        expect(subject.retrieve_column_comment table, col).to eq(comment)
      end

      it do
        subject.set_column_comment table, col2, comment2
        expect(subject.retrieve_column_comment table, col2).to eq(comment2)
      end

      it do
        subject.set_column_comment table, col, comment
        subject.set_column_comment table, col2, comment2
        expect(subject.retrieve_column_comments table, col, col2).to eq(col => comment, col2 => comment2)
      end

      it do
        subject.set_column_comment table, col, comment
        expect(subject.retrieve_column_comment table, col).to eq(comment)
        subject.remove_column_comment table, col
        expect(subject.retrieve_column_comment table, col).to be_nil
      end
    end

    describe 'test_comments' do
      TEST_COMMENTS.each do |comment|
        it do
          subject.set_column_comment table, col, comment
          expect(subject.retrieve_column_comment table, col).to eq(comment)
        end
      end
    end
  end
end
