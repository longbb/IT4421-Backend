require "rails_helper"

RSpec.describe Product, type: :model do
  let(:supplier) { create(:supplier) }
  let(:product) { build(:product, supplier_id: supplier.id) }
  subject { product }

  describe "Test validation title" do
    context "When title is invalid" do
      it {
        ["", " ", nil].each do |invalid|
          subject.title = invalid
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
  describe "Test validation supplier_id" do
    context "When supplier_id is invalid" do
      it {
        [0, "abc", "", " ", nil].each do |invalid|
          subject.supplier_id = invalid
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
