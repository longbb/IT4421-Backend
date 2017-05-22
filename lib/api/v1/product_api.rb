class API::V1::ProductAPI < Grape::API
  resource :products do
    desc "Index products"
    params do
      optional :page_no, type: Integer , desc: "Page no"
      optional :per_page, type: Integer, desc: "Number product per page"
      optional :key_word, type: String, desc: "Key word want to search"
      all_or_none_of :page_no, :per_page
      optional :category, type: String, desc: "Category of products"
      optional :sort_name, type: String, desc: "Sort type products by name", values: ["asc", "desc"]
    end
    get "", jbuilder: "products/index" do
      if params[:page_no].present? && params[:per_page].present?
        if params[:page_no] <= 0 || params[:per_page] <= 0
          error!({ success: false, message: "Per page and page no must be greater than 0" }, 400)
        end
      end
      products = Product.active.search(params[:page_no], params[:per_page],
        params[:key_word], params[:category], params[:sort_name])
      @data = {
        message: "Index products successfully",
        products: products,
        total_products: Product.search(nil, nil, params[:key_word], params[:category], params[:sort_name]).count
      }
    end

    desc "Show product"
    get "/:id", jbuilder: "products/show" do
      product = Product.find_by(id: params[:id], status: "active")
      if product.present?
        @data = {
          message: "Show product successfully",
          product: product,
          variants: product.variants.active
        }
      else
        error!({ success: false, message: "Product not found" }, 404)
      end
    end
  end
end
