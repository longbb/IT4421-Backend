require "rails_helper"

RSpec.describe AdminSession, type: :model do
  let(:admin) { create(:admin) }
  let(:admin_session) { build(:admin_session) }
  subject { admin_session }

  describe "Test validation admin" do
    context "When admin is invalid/not exist" do
      it {
        [0, "", " ", nil].each do |invalid|
          subject.admin_id = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation token_key" do
    context "When token_key is invalid" do
      it {
        ["", " ", nil].each do |invalid|
          subject.token_key = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation status" do
    context "When status is invalid" do
      it {
        ["abc", "", " ", nil].each do |invalid|
          subject.status = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "All validations are valid" do
    it {
      ["active", "deleted"].each do |valid|
        subject.admin_id = admin.id
        subject.status = valid
        is_expected.to be_valid
      end
    }
  end
end
