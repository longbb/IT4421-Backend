json.success true
json.message @data[:message] if @data[:message]
json.total_items @data[:total_items] if @data[:total_items]
json.total_revenues @data[:total_revenues] if @data[:total_revenues]
json.total_customer @data[:total_customer] if @data[:total_customer]
json.order_need_complete @data[:order_need_complete] if @data[:order_need_complete]
json.revenues_statistic @data[:revenues_statistic] if @data[:revenues_statistic]
json.top_3_products @data[:top_3_products] if @data[:top_3_products]
