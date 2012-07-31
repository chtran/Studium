Studium::Application.routes.draw do

  resources :badges

  get "/pusher_key", to: "application#pusher_key"
  get "users/index"

  get "stats/show", to: "stats#show"

  get "/awaiting_confirmation",to: "users#dashboard",as: :confirm_user
  get "/dashboard",to: "users#dashboard",as: :user_root

  get "/users/:user_id/profile", to: "profiles#show", as: "user_profile"
  get "/users/:user_id/profile/edit", to: "profiles#edit",as: "edit_user_profile"
  put "/users/:user_id/profile",to: "profiles#update"
  post "/users/:user_id/profile/increase_reputation",to: "profiles#increase_reputation",as: :increase_reputation

  get "/admin",to: "homepage#admin",as: "admin_index"
  get "/admin/materials",to: "admin/materials/base#index",as: "admin_materials"
  get "/admin/materials/questions/add_question",to: "admin/materials/questions#category_selection",as: "add_new_materials_question" 

  get "/admin/materials/questions/edit_paragraph",to: "admin/materials/questions#edit_paragraph",as: "admin_materials_question_edit_paragraph"

  get ":controller/:action.:format"

  get "/admin/materials/questions/cancel_edit_question",to: "admin/materials/questions#cancel_edit_question"
  get "/admin/materials/questions/remove_paragraph",to: "admin/materials/questions#remove_paragraph"
  get "/admin/materials/questions/remove_choice",to: "admin/materials/questions#remove_choice"

  resources :category_types
  resources :question_types
  namespace "admin" do
    namespace "materials" do
      root to: "base#index",as: "admin_materials_index"
      resources :questions
      resources :paragraphs
    end
  end

  resources :rooms
  get "/rooms/join/:room_id", to: "rooms#join", as:"room_join"
  #get "/choose/:room_id/:choice_id", to: "rooms#choose", as:"room_choose_choice"
  post "/rooms/choose", to: "rooms#choose", as: "room_choose_choice"
  post "/rooms/show_question", to: "rooms#show_question", as: "room_show_question"
  post "/rooms/show_explanation", to: "rooms#show_explanation", as: "room_show_explanation"
  #post "/rooms/show_new_room_item", to: "rooms#show_new_room_item"
  post "/rooms/room_list", to: "rooms#room_list"
  post "/rooms/user_list", to: "rooms#user_list"
  post "/rooms/ready", to: "rooms#ready"
  get "/review/:room_id", to: "rooms#review", as: "room_review"
  post "/rooms/kick", to: "rooms#kick"
  post "/histories/show_history",to: "histories#show_history"
  post "/rooms/show_histories",to: "rooms#show_histories"
  post "/rooms/invite", to: "rooms#invite"

  post "/pusher/auth", to: "pusher#auth"
  post "/pusher/webhook", to: "pusher#webhook"
  devise_for :users,controllers: {registrations: "registrations", omniauth_callbacks: "users/omniauth_callbacks"}

  get "/stats", to: "stats#index", as: "stats"
  get "/stats/pull_pro_bar/:interval", to:"stats#pull_pro_bar"
  get "/stats/pull/:category_type_id", to: "stats#pull"
  get "/stats/pull_stacked/:category_type_id", to: "stats#pull_stacked"

  get "admin/reports/users", to: "admin/reports#users"
  post "rooms/chat_message",to: "rooms#chat_message",as: "room_chat_message"

  post "messages/send_message", to: "messages#send_message"
  get "messages/show/:id", to: "messages#show"
  resources :messages

  post "friendships/request", to: "friendships#request"

  root to: "homepage#index",as: :index
end
