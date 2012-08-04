Studium::Application.routes.draw do
  get "/awaiting_confirmation",to: "users#dashboard",as: :confirm_user
  get "/dashboard",to: "users#dashboard",as: :user_root

  # Badge routes
  resources :badges,only: [:index]

  # User authentication
  devise_for :users,controllers: {registrations: "registrations", omniauth_callbacks: "users/omniauth_callbacks"}
  get "users/index"

  # Profile Routes
  controller :profiles,path: "/users/:user_id/profile" do
    get action: "show", as: "user_profile"
    get :edit,as: "edit_user_profile"
    put action: "update"
    post :increase_reputation
    post :update_status 
  end

  # Category Type Routes
  resources :category_types,:question_types,only: [:new,:create,:index] 

  # Message routes
  resources :messages,only: [:index,:create,:show]

  # Rooms_controller routes
  resources :rooms,only: [:index,:create]
  controller :rooms,path: "/rooms",as: "room" do
    #get "/join/:room_title", action: "join", as: "join"
    get "/join/:room_id", action: "join", as: "join" 
    get :leave_room
    post :confirm
    post :show_question
    post :show_explanation
    post :room_list
    post :user_list
    post :ready
    post :kick
    post :show_histories
    post :invite
    post :chat_message
    post :show_current_user
    
    get "/review/:room_id", to: "rooms#review", as: "review"

  end

  # Admin-related routes
  get "admin", to: "homepage#admin",as: "admin_index"
  namespace "admin" do
    # Report
    get "reports/users"

    # Material namespace
    namespace "materials" do
      # Root page for material namespace
      root to: "base#index",as: "index"

      # Routes for questions and paragraphs
      resources :questions,:paragraphs

      controller :questions do
        get :cancel_edit_question
        get :remove_paragraph
        get :remove_choice
        get :category_selection,as: "add_question" 
        get :edit_paragraph,as: "admin_materials_question_edit_paragraph"
      end
    end
  end

  # Histories routes
  post "/histories/show_history",to: "histories#show_history"

  # Pusher routes
  get "/pusher_key", to: "application#pusher_key"
  controller :pusher,path: "/pusher" do
    post :auth
    post :webhook
  end

  # Stats routes
  controller :stats,path: "/stats" do
    root action: "index", as: "stats"
    get :show
    post :pull_pro_bar
    get 'pull_pro_bar/:interval', action: 'pull_pro_bar'
    get "pull/:category_type_id", action: "pull"
    get "pull_stacked/:category_type_id", action: "pull_stacked"
  end

  resources :messages

  # Friendship routes
  post "friendships/request", to: "friendships#request"

  # Root page
  root to: "homepage#index",as: :index

  # Emergency routing
  get ":controller/:action.:format"
end
