require "rails_helper"
require "spec_helper"

RSpec.describe "Supplier API", type: :request do
  before do
    @admin = create(:admin)
    @supplier1 = create(:supplier)
    @supplier2 = create(:supplier , name: "Chi Hoa", description: "Ban quan ao")
    post "/api/v1/admins/login", params: { email: @admin.email, password: "password", format: :json }
    json_login = JSON.parse(response.body)
    @token_key = json_login["token_key"]
  end

  describe "Index suppliers" do
    context "When admin call index successfully" do
      it "should success" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Index suppliers successfully")
        expect(json["suppliers"].length).to eq 2
      end
    end
    context "When Authorization is invalid" do
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": "invalid#@test.com", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is blank" do
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": " ", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is empty" do
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": "", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is nil" do
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": nil, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is invalid" do
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": @admin.email, "Tokenkey": "token_key" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is nil" do
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": @admin.email, "Tokenkey": nil }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is empty" do
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": @admin.email, "Tokenkey": "" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is blank" do
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": @admin.email, "Tokenkey": " " }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When admin is deleted" do
      before { @admin.update(status: "deleted") }
      it "should fail" do
        get "/api/v1/admins/suppliers",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Admin not found")
      end
    end
  end

  describe "Show supplier" do
    context "When show successfully" do
      it "should success" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Show supplier successfully")
        expect(json["supplier"]["description"]).to eq("Ban quan ao")
      end
    end
    context "When Authorization is invalid" do
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": "invalid#@test.com", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is blank" do
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": " ", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is empty" do
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": "", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is nil" do
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": nil, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is invalid" do
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": "token_key" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is nil" do
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": nil }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is empty" do
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": "" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is blank" do
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": " " }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When admin is deleted" do
      before { @admin.update(status: "deleted") }
      it "should fail" do
        get "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Admin not found")
      end
    end
  end

  describe "Create new supplier" do
    before do
      @supplier_params = {
        name: "New supplier",
        address: "HN",
        description: "Buon ban",
        phone_number: "1234567890",
        format: :json
      }
    end
    context "When create successfully" do
      it "should success" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Create supplier successfully")
        expect(json["supplier"]).to_not be nil
      end
    end
    context "When name is too long" do
      before { @supplier_params["name"] = "a"*51 }
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"][0]).to eq("Name is too long (maximum is 50 characters)")
        expect(json["supplier"]).to be nil
      end
    end
    context "When phone_number is not in 10 or 11 chracter" do
      before { @supplier_params["phone_number"] = "101234567" }
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"][0]).to eq("Phone number is too short (minimum is 10 characters)")
        expect(json["supplier"]).to be nil
      end
    end
    context "When Authorization is invalid" do
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": "invalid#@test.com", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is blank" do
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": " ", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is empty" do
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": "", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is nil" do
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": nil, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is invalid" do
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": "token_key" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is nil" do
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": nil }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is empty" do
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": "" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is blank" do
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": " " }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When admin is deleted" do
      before { @admin.update(status: "deleted") }
      it "should fail" do
        post "/api/v1/admins/suppliers", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Admin not found")
      end
    end
  end

  describe "Update supplier" do
    before do
      @supplier_params = {
        address: "Ha Noi Viet Nam"
      }
    end
    context "When update successfully" do
      it "should success" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: { name: "Chi Lan" },
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Update supplier info successfully")
        expect(json["supplier"]["name"]).to eq("Chi Lan")
        expect(json["supplier"]["id"]).to eq(@supplier2.id)
      end
    end
    context "When name is too long" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: { name: "a"*51 },
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"][0]).to eq("Name is too long (maximum is 50 characters)")
        expect(json["supplier"]).to be nil
      end
    end
    context "When phone_number is not in 10 or 11 chracter" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}",
          params: { phone_number: "123456789" },
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"][0]).to eq("Phone number is too short (minimum is 10 characters)")
        expect(json["supplier"]).to be nil
      end
    end
    context "When Authorization is invalid" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": "invalid#@test.com", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is blank" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": " ", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is empty" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": "", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is nil" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": nil, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is invalid" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": "token_key" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is nil" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": nil }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is empty" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": "" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is blank" do
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": " " }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When admin is deleted" do
      before { @admin.update(status: "deleted") }
      it "should fail" do
        patch "/api/v1/admins/suppliers/#{@supplier2.id}", params: @supplier_params,
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Admin not found")
      end
    end
  end

  describe "Destroy a supplier" do
    context "When destroy successfully" do
      it "should success" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Delete supplier successfully")
        @supplier2.reload
        expect(@supplier2.status).to eq("deleted")
      end
    end
    context "When Authorization is invalid" do
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": "invalid#@test.com", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is blank" do
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": " ", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is empty" do
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": "", "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is nil" do
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": nil, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is invalid" do
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": "token_key" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is nil" do
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": nil }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is empty" do
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": "" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is blank" do
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": " " }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When admin is deleted" do
      before { @admin.update(status: "deleted") }
      it "should fail" do
        delete "/api/v1/admins/suppliers/#{@supplier2.id}",
          headers: { "Authorization": @admin.email, "Tokenkey": @token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(404)
        expect(json["message"]).to eq("Admin not found")
      end
    end
  end
end
