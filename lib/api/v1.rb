class API::V1 < Grape::API
  version "v1", using: :path
  format :json

  mount UserAPI
end
