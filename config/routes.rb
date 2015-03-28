Rails.application.routes.draw do
  root 'welcome#index'

  resources :orders do
    collection do
      get 'pay'
      get 'success'
    end
  end

  resources :cook do
    collection do
      get 'detail'
      get 'success'
    end
  end
end
