class HistoriesController < ApplicationController
  before_filter :find_history

  def show_history
    correct=@history.choice and @history.choice.correct
    @class = correct ? "correct" : "incorrect"
    @result =
      if !@history[:choice_id]
        "didn't choose an answer"
      elsif @history.choice.correct
        "chose the correct answer"
      else
        "chose the wrong answer"
      end
    render partial: "history"
  end

private

  def find_history
    @history=History.find params[:history_id]
  end
end
