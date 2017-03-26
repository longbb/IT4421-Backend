class API < Grape::API
  format :json
  formatter :json, Grape::Formatter::Jbuilder

  mount API::V1
end
