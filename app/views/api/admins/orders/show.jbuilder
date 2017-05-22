json.success true
json.message @data[:message] if @data[:message]
if @data[:order]
  json.order @data[:order]
  json.order_variants(@data[:order].order_variants) do |order_variant|
    json.quantity order_variant[:quantity]
    json.variant_id order_variant.variant.id
    if order_variant.variant.try(:properties).present?
      json.properties(eval(order_variant.variant.properties)) do |property|
        json.name property["name"]
        json.value property["value"]
      end
    end
    json.product order_variant.variant.product
    json.selling_price order_variant.variant.selling_price
    json.image_url order_variant.variant.image_url
    json.inventory order_variant.variant.inventory
    json.status order_variant.variant.status
  end
  json.customer @data[:order].customer
end
