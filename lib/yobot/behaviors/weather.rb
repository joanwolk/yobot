# encoding: utf-8
require 'nokogiri'

class Yobot::Behaviors::Weather
  def react(room, message)
    if message =~ /^weather/
      city = message.sub(/^weather/, '').strip

      if city.empty?
        room.paste('please name a city')
        return
      end

      request = EventMachine::HttpRequest.new('http://www.google.com/ig/api')

      http = request.get(query: { weather: city })
      http.callback do
        room.paste(extract_weather(http.response)) {}
      end
    end
  end

  private

  def extract_weather(xml)
    doc = Nokogiri::XML(xml)

    unless doc.css('problem_cause').empty?
      return "couldn't fetch the weather information"
    end

    city = doc.css('weather forecast_information city').first['data']
    temp_c = doc.css('weather current_conditions temp_c').first['data']
    condition = doc.css('weather current_conditions condition').first['data']
    humidity = doc.css('weather current_conditions humidity').first['data']
    wind = doc.css('weather current_conditions wind_condition').first['data']

    "Weather in #{city}: #{temp_c}°C, #{condition}, #{humidity}, #{wind}"
  end
end
