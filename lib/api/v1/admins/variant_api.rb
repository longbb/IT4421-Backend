class API::V1::Admins::VariantAPI < Grape::API
  resource :admins do
    resource :products do
      segment "/:product_id" do
        resource :variants do
          desc "Admin create variant of product"
          params do
            optional :properties, type: Array, desc: "Array of properties" do
              requires :name, type: String, desc: "Name of property"
              requires :value, type: String, desc: "Value of property"
            end
            requires :image_url, type: String, desc: "Url image thumbnail of variant"
            requires :inventory, type: Integer, desc: "Inventory of variant"
            requires :original_price, type: Integer, desc: "Original price of variant"
            requires :selling_price, type: Integer, desc: "Selling price of variant"
          end
          post "", jbuilder: "admins/variants/create" do
            email = request.headers["Authorization"]
            token_key = request.headers["Tokenkey"]
            if AdminSession.authorized?(token_key, email)
              admin = Admin.find_by(email: email, status: "active")
              if admin.present?
                product = Product.find_by(id: params[:product_id], status: "active")
                if product.present?
                  if product.options.present?
                    product_options = product.options.split(",")
                    if params[:properties].present?
                      if params[:properties].length == product_options.length
                        params[:properties].each do |property|
                          if product_options.index(property[:name]).nil?
                            error!({ success: false, message: "Properties variant not match with options" }, 400)
                            break
                          end
                        end
                        properties = params[:properties].map do |property|
                          property.to_h
                        end
                        params[:properties] = properties.inspect
                      else
                        error!({ success: false, message: "Properties variant not match with options" }, 400)
                      end
                    else
                      error!({ success: false, message: "Properties variant not match with options" }, 400)
                    end
                  end
                  params[:status] = "active"
                  variant = Variant.new(params.to_h)
                  if variant.valid?
                    if variant.save
                      @data = {
                        message: "Create variant successfully",
                        variant: variant
                      }
                    else
                      error!({ success: false, message: "Something error" }, 500)
                    end
                  else
                    error!({ success: false, message: variant.errors.full_messages }, 400)
                  end
                else
                  error!({ success: false, message: "Product not found" }, 404)
                end
              else
                error!({ success: false, message: "Admin not found" }, 404)
              end
            else
              error!({ success: false, message: "Authenticate fail" }, 401)
            end
          end

          desc "Destroy variant"
          delete "/:id", jbuilder: "admins/variants/destroy" do
            email = request.headers["Authorization"]
            token_key = request.headers["Tokenkey"]
            if AdminSession.authorized?(token_key, email)
              admin = Admin.find_by(email: email, status: "active")
              if admin.present?
                product = Product.find_by(id: params[:product_id], status: "active")
                if product.present?
                  variant = Variant.find_by(id: params[:id])
                  if variant.present? && variant.product_id == product.id
                    status = variant.status == "active" ? "deleted" : "active"
                    if variant.update(status: status)
                      if status == "deleted"
                        @data = {
                          message: "Destroy variant successfully"
                        }
                      else
                        @data = {
                          message: "Active variant successfully"
                        }
                      end
                    else
                      error!({ success: false, message: "Something error" }, 500)
                    end
                  else
                    error!({ success: false, message: "Variant not found" }, 404)
                  end
                else
                  error!({ success: false, message: "Product not found" }, 404)
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
  end
end
