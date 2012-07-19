class RoomMode < ActiveRecord::Base
  attr_accessible :title
  has_many :rooms

  # Input: a room
  # Output: A relation of all the questions generated
  def generate_questions(room)
    mastered_questions_id = room.mastered_questions.collect{ |q| q.id}
    unmastered_questions = mastered_questions_id.empty? ? Question.select("questions.*") : Question.where("id NOT IN (?)", mastered_questions_id)
    # If the room_mode's name is one the the categories' names
    if categories = CategoryType.where(category_name: self.title) and categories != []
      # Find all the question types associated with that category
      question_types = categories[0].question_types.select(:id)
      output = unmastered_questions.where(:question_type_id => question_types)
    elsif self.title == "Replay"
      output = room.users[0].failed_questions
    elsif self.title == "Smart"
      exp_array = room.users.select(:exp).order(:exp)
      min_exp = exp_array.first
      max_exp = exp_array.last
      output = unmastered_questions.where(exp: (min_exp-50)..(max_exp+50))
    elsif self.title == "Shuffled"
      output = unmastered_questions
    end
    return output
  end
end
