Mattforni::Application.routes.draw do
  # Setup root route
  root :to => 'application#splash'

  # Setup devise routes for users
  devise_for :users

  # Setup blog routes
  scope '/blog' do
    get '/posts/new', as: :new_blog_post, to: 'blog_posts#new'
    post '/posts', as: :blog_posts, to: 'blog_posts#create'
  end

  # Setup finance routes
  scope '/finance' do
    get '/', as: :finance, to: 'finance#index'
    get '/charts/:symbol/(:period)',
      as: :charts,
      defaults: {
        period: 'six_months'
      },
      to: 'finance#charts'
    get '/details/:symbol', as: :details, to: 'finance#details'
    get '/historical/:symbol/(:period)',
      as: :historical,
      defaults: {
        period: 'one_month'
      },
      to: 'finance#historical'
    get '/quote/:symbol', as: 'finance_quote', to: 'finance#quote'
    get '/sizing', as: 'finance_sizing', to: 'finance#sizing'
  end

  namespace 'finance' do
    resources :portfolios, except: :show
    resources :positions, only: [:destroy, :edit, :update]
    resources :holdings, except: [:index, :show]
    resources :stops, except: :index

    get 'positions/:id/holdings', as: 'holdings_for_position', to: 'positions#holdings'
  end
end

