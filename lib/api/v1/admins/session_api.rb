class API::V1::Admins::SessionAPI < Grape::API
  resource :admins do
    desc "Admin Login"
    params do
      requires :email, type: String, desc: "Email of admin"
      requires :password, type: String, desc: "Password of admin"
    end
    post "/login", jbuilder: "admins/sessions/login" do
      admin = Admin.find_by(email: params[:email], status: "active")
      if admin.present?
        if admin.try(:authenticate, params[:password])
          token = SecureRandom.hex(16)
          token_key = AdminSession.create_token_key(token, params[:email])
          session = AdminSession.new(admin_id: admin.id, token_key: token_key, status: "active")
          if session.save!
            @data = {
              message: "Login successfully",
              admin: admin,
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

    desc "Admin logout"
    post "/logout", jbuilder: "admins/sessions/logout" do
      email = request.headers["Authorization"]
      token_key = request.headers["Tokenkey"]
      byebug
      if AdminSession.authorized?(token_key, email)
        if AdminSession.logout(token_key, email)
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
