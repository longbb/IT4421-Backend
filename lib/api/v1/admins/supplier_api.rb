class API::V1::Admins::SessionAPI < Grape::API
  resource :admins do
    resource :suppliers do
      desc "Index suppliers"
      get "", jbuilder: "admins/suppliers/index" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            suppliers = Supplier.active
            if suppliers.present?
              @data = {
                message: "Index suppliers successfully",
                suppliers: suppliers,
              }
            else
              error!({ success: false, message: "No suppliers" }, 500)
            end
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Show suppliers"
      get "/:id", jbuilder: "admins/suppliers/show" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            supplier = Supplier.find(params[:id])
            if supplier.present? && supplier.is_active?
              @data = {
                message: "Index suppliers successfully",
                suppliers: suppliers,
              }
            else
              error!({ success: false, message: "Supplier does not exist" }, 404)
            end
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Create new supplier"
      params do
      end
      post "/new", jbuilder: "admins/suppliers/create" do
      end
    end
  end
end
