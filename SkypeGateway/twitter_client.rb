#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# IRCで作ろうかと思ったけど、セッションの管理などが難しいので
# protectedのTwitterで作った方がよさそうだ、などと考えた。



require 'pit'

class SimpleTwitterClient
	def initialize
	end
end

<<<<<<< HEAD:SkypeGateway/twitter_client.rb
if __FILE__ == $0 then
	t = Twitter::Base.new('hc_skype', 'skype_hc')
	h = t.user(:hirameki)
	puts "(angel) http://twitter.com/hirameki/status/#{h.status.id}"
	puts h.status.text.gsub(/&#(\d*?);/) { [$1.to_i].pack('U') }.gsub('&amp;gt;', '>')
end



=======
>>>>>>> 311f5b4... add hirameki client:SkypeGateway/twitter_client.rb
