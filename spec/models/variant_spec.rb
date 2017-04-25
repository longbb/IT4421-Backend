require "rails_helper"

RSpec.describe Variant, type: :model do
  let(:supplier) { create(:supplier) }
  let(:product) { create(:product, supplier_id: supplier.id, options: "color") }
  let(:variant) { build(:variant, product_id: product.id) }
  subject { variant }

  describe "Test validation original_price" do
    context "When original_price is invalid" do
      it {
        ["", " ", nil, "abc", -1].each do |invalid|
          subject.original_price = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation selling_price" do
    context "When selling_price is invalid" do
      it {
        ["abcgsssss", "", " ", nil, -1].each do |invalid|
          subject.selling_price = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation inventory" do
    context "When inventory is invalid" do
      it {
        ["abcgsssss", "", " ", nil, -1].each do |invalid|
          subject.inventory = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end
  describe "Test validation image_url" do
    context "When image_url is invalid" do
      it {
        ["", " ", nil].each do |invalid|
          subject.image_url = invalid
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
