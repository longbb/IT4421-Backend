json.success true
json.message @data[:message] if @data[:message]
json.order @data[:order] if @data[:order]
json.order_variants(@data[:order_variants]) do |item|
  json.order_variant do
    json.quantity item[:order_variant].quantity
    json.status item[:order_variant].status
  end
  json.variant do
    if item[:variant].properties.present?
      json.properties(eval(item[:variant].properties)) do |property|
        json.name property["name"]
        json.value property["value"]
      end
    end
    json.id item[:variant].id
    json.product_id item[:variant].product_id
    json.selling_price item[:variant].selling_price
    json.image_url item[:variant].image_url
    json.inventory item[:variant].inventory
    json.status item[:variant].status
  end
end
