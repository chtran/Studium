# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :friend, :class => 'Friends' do
    user_id ""
    friend_id ""
  end
end
