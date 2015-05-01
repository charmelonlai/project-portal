require 'spec_helper'

describe User, :type => :model do
  
  describe '#all_names_and_emails' do
    before(:each) do
      User.delete_all
    end
  
    it 'returns the names + emails of all users' do
      u1 = FactoryGirl.create(:user, :fname => "George", :lname => "Lucas")
      u2 = FactoryGirl.create(:user, :fname => "John", :lname => "Doe")
      u3 = FactoryGirl.create(:user, :fname => "Lois", :lname => "Griffin")
      expected = ["#{u1.fname} #{u1.lname} (#{u1.email})", "#{u2.fname} #{u2.lname} (#{u2.email})", "#{u3.fname} #{u3.lname} (#{u3.email})"]
      expect(User.all_names_and_emails).to match_array(expected)
    end
    
    it 'returns an empty list if there are no users' do
      expect(User.all_names_and_emails).to be_empty
    end
  end
end
