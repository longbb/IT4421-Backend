json.success true
json.message @data[:message] if @data[:message]
json.total_orders @data[:total_orders] if @data[:total_orders]
json.orders (@data[:orders]) do |item|
  json.id item[:order].id
  json.total_price item[:order].total_price
  json.status item[:order].status
  json.variants(item[:variants]) do |order_variant|
    json.quantity order_variant[:quantity]
    json.variant_id order_variant[:variant].id
    if order_variant[:variant].properties.present?
      json.properties(eval(order_variant[:variant].properties)) do |property|
        json.name property["name"]
        json.value property["value"]
      end
    end
    json.product_id order_variant[:variant].product_id
    json.selling_price order_variant[:variant].selling_price
    json.image_url order_variant[:variant].image_url
    json.inventory order_variant[:variant].inventory
    json.status order_variant[:variant].status
  end
end
