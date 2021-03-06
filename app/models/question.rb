class Question < ActiveRecord::Base
  validates :title,:prompt, :question_type_id, presence: true
  validates :prompt,uniqueness: true
  validate :contains_correct_choice
  validate :sentence_completion_contains_blank
  validate :sentence_completion_number_blanks

  belongs_to :paragraph
  belongs_to :question_type
  has_many :questions_buffers
  has_many :rooms, :through => :questions_buffers
  has_many :histories

  has_many :choices, dependent: :destroy
  accepts_nested_attributes_for :choices, :reject_if => lambda { |c| c[:content].blank?}, :allow_destroy => true

  has_attached_file :image,
    storage: :s3,
    s3_credentials: "#{Rails.root}/config/keys/aws3_sec_credentials",
    path: "images/"

  def contains_correct_choice
    choices = self.choices
    is_choice_blank=false
    choices.each do |choice|
      if choice.blank?
        is_choice_blank=true
      end
    end
    if is_choice_blank
      errors.add(:choice, "Question must have at least one choice")
    else
      has_correct= false
      choices.each do |choice|
        has_correct = true if choice.correct
      end
      if !has_correct
        errors.add(:choice, "Question must have at least one correct choice")
      end
    end
  end

  def sentence_completion_contains_blank
    return true if self.question_type.type_name!="Sentence Completion"
    has_blank = self.prompt=~/<bl \/>/
    if !has_blank
      errors.add(:blank, "Sentence completion must have at least one blank")
    end
  end

  def sentence_completion_number_blanks
    return true if self.question_type.type_name!="Sentence Completion"
    num_blanks = self.prompt.scan("<bl />").count
    result = true
    self.choices.each do |choice|
      result = false if choice.content.scan("..").count+1 != num_blanks
    end
    if !result
      errors.add(:blank, "Sentence completion must have valid number of blanks")
    end
  end

  def correct_choices
    self.choices.where(correct: true)
  end

  def correct_choice_ids
    self.choices.where(correct: true).collect {|c| c.id}
  end
end
