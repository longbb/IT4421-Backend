require "rails_helper"
require "spec_helper"

RSpec.describe "User API", type: :request do
  describe "Create user" do
    describe "Create user with invalid information" do
      describe "Create user with invalid email" do
        context "Email does not present" do
          it "should return user error" do
            ["", nil, " "].each do |not_present|
              post "/api/v1/users", params: { email: not_present, password: "password",
                address: "new address", phone_number: "0147963258", fullname: "new customer", format: :json }
              json = JSON.parse(response.body)
              expect(response).to have_http_status(400)
              expect(json["message"]).to include("Email can't be blank")
              expect(json["message"]).to include("Email is invalid")
            end
          end
        end

        context "Email too long" do
          it "should return user error" do
            post "/api/v1/users", params: { email: "toolong" * 100 + "@test.com", password: "password",
              address: "new address", phone_number: "0147963258", fullname: "new customer", format: :json }
            json = JSON.parse(response.body)
            expect(response).to have_http_status(400)
            expect(json["message"]).to include("Email is too long (maximum is 255 characters)")
          end
        end

        context "Email is invalid format" do
          it "should return user error" do
            post "/api/v1/users", params: { email: "invalid_format", password: "password",
              address: "new address", phone_number: "0147963258", fullname: "new customer", format: :json }
            json = JSON.parse(response.body)
            expect(response).to have_http_status(400)
            expect(json["message"]).to include("Email is invalid")
          end
        end

        context "Email was registered by another user" do
          before do
            @another_user = create :user
          end
          it "should return user error" do
            post "/api/v1/users", params: { email: @another_user.email + "@test.com", password: "password",
              address: "new address", phone_number: "0147963258", fullname: "new customer", format: :json }
            json = JSON.parse(response.body)
            expect(response).to have_http_status(400)
            expect(json["message"]).to include("Email is invalid")
          end
        end
      end

      describe "Create user with invalid name" do
        context "Name does not present" do
          it "should return user error" do
            ["", nil, " "].each do |not_present|
              post "/api/v1/users", params: { email: "new_user@test.com", password: "password",
                address: "new address", phone_number: "0147963258", fullname: not_present, format: :json }
              json = JSON.parse(response.body)
              expect(response).to have_http_status(400)
              expect(json["message"]).to include("Fullname can't be blank")
            end
          end
        end

        context "Name too long" do
          it "should return user error" do
            ["", nil, " "].each do |not_present|
              post "/api/v1/users", params: { email: "new_user@test.com", password: "password",
                address: "new address", phone_number: "0147963258", fullname: "toolong" * 100, format: :json }
              json = JSON.parse(response.body)
              expect(response).to have_http_status(400)
              expect(json["message"]).to include("Fullname is too long (maximum is 50 characters)")
            end
          end
        end
      end

      describe "Create user with invalid address" do
        context "Address does not present" do
          it "should return user error" do
            ["", nil, " "].each do |not_present|
              post "/api/v1/users", params: { email: "new_user@test.com", password: "password",
                address: not_present, phone_number: "0147963258", fullname: "new user", format: :json }
              json = JSON.parse(response.body)
              expect(response).to have_http_status(400)
              expect(json["message"]).to include("Address can't be blank")
            end
          end
        end
      end

      describe "Create user with invalid phone_number" do
        context "Phone number does not present" do
          it "should return user error" do
            ["", nil, " "].each do |not_present|
              post "/api/v1/users", params: { email: "new_user@test.com", password: "password",
                address: "new address", phone_number: not_present, fullname: "new user", format: :json }
              json = JSON.parse(response.body)
              expect(response).to have_http_status(400)
              expect(json["message"]).to include("Phone number can't be blank")
            end
          end
        end

        context "Phone number is invalid format" do
          it "should return user error" do
            post "/api/v1/users", params: { email: "new_user@test.com", password: "password",
              address: "new address", phone_number: "notvaild", fullname: "new user", format: :json }
            json = JSON.parse(response.body)
            expect(response).to have_http_status(400)
            expect(json["message"]).to include("Phone number is invalid")
          end
        end

        context "Phone number is too short" do
          it "should return user error" do
            post "/api/v1/users", params: { email: "new_user@test.com", password: "password",
              address: "new address", phone_number: "014785", fullname: "new user", format: :json }
            json = JSON.parse(response.body)
            expect(response).to have_http_status(400)
            expect(json["message"]).to include("Phone number is too short (minimum is 10 characters)")
          end
        end

        context "Phone number is too long" do
          it "should return user error" do
            post "/api/v1/users", params: { email: "new_user@test.com", password: "password",
              address: "new address", phone_number: "01478512356789", fullname: "new user", format: :json }
            json = JSON.parse(response.body)
            expect(response).to have_http_status(400)
            expect(json["message"]).to include("Phone number is too long (maximum is 11 characters)")
          end
        end

        describe "Create user with invalid password" do
          context "Password does not present" do
            it "should return user error" do
              ["", nil, " "].each do |not_present|
                post "/api/v1/users", params: { email: "new_user@test.com", password: not_present,
                  address: "new address", phone_number: "0147963258", fullname: "new user", format: :json }
                json = JSON.parse(response.body)
                expect(response).to have_http_status(400)
                expect(json["message"]).to include("Password is too short (minimum is 8 characters)")
              end
            end
          end

          context "Password is too short" do
            it "should return user error" do
              post "/api/v1/users", params: { email: "new_user@test.com", password: "short",
                address: "new address", phone_number: "0147963258", fullname: "new user", format: :json }
              json = JSON.parse(response.body)
              expect(response).to have_http_status(400)
              expect(json["message"]).to include("Password is too short (minimum is 8 characters)")
            end
          end

          context "Phone number is too long" do
            it "should return user error" do
              post "/api/v1/users", params: { email: "new_user@test.com", password: "toolong" * 20,
                address: "new address", phone_number: "0147963258", fullname: "new user", format: :json }
              json = JSON.parse(response.body)
              expect(response).to have_http_status(400)
              expect(json["message"]).to include("Password is too long (maximum is 20 characters)")
            end
          end
        end
      end
    end

    describe "Create user with valid information" do
      it "should create user" do
        post "/api/v1/users", params: { email: "new_user@test.com", password: "password",
          address: "new address", phone_number: "0147963258", fullname: "new customer", format: :json }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(json["message"]).to eq "User has been created"
        expect(json["user"]["email"]).to eq "new_user@test.com"
        expect(json["customer"]["email"]).to eq "new_user@test.com"
        expect(json["customer"]["address"]).to eq "new address"
        expect(json["customer"]["phone_number"]).to eq "0147963258"
        expect(json["customer"]["fullname"]).to eq "new customer"
      end
    end
  end

  describe "Show current user" do
    describe "Show current user with invalid information" do
      context "When authention fail" do
        it "should return 401 error" do
          get "/api/v1/users/current_user"
          json = JSON.parse(response.body)
          expect(response).to have_http_status 401
          expect(json["message"]).to eq "Authenticate fail"
        end
      end
    end

    describe "Show current user with vaild information" do
      before do
        @customer = create :customer
        @user = create :user, email: @customer.email, customer_id: @customer.id
      end
      it "should return current user information" do
        post "/api/v1/login", params: { email: @user.email, password: "password", format: :json }
        json_login = JSON.parse(response.body)
        token_key = json_login["token_key"]
        get "/api/v1/users/current_user", headers: { "Authorization": @user.email, "Tokenkey": token_key }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(json["message"]).to eq "Get user info successfully"
        expect(json["user"]["id"]).to eq @user.id
        expect(json["user"]["email"]).to eq @user.email
        expect(json["customer"]["id"]).to eq @customer.id
        expect(json["customer"]["email"]).to eq @customer.email
        expect(json["customer"]["fullname"]).to eq @customer.fullname
        expect(json["customer"]["address"]).to eq @customer.address
        expect(json["customer"]["phone_number"]).to eq @customer.phone_number
      end
    end
  end
end
