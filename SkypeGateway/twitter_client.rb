#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# IRC で作ろうかと思ったけど、セッションの管理などが難しいので
# protected の Twitter で作った方がよさそうだ、などと考えた。

require 'rubygems'
require 'pit'
require 'twitter'
require 'date'

class SimpleTwitterClient
	def initialize(config)
		@config = config
		unless config.has_key?('last_created_at') then
			@last_created_at = Time.now
		else
			@last_created_at = config['last_created_at']
		end
		
		id = config['twitter_id']
		password = config['twitter_password']
		@twitter = Twitter::Base.new(id, password)
	end

	def send_message(input)
	end

	def receive_message(&block)
		raise unless block_given?
		@block = block
	end

	def start
		@timeline_thread = Thread.start do
			loop do
				update_status
				Pit.set("TwitterToSkype",
						  :data => @config)
				sleep(1 * 60 * 3)
			end
		end
	end
	
	def update_status
		created_at = @config['last_created_at']
		@twitter.timeline.reverse.each do |status|
			created_at = Time.parse(status.created_at).localtime
			next unless @config['last_created_at'] < created_at
			@config['last_created_at'] = created_at
			
			user = status.user.screen_name
			id = status.id
			text = status.text.gsub(/&#(\d*?);/) { [$1.to_i].pack('U') }.gsub('&amp;gt;', '>')
			url = "http://twitter.com/#{user}/status/#{id}"

			@block.call(user, url, text)
		end
	end
	
	def stop
		@timeline_thread.kill
		@timeline_thread.join
	end
end

def twitter_client_sample
	config = Pit.get("TwitterToSkype" + (ARGV[0] ? "-#{ARGV[0]}" : ""),
						  :require => {
							  'skype_chat' => 'your skype channel id',
							  'skype_name' => 'your skype name',
							  'twitter_id'   => 'bot twitter id',
							  'twitter_password'   => 'bot twitter password',
						  })
	stc = SimpleTwitterClient.new(config)
	
	stc.receive_message do |user, url, message|
		puts '----'
		out = "(talk) @#{user} - #{url} \n #{message}"
		puts out
	end
	
	stc.start

	Signal.trap('INT') do
		stc.stop
		exit
	end

	
	loop do
		Thread.pass
		sleep 0.5
	end

end


def twitter_sample
	t = Twitter::Base.new('hc_skype', 'skype_hc')
	t.timeline.each do |status|
		user = status.user.screen_name
		id = status.id
		text = status.text.gsub(/&#(\d*?);/) { [$1.to_i].pack('U') }
		out = "(talk) @#{user} - http://twitter.com/#{user}/status/#{id} \n #{text}"
		puts '----'
		puts out
		puts DateTime.parse(status.created_at).to_s
	end
	#h = t.user(:hirameki)
	#puts "(talk) http://twitter.com/hirameki/status/#{h.status.id}"
	#puts h.status.text.gsub(/&#(\d*?);/) { [$1.to_i].pack('U') }.gsub('&amp;gt;', '>')
end

if __FILE__ == $0 then
	twitter_client_sample
end
