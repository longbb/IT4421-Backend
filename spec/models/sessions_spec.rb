require "rails_helper"

RSpec.describe Session, :type => :model do
  let(:user) { create(:user) }
  let(:session) { build(:session) }
  subject { session }

  describe "Test validation user_id" do
    context "When user_id is invalid" do
      it {
        [0, "", " ", nil].each do |invalid|
          subject.user_id = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation token_key" do
    context "When token_key is invalid" do
      it {
        [0, "", " ", nil].each do |invalid|
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
          subject.token_key = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "All validations are valid" do
    it {
      subject.user_id = user.id
      is_expected.to be_valid
    }
  end
end
