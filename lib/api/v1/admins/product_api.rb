class API::V1::Admins::ProductAPI < Grape::API
  namespace :admin do
    resouce :products do
      desc "Admin create product"
      params do
        requires :title, type: String, desc: "Title of product"
      end
    end
  end
end
