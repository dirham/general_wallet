### Example usage
```ruby
require 'latest_stock_price'

class StocksController < ApplicationController
  def show_latest
    client = LatestStockPrice::Client.new
    @latest_price = client.fetch_latest_stock_price
  rescue => e
    @error = e.message
  end
end
```
