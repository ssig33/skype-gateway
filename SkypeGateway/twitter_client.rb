#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# IRC で作ろうかと思ったけど、セッションの管理などが難しいので
# protected の Twitter で作った方がよさそうだ、などと考えた。

require 'rubygems'
require 'pit'
require 'twitter'

class SimpleTwitterClient
	def initialize
	end
end

if __FILE__ == $0 then
	t = Twitter::Base.new('hc_skype', 'skype_hc')
	t.timeline.each do |status|
		user = status.user.screen_name
		id = status.id
		text = status.text.gsub(/&#(\d*?);/) { [$1.to_i].pack('U') }
		out = "(talk) @#{user} - http://twitter.com/#{user}/status/#{id} \n #{text}"
		puts '----'
		puts out
	end
	#h = t.user(:hirameki)
	#puts "(talk) http://twitter.com/hirameki/status/#{h.status.id}"
	#puts h.status.text.gsub(/&#(\d*?);/) { [$1.to_i].pack('U') }.gsub('&amp;gt;', '>')
end
