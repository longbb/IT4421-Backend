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
      user = User.new(
        email: params[:email],
        password: params[:password],
        status: "Active"
      )
      customer = Customer.new(
        email: params[:email],
        fullname: params[:fullname],
        address: params[:address],
        phone_number: params[:phone_number],
        status: "Active"
      )
      if user.valid?
        if customer.valid?
          if customer.save! && user.save!
            user.update(customer_id: customer.id)
            @data = {
              message: "User has been created",
              user: user,
              customer: customer
            }
          else
            error!({ success: false, message: "Something error" }, 500)
          end
        else
          error!({ success: false, message: customer.errors.full_messages }, 400)
        end
      else
        error!({ success: false, message: user.errors.full_messages }, 400)
      end
    end

    desc "Show user information"
    get "/current_user", jbuilder: "users/show" do
      email = request.headers["Authorization"]
      token_key = request.headers["Tokenkey"]
      if Session.authorized?(token_key, email)
        user = User.find_by(email: email)
        if user.present?
          customer = user.customer
          if customer.present?
            @data = {
              message: "Get user info successfully",
              user: user,
              customer: customer
            }
          else
            error!({ success: false, message: "Something error" }, 500)
          end
        else
          error!({ success: false, message: "User not found" }, 404)
        end
      else
        error!({ success: false, message: "Authenticate fail" }, 401)
      end
    end

    desc "Update current user information"
    params do
      optional :fullname, type: String, desc: "Name of user"
      optional :email, type: String, desc: "Email of user"
      optional :address, type: String, desc: "Address of user"
      optional :phone_number, type: String, desc: "Phone number of user"
      at_least_one_of :fullname, :email, :address, :phone_number
    end
    patch "/current_user", jbuilder: "users/update" do
      email = request.headers["Authorization"]
      token_key = request.headers["Tokenkey"]
      if Session.authorized?(token_key, email)
        user = User.find_by(email: email)
        if user.present?
          customer = user.customer
          if customer.present?
            if customer.update(params.to_h)
              if params[:email].present?
                user.update(email: params[:email])
              end
              @data = {
                message: "Update user info successfully",
                user: user,
                customer: customer
              }
            else
              error!({ success: false, message: customer.errors.full_messages }, 400)
            end
          else
            error!({ success: false, message: "Something error" }, 500)
          end
        else
          error!({ success: false, message: "User not found" }, 404)
        end
      else
        error!({ success: false, message: "Authenticate fail" }, 401)
      end
    end

    desc "Change password current user information"
    params do
      requires :old_password, type: String, desc: "old password of user"
      requires :new_password, type: String, desc: "new password of user"
    end
    patch "/current_user/change_password", jbuilder: "users/update" do
      email = request.headers["Authorization"]
      token_key = request.headers["Tokenkey"]
      if Session.authorized?(token_key, email)
        user = User.find_by(email: email)
        if user.present?
          if user.try(:authenticate, params[:old_password])
            if user.update(password: params[:new_password])
              @data = {
                message: "Change password successfully",
                user: user
              }
            else
              error!({ success: false, message: user.errors.full_messages }, 400)
            end
          else
            error!({ success: false, message: "Password does not match" }, 401)
          end
        else
          error!({ success: false, message: "User not found" }, 404)
        end
      else
        error!({ success: false, message: "Authenticate fail" }, 401)
      end
    end
  end
end
