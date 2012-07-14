
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

  def percent_interval(histories, interval, category_type_id)
    data = {}
    histories.each do |h|
      key = h.created_at.to_i/interval
      if data[key]
        data[key].push h
      else
        data[key] = [h]
      end
    end

    correct_interval = data.values.map do |i|
      correct_percent(i, category_type_id)
    end

    return correct_interval
  end

  def index
  end

  def pull
    category_type_id = params[:category_type_id]
    interval = 600
    histories = current_user.histories

    correct_interval = percent_interval(histories, interval, category_type_id)
    data = {
      correct_interval: correct_interval
    }
    render :json => data, :status => "200"
  end



end
