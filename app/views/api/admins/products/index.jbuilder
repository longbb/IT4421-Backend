json.success true
json.message @data[:message] if @data[:message]
json.total_products @data[:total_products] if @data[:total_products]
json.products @data[:products] if @data[:products]
