class UsersController < ApplicationController
  def dashboard
    # If user has not signed in, redirect to home page
    if !user_signed_in?
      redirect_to index_url,alert: "You have not signed in. Please sign in or join our community!"
    else
      redirect_to rooms_url
    end
  end

  def get_user_data
    email = params[:email]
    @user = User.where("email = '#{email}'").first
    render json: {
      email: @user.email,
      name: @user.name,
      image: @user.profile.image
    }
  end

end
