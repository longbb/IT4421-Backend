class API::V1::UserAPI < Grape::API
  resource :users do
    desc "Register new member"
    params do
      requires :fullname, type: String, desc: "Name of user"
      requires :email, type: String, desc: "Email of user"
      requires :password, type: String, desc: "Password of user"
      requires :address, type: String, desc: "Address of user"
      requires :phone_number, type: String, desc: "Phone number of user"
    end
    post "", jbuilder: "users/create" do
      params[:status] = "Active"
      user = User.new(params.to_h)
      if user.valid?
        if user.save!
          @data = {
            message: "User has been created",
            user: user
          }
        else
          error!({ success: false, message: "Something error" }, 500)
        end
      else
        error!({ success: false, message: user.errors.messages }, 400)
      end
    end
  end
end
