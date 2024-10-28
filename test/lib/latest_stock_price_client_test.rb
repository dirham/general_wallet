# test/lib/latest_stock_price_client_test.rb
require "test_helper"
require "webmock/minitest"
require "latest_stock_price/client"

class LatestStockPriceClientTest < ActiveSupport::TestCase
  def setup
    @client = LatestStockPrice::Client.new(api_key: "test_key", host: "latest-stock-price.p.rapidapi.com")
  end

  test "fetch_latest_stock_price returns the correct response" do
    response_body = [ { "symbol" => "AAPL", "price" => "150.00" } ].to_json
    stub_request(:get, "#{LatestStockPrice::Client::BASE_URL}/any")
      .to_return(status: 200, body: response_body)

    result = @client.fetch_latest_stock_price
    assert_equal "AAPL", result.first["symbol"]
    assert_equal "150.00", result.first["price"]
  end

  test "fetch_timeseries with correct parameters returns data" do
    response_body = [ { "timestamp" => "2023-01-01T00:00:00Z", "price" => "150.00" } ].to_json
    stub_request(:get, "#{LatestStockPrice::Client::BASE_URL}/timeseries")
      .with(query: { Symbol: "AAPL", Timescale: "-9", Period: "1DAY" })
      .to_return(status: 200, body: response_body)

    result = @client.fetch_timeseries(symbol: "AAPL", timescale: -9, period: "1DAY")
    assert_equal "2023-01-01T00:00:00Z", result.first["timestamp"]
    assert_equal "150.00", result.first["price"]
  end

  test "fetch_equities with valid indicies returns correct data" do
    response_body = [ { "symbol" => "NIFTY", "price" => "16000.00" } ].to_json
    stub_request(:get, "#{LatestStockPrice::Client::BASE_URL}/equities")
      .with(query: { Indicies: "NIFTY" })
      .to_return(status: 200, body: response_body)

    result = @client.fetch_equities(indicies: "NIFTY")
    assert_equal "NIFTY", result.first["symbol"]
    assert_equal "16000.00", result.first["price"]
  end

  test "fetch_equities raises error with invalid indicies" do
    assert_raises(ArgumentError) do
      @client.fetch_equities(indicies: "INVALID_INDEX")
    end
  end

  test "fetch_latest_stock_price handles request failure" do
    stub_request(:get, "#{LatestStockPrice::Client::BASE_URL}/any")
      .to_return(status: 500)

    assert_raises(RuntimeError) do
      @client.fetch_latest_stock_price
    end
  end
end
