
#
#
#

class StatsController < ApplicationController
  def correct_percent(histories, category_type_id)
    correct_sum = 0 

    if (category_type_id == '0')
      size = histories.length
    else
      size = 0
    end

    histories.each do |h|
      if (h.question.question_type.category_type_id == category_type_id.to_i) or (category_type_id == '0')
        correct_sum += 1 if h.choice.correct
        size += 1 if category_type_id != '0'
      end
    end
    return 0 if size == 0
    return correct_sum.to_f/size.to_f
  end

  def intervalize(histories)
    interval = 600
    data = {}
    histories.each do |h|
      key = h.created_at.to_i/interval
      if data[key]
        data[key].push h
      else
        data[key] = [h]
      end
    end

    return data 
  end

  def percent_interval(histories, category_type_id)
    data = intervalize(histories)
    correct_interval = data.values.map do |i|
      correct_percent(i, category_type_id)
    end

    return correct_interval
  end

  def index
    histories = current_user.histories
    @math_total_answers, @math_correct_answers, @math_percent = total_answers(histories, 1)
    @cr_total_answers, @cr_correct_answers, @cr_percent = total_answers(histories, 2)
    @writing_total_answers, @writing_correct_answers, @writing_percent = total_answers(histories, 3)
  end

  def pull
    category_type_id = params[:category_type_id]
    histories = current_user.histories

    correct_interval = percent_interval(histories, category_type_id)
    data = {
      correct_interval: correct_interval
    }
    render :json => data, :status => "200"
  end

  def total_answers(histories, category_type_id)
    total_answers = 0
    correct_answers = 0
    histories.each do |h|
      if h.question.question_type.category_type_id == category_type_id or category_type_id == 0
        total_answers += 1
        correct_answers += 1 if h.choice.correct
      end
    end
    
    return total_answers, correct_answers, (correct_answers.to_f/total_answers.to_f)*100

  end

  def pull_stacked
    correct_data = []
    incorrect_data = []

    histories = current_user.histories
    category_type_id = params[:category_type_id]
    data_interval = intervalize(histories)
    data_interval.values.each do |d|
      total_value, correct_value = total_answers(d, 0)
      incorrect_value = total_value - correct_value
      correct_data << correct_value
      incorrect_data << incorrect_value
    end

    data = {
      correct_data: correct_data,
      incorrect_data: incorrect_data
    }

    render :json => data, status => '200'
  
  end

end
