require 'spec_helper'

describe Project, :type => :model do
  
  def create_public_projects(n)
    (1..n).map {|x| FactoryGirl.create(:project, :organizations => [])}
  end
    
  def create_private_projects(n)
    (1..n).map { |x| FactoryGirl.create(:project) }
  end
  
  def create_forprofit_projects(n)
    (1..n).map { |x| FactoryGirl.create(:project, :client => FactoryGirl.create(:client, :nonprofit => false)) }
  end
  
  def create_non501c3_projects(n)
    (1..n).map { |x| FactoryGirl.create(:project, :client => FactoryGirl.create(:client, :five_01c3 => false)) }
  end
  
  def create_unfinished_projects(n)
    (1..n).map { |x| FactoryGirl.create(:project, :state => Project::UNFINISHED) }
  end
  
  def create_finished_projects(n)
    (1..n).map { |x| FactoryGirl.create(:project, :state => Project::FINISHED) }
  end
  
  def create_projects_with_word(n, word)
    (1..n).map { |x| FactoryGirl.create(:project, :title => "#{rand(2000)}#{word}#{rand(2000)}") }
  end

  def create_projects_with_client(n, client)
    (1..n).map { |x| FactoryGirl.create(:project, :client => FactoryGirl.create(:client, :company_name => "#{rand(2000)}#{client}#{rand(2000)}")) }
  end
  
  describe '#is_public' do
  
    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all projects are public' do
      expected = create_public_projects(3)
      got = Project.is_public
      expect(got).to match_array(expected)
    end
    
    it 'returns all public projects if some projects are public' do
      expected = create_public_projects(3)
      create_private_projects(3)
      got = Project.is_public
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no projects are public' do
      create_private_projects(3)
      got = Project.is_public
      expect(got).to be_empty
    end
    
    it 'returns an empty collection if there are no projects' do
      got = Project.is_public
      expect(got).to be_empty
    end
  end
  
  describe '#is_private' do

    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all projects are private' do
      expected = create_private_projects(3)
      got = Project.is_private
      expect(got).to match_array(expected)
    end
    
    it 'returns all private projects if some projects are private' do
      expected = create_private_projects(3)
      create_public_projects(3)
      got = Project.is_private
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no projects are private' do
      create_public_projects(3)
      got = Project.is_private
      expect(got).to be_empty
    end
    
    it 'returns an empty collection if there are no projects' do
      got = Project.is_private
      expect(got).to be_empty
    end
  end
  
  describe "#by_title('health')" do

    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all project titles contain "health"' do
      expected = create_projects_with_word(3, 'health')
      got = Project.by_title('health')
      expect(got).to match_array(expected)
    end

    it 'returns projects whose title contains "health" if some project titles contain "health"' do
      expected = create_projects_with_word(3, 'health')
      create_public_projects(3)
      got = Project.by_title('health')
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no project titles contain "health"' do
      create_public_projects(3)
      got = Project.by_title('health')
      expect(got).to be_empty
    end
  end

  describe "#by_organization('health')" do

    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all project client names contain "health"' do
      expected = create_projects_with_client(3, 'health')
      got = Project.by_organization('health')
      expect(got).to match_array(expected)
    end

    it 'returns projects whose client name contains "health" if some project client names contain "health"' do
      expected = create_projects_with_client(3, 'health')
      create_public_projects(3)
      got = Project.by_organization('health')
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no project client names contain "health"' do
      create_public_projects(3)
      got = Project.by_organization('health')
      expect(got).to be_empty
    end
  end
  
  describe "#by_title_organization('health')" do

    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all project client names contain "health"' do
      expected = create_projects_with_client(3, 'health')
      got = Project.by_title_organization('health')
      expect(got).to match_array(expected)
    end

    it 'returns projects whose client name contains "health" if some project client names contain "health"' do
      expected = create_projects_with_client(3, 'health')
      create_public_projects(3)
      got = Project.by_title_organization('health')
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no project client names contain "health"' do
      create_public_projects(3)
      got = Project.by_title_organization('health')
      expect(got).to be_empty
    end
  end

  describe "#is_nonprofit(true)" do

    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all project clients are nonprofit' do
      expected = create_public_projects(3) # nonprofit
      got = Project.is_nonprofit(true)
      expect(got).to match_array(expected)
    end

    it 'returns projects whose client is nonprofit if some project clients are nonprofit' do
      expected = create_public_projects(3) # nonprofit
      create_forprofit_projects(3)
      got = Project.is_nonprofit(true)
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no project clients are nonprofit' do
      create_forprofit_projects(3)
      got = Project.is_nonprofit(true)
      expect(got).to be_empty
    end
  end

  describe "#is_forprofit(true)" do

    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all project clients are for-profit' do
      expected = create_forprofit_projects(3)
      got = Project.is_forprofit(true)
      expect(got).to match_array(expected)
    end

    it 'returns projects whose client is nonprofit if some project clients are for-profit' do
      expected = create_forprofit_projects(3)
      create_public_projects(3) # nonprofit
      got = Project.is_forprofit(true)
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no project clients are for-profit' do
      create_public_projects(3) # nonprofit
      got = Project.is_forprofit(true)
      expect(got).to be_empty
    end
  end

  describe "#is_five_01c3(true)" do

    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all project clients are 501c3' do
      expected = create_public_projects(3) # 501c3
      got = Project.is_five_01c3(true)
      expect(got).to match_array(expected)
    end

    it 'returns projects whose client is nonprofit if some project clients are 501c3' do
      expected = create_public_projects(3) # 501c3
      create_non501c3_projects(3)
      got = Project.is_five_01c3(true)
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no project clients are 501c3' do
      create_non501c3_projects(3)
      got = Project.is_five_01c3(true)
      expect(got).to be_empty
    end
  end

  describe "#is_finished(true)" do

    before(:each) do
      Project.delete_all
    end
  
    it 'returns all projects if all projects are finished' do
      expected = create_finished_projects(3)
      got = Project.is_finished(true)
      expect(got).to match_array(expected)
    end

    it 'returns projects whose client is nonprofit if some projects are finished' do
      expected = create_finished_projects(3)
      create_unfinished_projects(3)
      got = Project.is_finished(true)
      expect(got).to match_array(expected)
    end
    
    it 'returns an empty collection if no projects are finished' do
      create_unfinished_projects(3)
      got = Project.is_finished(true)
      expect(got).to be_empty
    end
  end
  
  describe '#owner' do
    it 'returns the client for this project' do
      proj = FactoryGirl.create(:project)
      expect(proj.owner).to eq(proj.client)
    end
  end
  
  describe '#method_missing' do
    it 'returns the correct value for a method call of the form "question_num"' do
      questions = {'question_1' => true, 'question_2' => false, 'question_3' => true}
      proj = FactoryGirl.create(:project, :questions => questions)
      expect(proj.question_1).to eq(questions['question_1'])
      expect(proj.question_2).to eq(questions['question_2'])
      expect(proj.question_3).to eq(questions['question_3'])
    end
    
    it 'raises an error for a nonexistent method' do
      proj = FactoryGirl.create(:project)
      expect{proj.blahh}.to raise_error(NameError)
    end
  end
  
  describe '#question_key' do
    it 'returns "question_id", where "id" is replaced by the question\'s id' do
      q = FactoryGirl.create(:question)
      expect(Project.question_key(q)).to eq("question_#{q.id}")
    end
  end
  
  describe '#get_question_id' do
    it 'extracts the id from the string "question_id"' do
      q = ['question_5', 'answer']
      expect(Project.get_question_id(q)).to eq("5")
    end
  end
  
  describe '#merge_questions' do
    it 'updates the saved answer to a new answer' do
      q1 = FactoryGirl.create(:question)
      q2 = FactoryGirl.create(:question)
      q3 = FactoryGirl.create(:question)
      questions = {'question_1' => true, 'question_2' => false, 'question_3' => true}
      proj = FactoryGirl.create(:project, :questions => questions)
      
      proj.questions = {'question_1' => false, 'question_2' => true}
      proj.merge_questions
      expect(proj.questions).to eq({'question_1' => false, 'question_2' => true})
    end
  end
  
end
