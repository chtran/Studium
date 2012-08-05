class ProfilesController < StatsController
  before_filter :find_user
  before_filter :find_profile
  before_filter :authenticate_update!,only: [:edit,:update]
  before_filter :authenticate_user!,only: [:increase_reputation]

  def show

    @user=User.find params[:user_id]
    histories = @user.histories
    #when the page is loaded for the first time,
    #show stats of today
    interval = 1
    @subject_data = performance_recently(histories, interval)

    # Wallposts data
    gon.user_id = current_user.id
    gon.viewed_user_id = params[:user_id]
    @viewed_user = User.find(params[:user_id])
    gon.profile_id = @viewed_user.profile.id
    @wallposts   = @viewed_user.profile.wallposts.find(:all, :order=>'created_at DESC')
    # end of wallposts data

    @badges=current_user.badges
  end

  def edit
  end

  def update
    @profile.update_attributes! params[:profile]
    redirect_to user_profile_url(@user),notice: "Profile has been updated."

  rescue
    flash[:alert]="Profile has not been updated."
    render "edit"
  end

  def increase_reputation
    chat_message=ChatMessage.find params[:chat_message_id]
    reputation_increase=params[:reputation_increase]

    if current_user!=@profile.user and !chat_message.users.include?(current_user)
      @profile.reputation+=reputation_increase.to_i
      chat_message.users << current_user
      chat_message.save!
      @profile.save!

      consider_altruist_badge(@profile.user,@profile.reputation)
    end

    redirect_to index_path
  end

  def consider_altruist_badge(user,reputation)
    altruist_badge=BadgeManager.consider_altruist_badges(user,reputation)
  
    if altruist_badge!=nil
      publish_async("presence-rooms", "update_recent_activities", {
        message: "User #{user.name} has received #{altruist_badge.name} badge. Congratulations!"
      })
    end
  end

  def update_status
    profile_status = params[:status]
    status_partial = render_to_string partial: 'status'
    current_user.profile.update_attribute(:status, profile_status)

    render json: {
      status_partial: status_partial
    }
  end

  def pull
    category_type_id = params[:category_type_id].to_i
    histories = User.find(params[:user_id]).histories

    @correct_interval, @key_interval = percent_interval(histories, category_type_id)
    @correct_interval = @correct_interval.reverse
    @key_interval = @key_interval.reverse
    data = {
      key_interval: @key_interval, 
      correct_interval: @correct_interval
    }
    render :json => data, :status => "200"
  end


  #render to stats/pull_stacked/:id 
  #time of different intervals, number of correct answers
  # and incorrect answers of each interval

  def pull_stacked
    correct_data = []
    incorrect_data = []
    
    @viewed_user = User.find(params[:user_id])
    histories = @viewed_user.histories
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
    
    @viewed_user = User.find(params[:user_id])
    #interval will be 1 (for today), or 7 (for last week), 
    #14 (for last two weeks), or 30 (for last month)
    #(Actually interval could be any integer)
    interval =  params[:interval]
    interval = interval.to_i
    histories = @viewed_user.histories
    subject_data = performance_recently(histories, interval)
   
    render :json => subject_data, status => "200"
  end


private
  def find_user
    @user=User.find params[:user_id]

  rescue
    redirect_to index_url,alert: "The user you were looking for could not be found."
  end

  def find_profile
    @profile=@user.profile
  end

  def authenticate_update!
    redirect_to index_url,alert: "You do not have permission to update the profile of that user." unless user_signed_in? and current_user==@user
  end

end
