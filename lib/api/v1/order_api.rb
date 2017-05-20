class API::V1::OrderAPI < Grape::API
  resource :orders do
    desc "Index orders"
    params do
      optional :page_no, type: Integer , desc: "Page no"
      optional :per_page, type: Integer, desc: "Number order per page"
      optional :daterange, type: String, desc: "Datepicker want to search"
      all_or_none_of :page_no, :per_page
    end
    get "", jbuilder: "orders/index" do
      email = request.headers["Authorization"]
      token_key = request.headers["Tokenkey"]
      if Session.authorized?(token_key, email)
        user = User.find_by(email: email, status: "Active")
        if user.present?
          if params[:page_no].present? && params[:per_page].present?
            if params[:page_no] <= 0 || params[:per_page] <= 0
              error!({ success: false, message: "Per page and page no must be greater than 0" }, 400)
            end
          end
          arr_orders = Array.new
          orders = Order.search(user.customer, params[:page_no], params[:per_page], params[:daterange]).order(id: :desc)
          @data = {
            message: "Index orders successfully",
            orders: orders,
            total_orders: Order.search(user.customer, nil, nil, params[:daterange]).count
          }
        else
          error!({ success: false, message: "User not found" }, 404)
        end
      else
        error!({ success: false, message: "Authenticate fail" }, 401)
      end

    end

    desc "Create order"
    params do
      optional :customer, type: Hash, desc: "Customer information" do
        requires :fullname, type: String, desc: "Name of Customer"
        requires :email, type: String, desc: "Email of Customer"
        requires :address, type: String, desc: "Address of Customer"
        requires :phone_number, type: String, desc: "Phone number of Customer"
      end
      requires :total_price, type: Integer, desc: "Total price of order"
      requires :variants, type: Array, desc: "Array variants of order" do
        requires :variant_id, type: Integer, desc: "Id of variant"
        requires :quantity, type: Integer, desc: "Quantity of variant in order"
        requires :unit_price, type: Integer, desc: "Price of variant"
      end
    end
    post "", jbuilder: "orders/create" do
      if params[:customer].present?
        customer = Customer.new(
          fullname: params[:customer][:fullname],
          email: params[:customer][:email],
          address: params[:customer][:address],
          phone_number: params[:customer][:phone_number],
          status: "Active"
        )
        if customer.valid?
          customer.save
        else
          error!({ success: false, message: customer.errors.full_messages }, 400)
        end
      else
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if Session.authorized?(token_key, email)
          user = User.find_by(email: email, status: "Active")
          if user.present?
            customer = user.customer
          else
            error!({ success: false, message: "User not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      check_valid_order = Order.check_valid_order params[:variants]
      if check_valid_order[:valid]
        order = Order.new(
          customer_id: customer.id,
          total_price: params[:total_price],
          status: "active"
        )
        if order.valid?
          if order.save
            params[:variants].each do |variant_info|
              variant = Variant.find_by(id: variant_info[:variant_id], status: "active")
              order_variant = OrderVariant.create(
                order_id: order.id,
                variant_id: variant.id,
                quantity: variant_info[:quantity],
                unit_price: variant_info[:unit_price],
                status: "active"
              )
              old_inventory = variant.inventory - variant_info[:quantity]
              variant.update(inventory: old_inventory)
            end
            @data = {
              message: "Create order successfully",
              order: order
            }
          else
            error!({ success: false, message: "Something error" }, 500)
          end
        else
          error!({ success: false, message: order.errors.full_messages }, 400)
        end
      else
        error!({ success: false, message: check_valid_order[:message] }, check_valid_order[:error_code])
      end
    end
  end
end
