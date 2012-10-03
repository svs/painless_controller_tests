require 'factory_girl'

FactoryGirl.define do
  sequence(:email)          { |n| "my_email@example#{n}.com" }
  sequence(:staff_email)    { |n| "my_staff_email@example#{n}.com" }
  sequence(:org_name)       { |n| ["Bhimji Notandas","Westside","Lifestyle","Shoppers Stop","Spencers","What Katy Did"][n%5] + " #{n}"}
  sequence(:receipt_title)  { |n| ["","shopping", "nothing","jlt"][n%3] + " #{n}" }
  sequence(:biz_card_name)  { |n| "name_#{n}" }

  factory :user do 
    password    'secret'
    password_confirmation 'secret'
    role        "customer"
    email

    factory :admin do
      role "admin"
    end

    factory :tagger do
      role "tagger"
    end
  end


  factory :item do
    name { FactoryGirl.generate(:biz_card_name) }
    association :user
  end

end
