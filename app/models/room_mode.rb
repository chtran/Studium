class RoomMode < ActiveRecord::Base
  attr_accessible :title, :namespace
  has_many :rooms

  # Input: a room
  # Output: A relation of all the questions generated
  def generate_questions(room)
    mastered_questions_id = room.mastered_questions.collect{ |q| q.id}
    unmastered_questions = mastered_questions_id.empty? ? Question.order(:id) : Question.where("id NOT IN (?)", mastered_questions_id)
    # If the room_mode's name is one the the categories' names
    if categories = CategoryType.where(category_name: self.title) and categories != []
      # Find all the question types associated with that category
      question_types = categories[0].question_types.select(:id)
      output = unmastered_questions.where(:question_type_id => question_types)
    elsif self.namespace == "replay"
      output = room.users[0].failed_questions
    elsif self.namespace == "smart"
      exp_array = room.users.select(:exp).order(:exp)
      min_exp = exp_array.first.exp
      max_exp = exp_array.last.exp
      output = unmastered_questions.where(exp: (min_exp-50)..(max_exp+50))
    elsif self.namespace == "shuffled"
      output = Question.order(:id)
    end
    return output
  end
end
