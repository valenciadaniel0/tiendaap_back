Rails.application.routes.draw do
  namespace :v1 do
    resources :categories
    resources :items do
      collection do
        get '/:code/find_by_code', to: 'items#find_by_code'
      end
    end
    resources :products
    resources :users do
      collection do
        post :login
      end
    end
  end
end
