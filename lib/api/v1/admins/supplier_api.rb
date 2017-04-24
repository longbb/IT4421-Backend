class API::V1::Admins::SupplierAPI < Grape::API
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
            @data = {
              message: "Index suppliers successfully",
              suppliers: suppliers,
            }
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
                message: "Show supplier successfully",
                supplier: supplier,
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
        requires :name, type: String, desc: "Name of supplier"
        requires :description, type: String, desc: "Description of supplier"
        requires :address, type: String, desc: "Address of supplier"
        requires :phone_number, type: String, desc: "Phone number of supplier"
      end
      post "", jbuilder: "admins/suppliers/create" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            supplier = Supplier.new(
              name: params[:name],
              description: params[:description],
              address: params[:address],
              phone_number: params[:phone_number],
              status: "active"
            )
            if supplier.valid?
              if supplier.save
                @data = {
                  message: "Create supplier successfully",
                  supplier: supplier
                }
              else
                error!({ success: false, message: "Something error" }, 500)
              end
            else
              error!({ success: false, message: supplier.errors.full_messages }, 400)
            end
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Update supplier information"
      params do
        optional :name, type: String, desc: "Name of supplier"
        optional :description, type: String, desc: "Description of supplier"
        optional :address, type: String, desc: "Address of supplier"
        optional :phone_number, type: String, desc: "Phone number of supplier"
        at_least_one_of :name, :description, :address, :phone_number
      end
      patch "/:id", jbuilder: "admins/suppliers/update" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            supplier = Supplier.find(params[:id])
            if supplier.present? && supplier.is_active?
              if supplier.update(params.to_h)
                @data = {
                  message: "Update supplier info successfully",
                  supplier: supplier
                }
              else
                error!({ success: false, message: supplier.errors.full_messages }, 400)
              end
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

      desc "Delete supplier"
      delete "/:id", jbuilder: "admins/suppliers/destroy" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            supplier = Supplier.find(params[:id])
            if supplier.present? && supplier.is_active?
              if supplier.update(status: "deleted")
                @data = {
                  message: "Delete supplier successfully"
                }
              else
                error!({ success: false, message: supplier.errors.full_messages }, 400)
              end
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
    end
  end
end
