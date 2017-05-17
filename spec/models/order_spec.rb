require "rails_helper"

RSpec.describe Order, type: :model do
  let(:customer) { create(:customer) }
  let(:order) { build(:order, customer_id: customer.id) }
  subject { order }

  describe "Test validation customer_id" do
    context "When customer_id is invalid" do
      it {
        [0, "", " ", nil].each do |invalid|
          subject.customer_id = invalid
          is_expected.not_to be_valid
        end
      }
    end
  end

  describe "Test validation total_price" do
    context "When total_price is invalid" do
      it {
        [-10, "", " ", nil].each do |invalid|
          subject.total_price = invalid
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
