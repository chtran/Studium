class Badge < ActiveRecord::Base
  attr_accessible :name, :user_id,:description,:legendary

  has_and_belongs_to_many :users
end
