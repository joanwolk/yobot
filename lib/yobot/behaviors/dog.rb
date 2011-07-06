require 'nokogiri'

class Yobot::Behaviors::Dog
	def react(room, message)
    if message =~ /^dog/
      request = EventMachine::HttpRequest.new('http://api.cheezburger.com/xml/category/dogs/lol/random')
			# This version of the Cheezburger API is deprecated as of July 2011 and may break when a new API is released
      http = request.get
      http.callback do
        room.text(extract_image_url(http.response)) {}
			end
		end
	end

	def description
		"returns a random image from dogs.icanhascheezburger.com"
	end

	private

		def extract_image_url(xml)
      doc = Nokogiri::XML(xml)
      url= doc.css('Lol/LolImageUrl').text
		end
end
