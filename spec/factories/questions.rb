# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    title "With choices"
    prompt "I'm testing"
    question_type_id 1
    after(:build) do |q|
      q.choices << (FactoryGirl.build_list :choice, 4, :question =>q, :correct => false)
      q.choices << (FactoryGirl.build :choice, :question => q, :correct => true)
    end
    after(:create) do |q|
      q.choices.each do |c|
        c.save
      end
    end
  end
end
