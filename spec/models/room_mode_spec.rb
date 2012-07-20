require 'spec_helper'

describe RoomMode do
  it "should generate CR questions" do
    u = FactoryGirl.create(:user, :exp => 1400)
    cr_mode_id = RoomMode.where(title: "CR").first.id
    cr_category_id = CategoryType.where(category_name: "CR").first.id
    room = Room.create(title: "Test room", room_mode_id: cr_mode_id)
    u.room = room
    room.room_mode.generate_questions(room)
    not_cr = room.questions.select {|q| q.question_type.category_type.id!=cr_category_id}.length
    not_cr.should eql(0)
  end
end
