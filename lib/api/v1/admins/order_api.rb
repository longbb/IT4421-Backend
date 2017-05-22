class API::V1::Admins::OrderAPI < Grape::API
  resource :admins do
    resource :orders do
      desc "Index orders"
      params do
        optional :page_no, type: Integer , desc: "Page no"
        optional :per_page, type: Integer, desc: "Number order per page"
        optional :daterange, type: String, desc: "Datepicker want to search"
        optional :customer_id, type: Integer, desc: "Id of customer"
        all_or_none_of :page_no, :per_page
      end
      get "", jbuilder: "admins/orders/index" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            if params[:page_no].present? && params[:per_page].present?
              if params[:page_no] <= 0 || params[:per_page] <= 0
                error!({ success: false, message: "Per page and page no must be greater than 0" }, 400)
              end
            end

            if params[:customer_id].present?
              customer = Customer.find_by(id: params[:customer_id])
              unless customer.present?
                error!({ success: false, message: "Customer not found" }, 404)
              end
            else
              customer = nil
            end
            orders = Order.search(customer, params[:page_no], params[:per_page], params[:daterange]).order(id: :desc)
            @data = {
              message: "Index orders successfully",
              orders: orders,
              total_orders: Order.search(customer, nil, nil, params[:daterange]).count
            }
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Show orders"
      get "/:id", jbuilder: "admins/orders/show" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            order = Order.find_by(id: params[:id])
            if order.present?
              @data = {
                message: "Show order successfully",
                order: order
              }
            else
              error!({ success: false, message: "Order not found" }, 404)
            end
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Update status orders"
      params do
        requires :status, type: String, desc: "Status want update", values: Settings.order.status
      end
      patch "/:id", jbuilder: "admins/orders/update" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            order = Order.find_by(id: params[:id])
            if order.present?
              if order.update(status: params[:status])
                @data = {
                  message: "Update status order successfully"
                }
              else
                error!({ success: false, message: order.errors.full_messages }, 400)
              end
            else
              error!({ success: false, message: "Order not found" }, 404)
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
