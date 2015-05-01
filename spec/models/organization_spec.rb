require 'spec_helper'

describe Organization do
  
  describe '#sname_hash_to_org_list' do
    def create_org_with_sname(sname)
      FactoryGirl.create(:organization, :sname => sname)
    end

    before(:each) do
      Organization.delete_all
      
      @cs169 = create_org_with_sname('CS169')
      @bp = create_org_with_sname('BP')
      @cs160 = create_org_with_sname('CS160')
      @bc = create_org_with_sname('BC')
    end
  
    it 'returns all the organizations whose sname has a value of 1 in the hash' do
      got = Organization.sname_hash_to_org_list({ 'CS169' => '1', 'BP' => '1', 'CS160' => 0 })
      expect(got).to match_array([@cs169, @bp])
    end
    
    it 'returns an empty collection if no sname has a value of 1 in the hash' do
      got = Organization.sname_hash_to_org_list({ 'CS169' => '0', 'BP' => '0', 'BC' => '0' })
      expect(got).to be_empty
    end
  end
  
end
