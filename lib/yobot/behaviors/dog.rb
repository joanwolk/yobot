require 'nokogiri'

class Yobot::Behaviors::Dog
	def react(room, message)
    if message =~ /^dog/
      request = EventMachine::HttpRequest.new('http://api.cheezburger.com/xml/category/dogs/lol/random')
      http = request.get
      http.callback do
        room.paste(extract_image_url(http.response)) {}
			end
		end
	end

	def description
		"returns a random image from dogs.icanhascheezburger.com"
	end

	private

		def extract_image_url(xml)
    doc = Nokogiri::XML(xml)

    unless doc.css('problem_cause').empty?
      return "couldn't fetch the dog"
    end
    
    url = doc.css('LolImageUrl').first['data']

    return "#{url}"
		end
end
