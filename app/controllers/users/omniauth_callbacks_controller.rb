class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    puts "Facebook Auth here"
    puts request.env["omniauth.auth"]
    @user = User.find_for_facebook_auth(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to root_path, alert: "Cannot authenticate through Facebook"
    end
  end

  def google_oauth2
    puts "Google Auth here"
    puts request.env["omniauth.auth"]
    @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to root_path, alert: "Cannot authenticate through Google"
    end
  end
end
