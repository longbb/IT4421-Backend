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
  end
end
