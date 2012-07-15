require 'spec_helper'

describe User do
  it "should change exp correctly when the user choose the correct answer, question's exp and user's exp are equal" do
    user = FactoryGirl.create(:user, :exp => 1400)
    question = FactoryGirl.create(:question, :exp => 1400)
    change = user.win_to(question)
    change.should eql(16)
    user.exp.should eql(1416)
    question.exp.should eql(1384)
  end

  it "should change exp correctly when the user choose the correct answer, question's exp is greater" do
    user = FactoryGirl.create(:user, :exp => 1400)
    question = FactoryGirl.create(:question, :exp => 1500)
    change = user.win_to(question)
    change.should eql(20)
    user.exp.should eql(1420)
    question.exp.should eql(1480)
  end

  it "should change exp correctly when the user choose the correct answer, question's exp is smaller" do
    user = FactoryGirl.create(:user, :exp => 1500)
    question = FactoryGirl.create(:question, :exp => 1400)
    change = user.win_to(question)
    change.should eql(11)
    user.exp.should eql(1511)
    question.exp.should eql(1389)
  end

  it "should change exp correctly when the user choose the incorrect answer, question's exp is smaller" do
    user = FactoryGirl.create(:user, :exp => 1500)
    question = FactoryGirl.create(:question, :exp => 1400)
    change = user.lose_to(question)
    change.should eql(20)
    user.exp.should eql(1480)
    question.exp.should eql(1420)
  end

  it "should change exp correctly when the user choose the correct answer, question's exp is greater" do
    user = FactoryGirl.create(:user, :exp => 1400)
    question = FactoryGirl.create(:question, :exp => 1500)
    change = user.lose_to(question)
    change.should eql(11)
    user.exp.should eql(1389)
    question.exp.should eql(1511)
  end
end
