require 'stocks'

class FinanceController < ApplicationController
  def last_trade
    respond_to do |format|
      format.json { render json: Stocks.last_trade(params[:symbol]) }
    end
  end

  def sizing
  end

  # TODO test update_stocks
  def update_stocks
    respond_to do |format|
      # Only accept json requests
      format.json do
        # Render a 401 and return if an invalid token is provided
        render json: {}, status: 401 and return if params[:token].nil? or params[:token] != 'f0rnac0pia'
        # Else attempt to update last trade if necessary
        updated = []
        stocks = Stock.all
        stocks.each do |stock|
          if stock.update?
            stock.save!
            updated << stock
          end
        end
        render json: {
          evaluated: stocks.size,
          updated: {number: updated.size, records: updated}
        }
      end
    end
  end
end

