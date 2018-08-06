PathwayEditor::Application.routes.draw do
  get "data/index"
  get "data/search"

  root :to => 'pathways#index'

  resources 'pathways', :only => [:index, :new, :create, :show] do
    resources 'steps', :only => [:edit, :show] do
      resources 'instructions', :only => [:create, :update, :destroy]
      resources 'questions', :only => [:create, :update, :destroy]
      resources 'exit_conditions', :only => [:create, :update, :destroy]
    end

    put "steps/:id/edit", to: "steps#update"
    put 'steps/:id/modal_edit', to: 'steps#modal_edit', as: 'step_modal_edit'

    get 'steps/:id/preview/:return_step_id', to: 'steps#preview', as: 'preview_from_step'
    post 'steps/:id/preview/:return_step_id', to: 'steps#preview_submit', as: 'preview_from_step_submit'

    get :autocomplete_step_name, :on => :collection
    get 'step_titles' => 'pathways#step_titles', as: 'step_titles'
   end

  get 'pathways_autocomplete', to: 'pathways#autocomplete', as: 'autocomplete_pathway'
  get 'pathways_search', to: 'pathways#search', as: 'search_pathways'

  put '/pathways/:id/modal_edit', to: 'pathways#modal_edit', as: 'pathway_modal_edit'

  get "pathways/:id/tags", to: 'tags#index' # Edit all tags that belong to a pathway
  post "pathways/:id/tags", to: 'tags#create'

  get '/exit_conditions/edit_in_list' => 'exit_conditions#edit_in_list', as: 'edit_exit_condition_in_list'
  get '/steps/edit_instruction_in_list' => 'steps#edit_instruction_in_list', as: 'edit_instruction_in_list'
  get '/steps/edit_question_in_list' => 'steps#edit_question_in_list', as: 'edit_question_in_list'
  get '/steps/move_up_in_list' => 'steps#move_up_in_list', as: 'move_up_in_list'
  get '/steps/move_down_in_list' => 'steps#move_down_in_list', as: 'move_down_in_list'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
