class API::V1::SessionAPI < Grape::API
  resource :login do
    desc "User Login"
    params do
      requires :email, type: String, desc: "Email of user"
      requires :password, type: String, desc: "Password of user"
    end
    post "", jbuilder: "sessions/login" do
      user = User.find_by(email: params[:email], status: "Active")
      if user.present?
        if user.try(:authenticate, params[:password])
          token = SecureRandom.hex(16)
          token_key = Session.create_token_key(token, params[:email])
          session = Session.new(user_id: user.id, token_key: token_key, status: "active")
          if session.save!
            @data = {
              message: "Login successfully",
              user: user,
              token_key: token
            }
          else
            error!({ success: false, message: "Something error" }, 500)
          end
        else
          error!({ success: false, message: "Invalid email or password" }, 401)
        end
      else
        error!({ success: false, message: "Permission denied" }, 403)
      end
    end
  end

  resource :logout do
    desc "User logout"
    post "", jbuilder: "sessions/logout" do
      email = request.headers["Authorization"]
      token_key = request.headers["Tokenkey"]
      if Session.authorized?(token_key, email)
        if Session.logout(token_key, email)
          @data = { success: true, message: "Logout successfully" }
        else
          error!({ success: false, message: "Something error" }, 500)
        end
      else
        error!({ success: false, message: "Authenticate fail" }, 401)
      end
    end
  end
end
