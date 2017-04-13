require "rails_helper"
require "spec_helper"

RSpec.describe "AdminSession API", type: :request do
  before do
    @admin = create(:admin)
  end

  describe "Login" do
    context "When admin login successfully" do
      it "should success" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: "password", format: :json }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(json["message"]).to eq("Login successfully")
        expect(json["admin"]["id"]).to eq(@admin.id)
      end
    end
    context "When email is invalid" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: "email", password: @admin.password, format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(403)
        expect(json["message"]).to eq("Permission denied")
      end
    end
    context "When email is empty" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: "", password: @admin.password, format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(403)
        expect(json["message"]).to eq("Permission denied")
      end
    end
    context "When email is blank" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: " ", password: @admin.password, format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(403)
        expect(json["message"]).to eq("Permission denied")
      end
    end
    context "When email is nil" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: nil, password: @admin.password, format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(403)
        expect(json["message"]).to eq("Permission denied")
      end
    end
    context "When password is invalid" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: "123456788", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Invalid email or password")
      end
    end
    context "When password is empty" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: "", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Invalid email or password")
      end
    end
    context "When password is blank" do
      it "should fail" do
        post "/api/v1/admins/login", params: {email: @admin.email, password: " ", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Invalid email or password")
      end
    end
    context "When password is nil" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: nil, format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Invalid email or password")
      end
    end
  end

  describe "Logout" do
    context "When admin logout successfully" do
      it "should success" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: "password", format: :json }
        json_login = JSON.parse(response.body)
        token_key = json_login["token_key"]
        post "/api/v1/admins/logout", headers: { "Authorization": @admin.email, "Tokenkey": token_key }
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Logout successfully")
      end
    end
    context "When Authorization is invalid" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: "password", format: :json }
        json_login = JSON.parse(response.body)
        token_key = json_login["token_key"]
        post "/api/v1/admins/logout", headers: { "Authorization": "invalid#@test.com", "Tokenkey": token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is blank" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: "password", format: :json }
        json_login = JSON.parse(response.body)
        token_key = json_login["token_key"]
        post "/api/v1/admins/logout", headers: { "Authorization": " ", "Tokenkey": token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is empty" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: "password", format: :json }
        json_login = JSON.parse(response.body)
        token_key = json_login["token_key"]
        post "/api/v1/admins/logout", headers: { "Authorization": "", "Tokenkey": token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Authorization is nil" do
      it "should fail" do
        post "/api/v1/admins/login", params: { email: @admin.email, password: "password", format: :json }
        json_login = JSON.parse(response.body)
        token_key = json_login["token_key"]
        post "/api/v1/admins/logout", headers: { "Authorization": nil, "Tokenkey": token_key }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is invalid" do
      it "should fail" do
        post "/api/v1/admins/logout", headers: { "Authorization": @admin.email, "Tokenkey": "token_key" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is nil" do
      it "should fail" do
        post "/api/v1/admins/logout", headers: { "Authorization": @admin.email, "Tokenkey": nil }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is empty" do
      it "should fail" do
        post "/api/v1/admins/logout", headers: { "Authorization": @admin.email, "Tokenkey": "" }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
    context "When Tokenkey is blank" do
      it "should fail" do
        post "/api/v1/admins/logout", headers: { "Authorization": @admin.email, "Tokenkey": " " }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(401)
        expect(json["message"]).to eq("Authenticate fail")
      end
    end
  end
end
