class API::V1::Admins::ProductAPI < Grape::API
  resource :admins do
    resource :products do
      desc "Admin create product"
      params do
        requires :title, type: String, desc: "Title of product"
        optional :description, type: String, desc: "Description of product"
        requires :images, type: String, desc: "Image urls of product, include image urls separated by commas"
        requires :supplier_id, type: Integer, desc: "Id of supplier"
        optional :options, type: String, desc: "Option of product, include name of options separated by commas"
        requires :variants_attributes, type: Array, desc: "Array variants of product" do
          optional :properties, type: Array, desc: "Array of properties" do
            requires :name, type: String, desc: "Name of property"
            requires :value, type: String, desc: "Value of property"
          end
          requires :image_url, type: String, desc: "Url image thumbnail of variant"
          requires :inventory, type: Integer, desc: "Inventory of variant"
          requires :original_price, type: Integer, desc: "Original price of variant"
          requires :selling_price, type: Integer, desc: "Selling price of variant"
        end
      end
      post "", jbuilder: "admins/products/create" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            if params[:options].present?
              product_options = params[:options].split(",")
              params[:variants_attributes].each do |variant|
                if variant[:properties].present?
                  if variant[:properties].length == product_options.length
                    variant[:properties].each do |property|
                      if product_options.index(property[:name]).nil?
                        error!({ success: false, message: "Properties variant not match with options" }, 400)
                        break
                      end
                    end
                    properties = variant[:properties].map do |property|
                      property.to_h
                    end
                    variant[:properties] = properties.inspect
                  else
                    error!({ success: false, message: "Properties variant not match with options" }, 400)
                  end
                else
                  error!({ success: false, message: "Properties variant not match with options" }, 400)
                end
              end
            else
              params[:variants_attributes].each do |variant|
                if variant[:properties].present?
                  error!({ success: false, message: "Properties variant not match with options" }, 400)
                end
              end
            end

            params[:status] = "active"
            params[:variants_attributes].each do |variant|
              variant[:status] = "active"
            end
            product = Product.new(params.to_h)
            if product.valid?
              if product.save
                @data = {
                  message: "Create product successfully",
                  product: product,
                  variants: product.variants
                }
              else
                error!({ success: false, message: "Something error" }, 500)
              end
            else
              error!({ success: false, message: product.errors.full_messages }, 400)
            end
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Index products"
      params do
        optional :page_no, type: Integer , desc: "Page no"
        optional :per_page, type: Integer, desc: "Number product per page"
        optional :key_word, type: String, desc: "Key word want to search"
        all_or_none_of :page_no, :per_page
      end
      get "", jbuilder: "admins/products/index" do
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
            products = Product.search(params[:page_no], params[:per_page], params[:key_word])
            @data = {
              message: "Index products successfully",
              products: products,
              total_products: Product.search(nil, nil, params[:key_word]).count
            }
          else
            error!({ success: false, message: "Admin not found" }, 404)
          end
        else
          error!({ success: false, message: "Authenticate fail" }, 401)
        end
      end

      desc "Show product"
      get "/:id", jbuilder: "admins/products/show" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            product = Product.find_by(id: params[:id])
            if product.present?
              @data = {
                message: "Show product successfully",
                product: product,
                variants: product.variants
              }
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

      desc "Update product"
      params do
        optional :title, type: String, desc: "Title of product"
        optional :description, type: String, desc: "Description of product"
        optional :images, type: String, desc: "Image urls of product, include image urls separated by commas"
        optional :supplier_id, type: Integer, desc: "Id of supplier"
        optional :variants_attributes, type: Array, desc: "Array variants of product" do
          requires :id, type: Integer, desc: "Id of variant want to update"
          optional :image_url, type: String, desc: "Url image thumbnail of variant"
          optional :inventory, type: Integer, desc: "Inventory of variant"
          optional :original_price, type: Integer, desc: "Original price of variant"
          optional :selling_price, type: Integer, desc: "Selling price of variant"
          at_least_one_of :image_url, :inventory, :original_price, :selling_price
        end
        at_least_one_of :title, :description, :images, :supplier_id, :variants_attributes
      end
      patch "/:id", jbuilder: "admins/products/update" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            product = Product.find_by(id: params[:id])
            if product.present?
              if params[:variants_attributes].present?
                params[:variants_attributes].each do |update_variant|
                  variant = Variant.find_by(id: update_variant[:id], product_id: params[:id])
                  unless variant.present?
                    error!({ success: false, message: "Variant not found" }, 404)
                  end
                end
              end
              if product.update(params.to_h)
                @data = {
                  message: "Update product successfully",
                  product: product,
                  variants: product.variants
                }
              else
                error!({ success: false, message: product.errors.full_messages }, 400)
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

      desc "Destroy product"
      delete "/:id", jbuilder: "admins/products/destroy" do
        email = request.headers["Authorization"]
        token_key = request.headers["Tokenkey"]
        if AdminSession.authorized?(token_key, email)
          admin = Admin.find_by(email: email, status: "active")
          if admin.present?
            product = Product.find_by(id: params[:id])
            if product.present?
              status = product.is_active? ? "deleted" : "active"
              variants = product.variants
              variants_attributes = Array.new
              variants.each do |variant|
                variants_attributes.push({ id: variant.id, status: status })
              end
              destroy_hash = {
                status: status,
                variants_attributes: variants_attributes
              }
              if product.update(destroy_hash)
                @data = {
                  message: "Destroy product successfully"
                }
              else
                error!({ success: false, message: "Something error" }, 500)
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
