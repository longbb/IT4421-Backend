require "rails_helper"

RSpec.describe Feedback, type: :model do
  let(:feedback) { build(:feedback) }
  subject { feedback }

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
  describe "Test validation content of feedback" do
    context "When feedback is invalid" do
      it {
        ["", " ", nil].each do |invalid|
          subject.feedback = invalid
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
      is_expected.to be_valid
    }
  end
end
