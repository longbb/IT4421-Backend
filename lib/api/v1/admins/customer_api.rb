class API::V1::Admins::CustomerAPI < Grape::API
  resource :admins do
    resource :customers do
      desc "Index customers"
      params do
        optional :page_no, type: Integer , desc: "Page no"
        optional :per_page, type: Integer, desc: "Number order per page"
        optional :name, type: String, desc: "Name of customer want to search"
        all_or_none_of :page_no, :per_page
      end
      get "", jbuilder: "admins/customers/index" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            customers = Customer.search(params[:page_no], params[:per_page], params[:name])
            @data = {
              message: "Index customers successfully",
              customers: customers,
              total_customers: Customer.search(nil, nil, params[:name]).count
            }
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Show customers"
      get "/:id", jbuilder: "admins/customers/show" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            customer = Customer.find_by(id: params[:id])
            if customer.present?
              @data = {
                message: "Show customer successfully",
                customer: customer
              }
            else
              error!({ success: false, message: "Customer not found" }, 404)
            end
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Block customer"
      delete "/:id", jbuilder: "admins/customers/destroy" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            customer = Customer.find_by(id: params[:id])
            if customer.present?
              if customer.is_active?
                customer.update(status: "Blocked")
                if customer.user.present?
                  customer.user.update(status: "Blocked")
                end
                @data = {
                  message: "Block customer successfully",
                }
              else
                error!({ success: false, message: "Customer not active" }, 401)
              end
            else
              error!({ success: false, message: "Customer not found" }, 404)
            end
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end
    end
  end
end
