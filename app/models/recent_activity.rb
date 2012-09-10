class RecentActivity < ActiveRecord::Base
  attr_accessible :verb
  belongs_to :subject, polymorphic: true
  belongs_to :object, polymorphic: true
  @verbs = ["add_friend", "level_up", "join_room", "earn_badge", "update_status", "post_wall"]

  def self.generate(type, options={})
    atts = {verb: type}.merge(options)
    RecentActivity.new(atts) if @verbs.include?(type)
  end

  def render
    case self.verb
    when "add_friend"
      "#{self.subject.name} added #{self.object.name} as friend"
    when "level_up"
      "#{self.subject.name} has advanced to level #{self.subject.level}"
    when "join_room"
      "#{self.subject.name} joined room \"#{self.object.title}\""
    when "earn_badge"
      "#{self.subject.name} has earned badge \"#{self.object.name}\""
    when "update_status"
      "#{self.subject.name} has an updated status"
    when "post_wall"
      "#{self.subject.name} posted on #{self.object.name}'s wall"
    end
  end
end
