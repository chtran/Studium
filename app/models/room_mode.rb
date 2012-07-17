class RoomMode < ActiveRecord::Base
  attr_accessible :title
  has_many :rooms

  def generate_questions(users)
    # If the room_mode's name is one the the categories' names
    if categories = CategoryType.where(category_name: self.title) and categories != []
      # Find all the question types associated with that category
      question_types = categories[0].question_types.map {|t| t.id}
      output = Question.where(:question_type_id => question_types)
    elsif self.title == "Replay"
      # Select all the distinct questions that user has answered
      questions = users[0].histories.select(:question_id).uniq
      # Select only those which he failed in the last attemp
      output = questions.select do |q|
        !History.where(user_id: users[0].id, question_id: q.question_id)
               .order(:created_at)
               .last
               .choice.correct
      end
    elsif self.title == "Smart"
      exp_array = users.map { |u| u.exp}
      min_exp = exp_array.min
      max_exp = exp_array.max
      output = Question.where(exp: (min_exp-50)..(max_exp+50))
    end
    return output
  end
end
