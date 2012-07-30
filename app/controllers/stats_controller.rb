
#
#
#

class StatsController < ApplicationController
  before_filter :authenticate_user!

  def correct_percent(histories, category_type_id)
    correct_sum = 0 

    if (category_type_id == 0)
      size = histories.length
    else
      size = 0
    end

    histories.each do |h|
      if (h.question.question_type.category_type_id == category_type_id) or (category_type_id == 0)
        correct_sum += 1 if h.choice.correct
        size += 1 if category_type_id != 0
      end
    end
    return 0 if size == 0
    return ((correct_sum.to_f/size.to_f)*100).to_i
  end

  def intervalize(histories)
    interval = 3600*24
    data = {}
    interval_data = []
    histories.each do |h|
      key = (h.created_at.to_i/interval)*interval
      if data[key]
        data[key].push h
      else
        data[key] = [h]
        interval_data << h.created_at.to_date
      end
    end

    return data, interval_data 
  end

  def percent_interval(histories, category_type_id)
    data, key_interval = intervalize(histories)
    correct_interval = data.values.map do |i|
      correct_percent(i, category_type_id)
    end

    return correct_interval, key_interval
  end

  def index
    histories = current_user.histories
    #when the page is loaded for the first time,
    #show stats of today
    interval = 1
    @subject_data = performance_recently(histories, interval)
  end

  def show
    @user=User.find params[:user_id]
    histories = @user.histories
    #when the page is loaded for the first time,
    #show stats of today
    interval = 1
    @subject_data = performance_recently(histories, interval)

    stats_content=render_to_string partial: "stats"
    render json: {
      stats_content: stats_content
    }
  end

  def pull
    category_type_id = params[:category_type_id].to_i
    histories = current_user.histories

    @correct_interval, @key_interval = percent_interval(histories, category_type_id)
    data = {
      key_interval: @key_interval, 
      correct_interval: @correct_interval
    }
    render :json => data, :status => "200"
  end

  def total_answers(histories, category_type_id)
    total_answers = 0
    correct_answers = 0
    histories.each do |h|
      if h.question.question_type and h.question.question_type.category_type_id == category_type_id or category_type_id == 0
        total_answers += 1
        correct_answers += 1 if h.choice.correct
      end
    end

    # Reset percent to 0 if user has not answered any question
    percent=total_answers==0 ? 0 : (correct_answers.to_f/total_answers.to_f)*100
    
    return total_answers, correct_answers, percent.to_i

  end

  def pull_stacked
    correct_data = []
    incorrect_data = []

    histories = current_user.histories
    category_type_id = params[:category_type_id].to_i
    data_interval, key_interval = intervalize(histories)
    data_interval.values.each do |d|
      total_value, correct_value = total_answers(d, category_type_id)
      incorrect_value = total_value - correct_value
      correct_data << correct_value
      incorrect_data << incorrect_value
    end

    data = {
      key_interval: key_interval,
      correct_data: correct_data,
      incorrect_data: incorrect_data
    }

    render :json => data, status => "200"
  
  end

  def performance_recently(histories, interval)
    date = Date.today - interval
    histories_recently = histories.find(:all, :conditions => ['created_at > ?', date])
    
    
    category_type = CategoryType.all
    subject_data = []
    category_type.each do |c|
      subject_data <<  {
        id: c.id, 
        name: c.category_name,
        data: {
          total_answers: total_answers(histories_recently, c.id)[0],
          correct_answers: total_answers(histories_recently, c.id)[1],
          percent: total_answers(histories_recently, c.id)[2]
        }
      }
    end

    return subject_data
  end

  def pull_pro_bar
    correct_data = []
    incorrect_data = []
    #
    #interval will be 1 (for today), or 7 (for last week), 
    #14 (for last two weeks), or 30 (for last month)
    #(Actually interval could be any integer)
    interval =  params[:interval]
    interval = interval.to_i
    histories = current_user.histories
    subject_data = performance_recently(histories, interval)
   
    render :json => subject_data, status => "200"
  end

end
