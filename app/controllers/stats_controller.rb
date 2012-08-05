class StatsController < WallpostsController


 
  #Return the correct percent of an user
  #of a subject (or all) over histories
  #category_type_id = 0 for all
  # 1 for Math, 2 for writing, 3 for CR
  # if user has done 0 question of the type, return 0
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

  #just like it sounds! Divide Histories into different
  #group of the same interval
  #The length of an interval is in s (seconds) and is specified
  #at the beginning of the method
  #return type:
  # data = {time: histories, time: histories, ...} and [time, time, time, ...]
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

  # return an array of correct percent over different interval
  # what it does basically is it takes a bunch of histories of a given
  # category_type ( 0 for all). It intervalizes the histories, call
  # correct percent on each of the interval
  # return type:
  # [percent, percent, percent, ...] and [time, time, time, ...]
  def percent_interval(histories, category_type_id)
    data, key_interval = intervalize(histories)
    correct_interval = data.values.map do |i|
      correct_percent(i, category_type_id)
    end

    return correct_interval, key_interval
  end

  #Return total questions answered and correct questions answered 
  # of a specific category_type over histories, and percentage of correct answers
  # return type:
  #   total, correct, percent

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

  # It will look at the most recent part of Histories specified by interval.
  # Interval here is not the same concept as interval specified above. Interval 
  # defined above is the interval of time that the histories are divided into
  # Interval here is the length of time (in days) that we want to consider while looking at
  # Histories. 
  # for each category type it will return a hash of data { data } with fields specified below
  # return type: [{data} , {data}, {data}, ...]
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

  # render to stats/pull/:category_type_id
  # render data of the form [percent, percent, percent,..] and 
  # [time, time, time, ..] 
  
#  def pull
#    category_type_id = params[:category_type_id].to_i
#    histories = current_user.histories

#    @correct_interval, @key_interval = percent_interval(histories, category_type_id)
#    @correct_interval = @correct_interval.reverse
#    @key_interval = @key_interval.reverse
#    data = {
#      key_interval: @key_interval, 
#      correct_interval: @correct_interval
#    }
#    render :json => data, :status => "200"
#  end


  #render to stats/pull_stacked/:id 
  #time of different intervals, number of correct answers
  # and incorrect answers of each interval

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
      key_interval: key_interval.reverse,
      correct_data: correct_data.reverse,
      incorrect_data: incorrect_data.reverse
    }

    render :json => data, status => "200"
  
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
