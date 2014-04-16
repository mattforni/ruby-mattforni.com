require 'yahoofinance'

# TODO test this module
# TODO add a caching layer with 1-min TTL
module Stocks
  COMMISSION_RANGE = {greater_than_or_equal_to: 0}
	NA = 'N/A'
  PRICE_RANGE = {greater_than: 0}
  PRICE_SCALE = 5
  PERCENTAGE_RANGE =  {greater_than: 0, less_than: 100}
  QUANTITY_RANGE = {greater_than: 0}

	def self.exists?(symbol)
		quote(symbol, [:date])[:date] != NA
	end

  def self.last_trade(symbol)
    last_trade = quote(symbol)[:lastTrade]
    raise RetrievalError.new("Could not retrieve last trade for '#{symbol}'") if last_trade == 0 or last_trade == NA
    last_trade
  end

  class RetrievalError < RuntimeError
    def new(message)
      super(message)
    end
  end

  private

  def self.quote(symbol, fields = [:lastTrade])
    data = {}
    # TODO use the fields map to decide which method to use
    standard_quote = YahooFinance::get_standard_quotes(symbol)[symbol]
    fields.each do |field|
      data[field] = standard_quote.send(field) rescue NA
    end
    data
  end
end

