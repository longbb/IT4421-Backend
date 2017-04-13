require "rails_helper"
require "spec_helper"

RSpec.describe "Feedback API", type: :request do
  describe "Create Feedback" do
    context "When all informations are valid" do
      it "should success" do
        post "/api/v1/feedback", params: { email: "test@mail.com", feedback: "feedback", format: :json }
        json = JSON.parse(response.body)
        expect(response).to be_success
        expect(json["message"]).to eq("Create feedback successfully")
        expect(json["feedback"]["id"]).not_to be_nil
      end
    end
    context "When email is invalid" do
      it "should fail" do
        post "/api/v1/feedback", params: { email: "email", feedback: "feedback", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(json["message"]).to eq(["Email is invalid"])
      end
    end
    context "When email is empty" do
      it "should fail" do
        post "/api/v1/feedback", params: { email: "", feedback: "feedback", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(json["message"]).to eq(["Email can't be blank","Email is invalid"])
      end
    end
    context "When email is blank" do
      it "should fail" do
        post "/api/v1/feedback", params: { email: " ", feedback: "feedback", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(json["message"]).to eq(["Email can't be blank","Email is invalid"])
      end
    end
    context "When email is blank" do
      it "should fail" do
        post "/api/v1/feedback", params: { email: nil, feedback: "feedback", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(json["message"]).to eq(["Email can't be blank","Email is invalid"])
      end
    end
    context "When feedback content is blank" do
      it "should fail" do
        post "/api/v1/feedback", params: { email: "test@mail.com", feedback: " ", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(json["message"]).to eq(["Feedback can't be blank"])
      end
    end
    context "When feedback content is empty" do
      it "should fail" do
        post "/api/v1/feedback", params: { email: "test@mail.com", feedback: "", format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(json["message"]).to eq(["Feedback can't be blank"])
      end
    end
    context "When feedback content is nil" do
      it "should fail" do
        post "/api/v1/feedback", params: { email: "test@mail.com", feedback: nil, format: :json }
        json = JSON.parse(response.body)
        expect(response).to have_http_status(400)
        expect(json["message"]).to eq(["Feedback can't be blank"])
      end
    end
  end
end
