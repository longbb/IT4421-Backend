json.success true
json.message @data[:message] if @data[:message]
json.total_products @data[:total_products] if @data[:total_products]
json.products(@data[:products]) do |product|
  json.product do
    json.id product.id
    json.title product.title
    json.description product.description
    json.images product.images
    json.options product.options
    json.status product.status
    json.min_price product.min_price
    json.max_price product.max_price
    json.total_inventory product.total_inventory
  end
  json.supplier product.supplier
end

