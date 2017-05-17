require "rails_helper"

RSpec.describe OrderVariant, type: :model do
  let(:customer) { create(:customer) }
  let(:order) { create(:order, customer_id: customer.id) }
  let(:supplier) { create(:supplier) }
  let(:product) { create(:product, supplier_id: supplier.id) }
  let(:variant) { create(:variant, product_id: product.id) }
  let(:order_variant) { create(:order_variant, order_id: order.id, variant_id: variant.id) }
  subject { order_variant }

  describe "Test validation order_id" do
    context "When order_id is invalid" do
      it {
        [0, "", " ", nil].each do |invalid|
          subject.order_id = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end

  describe "Test validation variant_id" do
    context "When variant_id is invalid" do
      it {
        [0, "", " ", nil].each do |invalid|
          subject.variant_id = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end

  describe "Test validation quantity" do
    context "When quantity is invalid" do
      it {
        [0, "", " ", nil].each do |invalid|
          subject.quantity = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end

  describe "Test validation unit_price" do
    context "When unit_price is invalid" do
      it {
        [-10, "", " ", nil].each do |invalid|
          subject.unit_price = invalid
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
      ["active", "canceled", "done", "error"].each do |valid|
        subject.status = valid
        is_expected.to be_valid
      end
    }
  end
end
