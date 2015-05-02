# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    fname "John"
    lname  "Doe"
    admin false
    password "password"
    confirmed_at { Time.now }
    email { "user#{rand(1000)}#{rand(1000)}@user.com" }
    
    factory :admin do
      admin true
      email { "admin#{rand(1000)}#{rand(1000)}@admin.com" }
    end
    
    factory :developer do
      after_build { |f|
        dev = Developer.create
        f.rolable = dev
        f.rolable_type = dev.class.name
      }
    end
  end
end


