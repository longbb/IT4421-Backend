json.success true
json.message @data[:message] if @data[:message]
json.total_products @data[:total_suppliers] if @data[:total_suppliers]
json.suppliers @data[:suppliers] if @data[:suppliers]
