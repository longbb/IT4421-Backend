class API::V1 < Grape::API
  version "v1", using: :path
  format :json

  mount UserAPI
  mount SessionAPI
  mount FeedbackAPI
  mount ProductAPI
  mount Admins::SessionAPI
  mount Admins::SupplierAPI
  mount Admins::ProductAPI
  mount Admins::VariantAPI
end
