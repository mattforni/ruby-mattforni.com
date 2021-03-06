desc 'Tasks to be called by the heroku scheduler'

def handle_weekend
  now = Time.now
  abort 'Today is a weekend, no need to evaluate' if now.saturday? or now.sunday?
end

task :update_alerts => :environment do
  handle_weekend

  User.all.each do |user|
    alerts = user.alerts
    if !alerts.empty?
      puts "Evaluating alert(s) for #{user.email}"
      User.transaction do
        triggered = []
        alerts.each do |alert|
          puts "Evaluating #{alert}"
          if alert.trigger?
            triggered << alert
            alert.save!
          end
        end

        # TODO send email
      end
    end
  end
end

task :update_stocks => :environment do
  handle_weekend

  stocks = Stock.all
  updated = 0

  puts "Evaluating #{stocks.size} stock(s)"
  stocks.each do |stock|
    previous = stock.last_trade
    if stock.update!
      puts "#{stock.symbol}\t#{(previous > stock.last_trade) ? 'v' : '^'}\t#{previous} -> #{stock.last_trade}"
      updated += 1
    end
  end
  puts "Updated #{updated} stock(s)"
end

task :update_stops => :environment do
  handle_weekend

  stops = Stop.all
  stopped_out = {}

  puts "Evaluating #{stops.size} stop(s)"
  stops.each do |stop|
    stop.save! if stop.update?
    if stop.stopped_out?
      stopped_out[stop.user_id] = [] if stopped_out[stop.user_id].nil?
      stopped_out[stop.user_id] << stop
    end
  end

  num_stopped_out = 0
  stopped_out.each do |user_id, stops|
    num_stopped_out += stops.size
    user = User.find(user_id) rescue nil
    return if user.nil?
    puts "#{stops.size} position(s) stopped out for user '#{user.email}'"
    StopMailer.stopped_out(user.email, stops).deliver_now
  end

  puts "#{num_stopped_out} position(s) stopped out in total"
end

