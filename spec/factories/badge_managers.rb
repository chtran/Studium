# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :badge_manager do
    user_id 1
    correct_qiar_counter 1
    question_counter 1
    perfect_replay_counter 1
    math_q_counter 1
    math_qiar_counter 1
    wr_q_counter 1
    wr_qiar_counter 1
    cr_q_counter 1
    cr_qiar_counter 1
  end
end
