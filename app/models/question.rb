class Question < ActiveRecord::Base
  validates :title,:prompt, :question_type_id, presence: true
  validates :prompt,uniqueness: true
  validate :contains_correct_choice

  belongs_to :paragraph
  belongs_to :question_type
  has_many :questions_buffers
  has_many :rooms, :through => :questions_buffers
  has_many :histories

  has_many :choices
  accepts_nested_attributes_for :choices, :reject_if => lambda { |c| c[:content].blank?}, :allow_destroy => true

  has_attached_file :image,
    storage: :s3,
    s3_credentials: {
      bucket: ENV["S3_BUCKET_NAME"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
  }

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

  def correct_choices
    self.choices.where(correct: true)
  end

  def correct_choice_ids
    self.choices.where(correct: true).collect {|c| c.id}
  end
end
