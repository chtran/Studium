
#
#
#

class StatsController < ApplicationController
  def correct_percent(histories)
    correct_sum = 0 
    
    histories.each do |h|
      correct_sum += 1 if h.choice.correct 
    end

    return correct_sum.to_f/histories.length.to_f
  end

  def percent_interval(histories, interval)
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
      correct_percent(i)
    end

    return correct_interval
  end
    
  def index

  end

  def pull
    interval = 600
    histories = current_user.histories

    correct_interval = percent_interval(histories, interval)
    data = {
      correct_interval: correct_interval
    }
    render :json => data, :status => "200"
  end



end
