# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_notification do
    user { FactoryGirl.create(:user) }
    proj_approval false
  end
end
