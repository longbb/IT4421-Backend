require "rails_helper"
require "spec_helper"

RSpec.describe "Variant API", type: :request do
  before do
    @admin = create(:admin)
    @supplier = create(:supplier)
    @product = create(:product, supplier_id: @supplier.id)
    @variant = create(:variant, product_id: @product.id)
    post "/api/v1/admins/login", params: { email: @admin.email, password: "password", format: :json }
    json_login = JSON.parse(response.body)
    @token_key = json_login["token_key"]
  end

  describe "Create new variant of a product" do
    before do
      @variant_params = {
        properties: [
          {
            name: "color",
            value: "blue"
          }
        ],
        image_url: "My String",
        inventory: 1000,
        original_price: 100,
        selling_price: 999
      }
    end

    context "When create successfully" do
      it "should success" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Create variant successfully")
        expect(json["variant"]).to_not be nil
        expect(json["variant"]["product_id"]).to eq(@product.id)
      end
    end

    context "When product not found" do
      it "should fail" do
        post "/api/v1/admins/products/0/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Product not found")
        expect(json["variant"]).to be nil
      end
    end

    context "When product's status is deleted" do
      before { @product.update(status: "deleted") }
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Product not found")
        expect(json["variant"]).to be nil
      end
    end

    context "When product options not match with properties" do
      before { @product.update(options: "size") }
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(json["message"]).to eq("Properties variant not match with options")
        expect(json["variant"]).to be nil
      end
    end

    context "When Authorization is invalid" do
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": "invalid#@test.com", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is blank" do
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": " ", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is empty" do
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": "", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is nil" do
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": nil, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is invalid" do
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": "token_key" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is nil" do
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": nil }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is empty" do
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": "" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is blank" do
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": " " }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When admin is deleted" do
      before { @admin.update(status: "deleted") }
      it "should fail" do
        post "/api/v1/admins/products/#{ @product.id}/variants", params: @variant_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Admin not found")
      end
    end
  end

  describe "Destroy a variant of a product" do
    context "When destroy successfully" do
      it "should success" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Destroy variant successfully")
        @variant.reload
        expect(@variant.status).to eq("deleted")
      end
    end

    context "When active successfully" do
      before { @variant.update(status: "deleted") }
      it "should success" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Active variant successfully")
        @variant.reload
        expect(@variant.status).to eq("active")
      end
    end

    context "When product not found" do
      it "should fail" do
        delete "/api/v1/admins/products/0/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Product not found")
      end
    end

    context "When product's status id deleted" do
      before { @product.update(status: "deleted") }
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Product not found")
      end
    end

    context "When variant not found" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/0",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Variant not found")
      end
    end

    context "When Authorization is invalid" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": "invalid#@test.com", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is blank" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": " ", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is empty" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": "", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is nil" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": nil, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is invalid" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": "token_key" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is nil" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": nil }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is empty" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": "" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is blank" do
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": " " }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When admin is deleted" do
      before { @admin.update(status: "deleted") }
      it "should fail" do
        delete "/api/v1/admins/products/#{@product.id}/variants/#{@variant.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Admin not found")
      end
    end
  end
end
