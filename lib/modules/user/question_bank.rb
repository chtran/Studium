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
      mastered_questions = self.mastered_questions
      questions_id = self.histories
                         .where(question_id: answered_questions.collect(&:id) - mastered_questions.collect(&:id))
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
