json.success true
json.message @data[:message] if @data[:message]
json.total_customers @data[:total_customers] if @data[:total_customers]
json.customers @data[:customers] if @data[:customers]
