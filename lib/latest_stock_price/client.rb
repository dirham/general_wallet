require "faraday"

module LatestStockPrice
  class Client
    BASE_URL = "https://latest-stock-price.p.rapidapi.com".freeze

    VALID_INDICIES = %w[
      BANKNIFTY CNX100 CNX200 CNX500 CNXALPHA CNXAUTO CNXCOMMO CNXCONSM CNXDEFTY
      CNXDIVOPT CNXENER CNXFIN CNXFMCG CNXHIGH CNXINFRA CNXIT CNXLOW CNXLOWV30
      CNXMCAP CNXMEDIA CNXMETAL CNXMNC CNXNFTYJUN CNXPHAR CNXPSE CNXPSU CNXREALTY
      CNXSCAP CNXSERV CPSE INDIAVIX LIX15 LIX15MCAP LRGMID250 NI15 NIFADIBIR
      NIFESG NIFFINEX NIFFINSE NIFIND NIFMAHI NIFMIC NIFMIDS NIFMIDSE NIFMOM
      NIFMUL NIFREIN NIFSMQUA NIFTALPF NIFTATGRO NIFTATGRO25PC NIFTCOHOUS
      NIFTDEFE NIFTHOUS NIFTMANU NIFTMFIN NIFTMHEA NIFTMIT NIFTMOBI NIFTMOME
      NIFTNON NIFTPR1X NIFTPR2X NIFTRA NIFTTOTA NIFTTR1X NIFTTR2X NIFTY
      NIFTY100EQW NIFTY100ESG NIFTY200QUA NIFTY500VAL NIFTYALP NIFTYALPHQUAL
      NIFTYALPHVOLT30 NIFTYCON NIFTYDIV NIFTYEQUWEI NIFTYM150 NIFTYM50
      NIFTYMIDQUA NIFTYMSC400 NIFTYOIL NIFTYPVTBANK NIFTYQUALVOLT30 NIFTYSCAP250
      NIFTYSCAP50 NIFTYSME NIFTYVALUEVOLT30 NSEHCARE NSEQ30 NV20
    ].freeze

    def initialize(api_key: ENV["RAPID_API_KEY"], host: ENV["RAPID_API_HOST"])
      @connection = Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers["Content-Type"] = "application/json"
        faraday.headers["x-rapidapi-key"] = api_key
        faraday.headers["x-rapidapi-host"] = host
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
      end
    end

    def fetch_latest_stock_price(identifier: nil)
      query_params = {}
      query_params[:Identifier] = identifier if identifier.present?
      request("/any")
    end

    def fetch_timeseries(symbol:, timescale: -9, period: "1DAY")
      query_params = { Symbol: symbol, Timescale: timescale, Period: period }
      request("/timeseries", query_params)
    end

    def fetch_equities(isin: nil, only_index: nil, indicies: nil)
      query_params = {}
      query_params[:ISIN] = isin if isin
      query_params[:OnlyIndex] = only_index unless only_index.nil?

      if indicies
        valid_indicies = indicies.split(",").select { |index| VALID_INDICIES.include?(index) }
        raise ArgumentError, "Invalid Indicies value(s) provided" if valid_indicies.empty?

        query_params[:Indicies] = valid_indicies.join(",")
      end

      request("/equities", query_params)
    end

    private

    def request(endpoint, params = {})
      response = @connection.get(endpoint) do |req|
        req.params = params unless params.empty?
      end
      handle_response(response)
    end

    def handle_response(response)
      if response.success?
        JSON.parse(response.body)
      else
        raise "Request failed with status: #{response.status}"
      end
    end
  end
end
