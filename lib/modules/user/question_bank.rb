class User
  module QuestionBank
    def mastered_questions
      questions_id = self.histories
                         .joins(:choice)
                         .where(choices: {correct: true})
                         .select("histories.question_id")
                         .uniq
                         .collect(&:question_id)
      return Question.where(id: questions_id)
    end

    def failed_questions
      questions_id = self.histories
                         .where(question_id: self.answered_questions.collect(&:id))
                         .where("question_id NOT IN (?)", self.mastered_questions.empty? ? "" : self.mastered_questions.collect(&:id)) 
                         .select("histories.question_id")
                         .uniq
                         .collect(&:question_id)
      return Question.where(id: questions_id)
    end

    def answered_questions
      questions_id = self.histories
                         .select(:question_id)
                         .uniq
                         .collect(&:question_id)
      return Question.where(id: questions_id)
    end
  end
end
