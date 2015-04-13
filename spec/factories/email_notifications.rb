# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :email_notification do
    user nil
    fav_projects false
    proj_approval false
  end
end
