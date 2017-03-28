class API::V1::SessionAPI < Grape::API
  resource :login do
    desc "Login"
    params do
      requires :email, type: String, desc: "Email of user"
      requires :password, type: String, desc: "Password of user"
    end
    post "", jbuilder: "sessions/login" do
      user = User.find_by(email: params[:email], status: "Active")
        .try(:authenticate, params[:password])
      if user.present?

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
