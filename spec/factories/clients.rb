# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :client do
    company_name 'My Nonprofit'
    company_site 'http://www.nonprofit.com'
    company_address '102 Nonprofit Hall'
    nonprofit true
    five_01c3 true
    mission_statement 'Nonprofit.'
    contact_email 'client@admin.com'
    contact_number 'N/A'
    user { FactoryGirl.create(:user) }
  end
end
