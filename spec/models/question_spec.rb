require 'spec_helper'

describe Question do
  
  describe '#current_questions' do
    before(:each) do
      Question.delete_all
    end
    
    def create_deleted_questions
      d1 = FactoryGirl.create(:question, :deleted => 'yes')
      d2 = FactoryGirl.create(:question, :deleted => true)
      d3 = FactoryGirl.create(:question, :deleted => 't')
    end
    
    def create_non_deleted_questions
      q1 = FactoryGirl.create(:question, :deleted => nil)
      q2 = FactoryGirl.create(:question, :deleted => false)
      q3 = FactoryGirl.create(:question, :deleted => 'f')
      return [q1, q2, q3]
    end
  
    it 'returns all the questions that haven\'t been deleted' do
      expected = create_non_deleted_questions
      expect(Question.current_questions).to match_array(expected)
    end
    
    it 'returns an empty collection if all questions are deleted' do
      create_deleted_questions
      expect(Question.current_questions).to be_empty
    end
  end
  
end
