require 'kawari'

logger = Kawari::Logger.new(__FILE__)

logger.info('Starting up...')

logger.info('Initializing queue...')

while true
	Kawari::Adapter::RabbitMQ.conn
  Kawari::Adapter::RabbitMQ.channel
  Kawari::Adapter::RabbitMQ.exchange
  Kawari::Adapter::RabbitMQ.queue

  Kawari::Adapter::RabbitMQ.queue.subscribe do |delivery_info, properties, payload|
		parsed = JSON.parse(payload)
		logger.info('Downloading :: ' + parsed['title'])
    file = Kawari::Download.get(parsed['link'])
		File.write(ENV['WATCH_PATH'] + '/' + parsed['title'].gsub(/[^0-9A-Za-z\s]/, '') + '.torrent', file)
		logger.info('Downloaded :: ' + parsed['title'])
	end

	#logger.error('Something happened, retrying in 300s...')

	#RabbitMQ.clear_conn

	sleep 10
	#sleep 300
end
