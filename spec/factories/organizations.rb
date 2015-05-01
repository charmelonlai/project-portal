# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    sname "CS169"
    name "UC Berkeley CS169 Software Engineering"
    description "description"
    website "http://cs169.edu/"
    user { FactoryGirl.create(:user, :email => "organization#{rand(1000)}#{rand(1000)}@organization.com") }
    
    after_build { |f|
      f.user.rolable = f
      f.user.rolable_type = f.class.name
    }
  end
end
