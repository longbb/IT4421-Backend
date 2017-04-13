require "rails_helper"

RSpec.describe Supplier, type: :model do
  let(:supplier) { build(:supplier) }
  subject { supplier }

  describe "Test validation name" do
    context "When name is invalid" do
      it {
        ["a"*51, "", " ", nil].each do |invalid|
          subject.name = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation address" do
    context "When address is invalid" do
      it {
        ["", " ", nil].each do |invalid|
          subject.address = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation phone_number" do
    context "When phone_number is invalid" do
      it {
        ["123456", "abcgsssss", "", " ", nil].each do |invalid|
          subject.phone_number = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation description" do
    context "When description is invalid" do
      it {
        ["", " ", nil].each do |invalid|
          subject.description = invalid
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
        subject.status = valid
        is_expected.to be_valid
      end
    }
  end
end
