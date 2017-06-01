class API::V1::Admins::DashboardAPI < Grape::API
  resource :admins do
    resource :dashboard do
      desc "Index"
      get "", jbuilder: "admins/dashboard/index" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            total_items = Product.active.count
            total_revenues = Order.sum(:total_price)
            total_customer = Customer.active.count
            order_need_complete = Order.active.count

            begin_date = 6.days.ago.to_date
            end_date = Time.now.to_date
            revenues_statistic = Order.statistic_revenues(begin_date, end_date)

            top_3_products = OrderVariant.top_3_product
            @data = {
              message: "Index dashboard successfully",
              total_items: total_items,
              total_revenues: total_revenues,
              total_customer: total_customer,
              order_need_complete: order_need_complete,
              revenues_statistic: revenues_statistic,
              top_3_products: top_3_products
            }
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
