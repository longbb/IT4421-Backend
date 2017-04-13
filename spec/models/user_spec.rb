require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }
  subject { user }

  describe "Test validation email" do
    context "When email is invalid" do
      it {
        ["asdfghjk", "", " ", nil].each do |invalid|
          subject.email = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation password" do
    context "When password is invalid" do
      it {
        ["short", "", " ", nil].each do |invalid|
          subject.password = invalid
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
      ["Active", "Blocked"].each do |valid|
        subject.status = valid
        is_expected.to be_valid
      end
    }
  end
end
