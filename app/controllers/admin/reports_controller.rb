class Admin::ReportsController < ApplicationController
  def users
    users = User.all

    users_who_answered = users.find_all do |u|
      u.histories != []
    end

    users_who_come_back = users.find_all do |u|
      u.created_at.to_date == u.last_sign_in_at.to_date
    end

    questions_answered = users.map do |u| 
      u.histories.length
    end
    total_questions_answered = questions_answered.inject do |i,s|
      i+s
    end
    @questions_answered = {
      :total => total_questions_answered,
      :max => questions_answered.max,
      :avg => total_questions_answered.to_f/questions_answered.length
    }
    @registered = {
      :number => users.length,
      :percentage => 100
    }
    @answered = {
      :number => users_who_answered.length,
      :percentage => 100*users_who_answered.length/users.length
    }

    @come_back = {
      :number => users_who_come_back.length,
      :percentage => 100*users_who_come_back.length/users.length
    }
  end

  def questions
  end


end
