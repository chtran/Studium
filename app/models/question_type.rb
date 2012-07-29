class QuestionType < ActiveRecord::Base
  belongs_to :category_type
  has_many :questions

  def is_sentence_completion?
    self.type_name=="Sentence Completion"
  end

  def is_sentence_improvement?
    self.type_name=="Sentence Improvement"
  end

  def cr?
    self.category_type.category_name=="Critical Reading"
  end

  def wr?
    self.category_type.category_name=="Writing (Multiple Choice)"
  end

  def math?
    self.category_type.category_name=="Math"
  end
end
