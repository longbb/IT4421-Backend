json.success true
json.message @data[:message] if @data[:message]
json.product @data[:product] if @data[:product]
json.supplier @data[:supplier] if @data[:supplier]
json.total_inventory @data[:product].total_inventory
json.variants(@data[:variants]) do |variant|
  json.id variant.id
  if variant.properties.present?
    json.properties(eval(variant.properties)) do |property|
      json.name property["name"]
      json.value property["value"]
    end
  end
  json.product_id variant.product_id
  json.original_price variant.original_price
  json.selling_price variant.selling_price
  json.image_url variant.image_url
  json.inventory variant.inventory
  json.status variant.status
end
