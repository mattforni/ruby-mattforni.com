require 'epsilon'
require 'ranges'
require 'stocks'

include Ranges
include Stocks

class Stop < ActiveRecord::Base
  validates :highest_price, presence: true, numericality: PRICE_RANGE
  validates :highest_time, presence: true
  validates :lowest_price, presence: true, numericality: PRICE_RANGE
  validates :lowest_time, presence: true
  validates :percentage, presence: true, numericality: PERCENTAGE_RANGE
  validates :position_id, presence: true
  validates :stop_price, presence: true, numericality: PRICE_RANGE
  validates :symbol, presence: true
  validates :user_id, presence: true

  belongs_to :position
  belongs_to :user

  delegate :stock, to: :position, allow_nil: false
  delegate :last_trade, to: :stock, allow_nil: false

  def self.by_user_and_symbol(user, symbol)
    Stop.where({user_id: user.id, symbol: symbol})
  end

  def create!
    position = Position.by_user_and_symbol(self.user, self.symbol)
    if position.nil?
      self.errors.add(:position_id, 'could not be found')
      raise ActiveRecord::RecordInvalid.new(self)
    end
    self.position = position

    if self.percentage.nil?
      self.errors.add(:percentage, 'cannot be nil')
      raise ActiveRecord::RecordInvalid.new(self)
    end

    self.update?
    self.save!
  end

  def price_diff
    self.last_trade - self.stop_price
  end

  def stopped_out?
    self.last_trade <= self.stop_price
  end

  def update?
    update = false
    stop_price = calc_stop_price

    # If stop_price has not been set or has gone up, update it
    if self.stop_price.nil? or self.stop_price < stop_price
      self.stop_price = stop_price
      update = true
    end

    # If delegated last_trade is less than the current lowest_price, update it
    if self.lowest_price.nil? or self.last_trade < self.lowest_price
      self.lowest_price = self.last_trade
      self.lowest_time = Time.now.utc
      update = true
    end

    # If delegated last_trade is greater than the current highest_price, update it
    if self.highest_price.nil? or self.last_trade > self.highest_price
      self.highest_price = self.last_trade
      self.highest_time = Time.now.utc
      update = true
    end

    update
  end

  def update_stop_price?(params = nil)
    highest_price = self.stop_price / rate(true)
    previous_stop_price = self.stop_price

    # Price has a higher priority
    stop_price = (params[:stop_price].empty? ? nil : params[:stop_price].to_f) rescue self.stop_price
    if !stop_price.nil? and !Epsilon.equal? previous_stop_price, stop_price
      self.stop_price = stop_price
      self.percentage = ((1.0 - (self.stop_price / highest_price)) * 100).round(3)
      return true
    end

    # Otherwise check if percentage was updated
    percentage = (params[:percentage].empty? ? nil : params[:percentage].to_f) rescue self.percentage
    if !percentage.nil? and !Epsilon.equal? self.percentage, percentage
      self.percentage = percentage
      self.stop_price = (rate(true) * highest_price).round(3)
      return true
    end

    false
  end

  private

  def calc_stop_price
    self.stock.update! if self.last_trade.nil?
    self.last_trade * rate(true)
  end

  def rate(inverse = false)
    rate = self.percentage / 100.0
    return inverse ? 1 - rate : rate
  end
end

