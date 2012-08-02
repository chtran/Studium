class Profile < ActiveRecord::Base
  belongs_to :user

  validates :first_name,:last_name,presence: true

  before_save :set_default_image

private
  def set_default_image
    if self.image==nil
      self.image="https://s3.amazonaws.com/studium_question_images/images/nopic.png"
    end
  end
end
