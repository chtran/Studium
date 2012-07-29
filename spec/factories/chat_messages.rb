# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :chat_message do
    content "MyText"
    owner_id 1
  end
end
