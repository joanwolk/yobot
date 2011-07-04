# encoding: utf-8
require 'spec_helper'

describe Yobot::Behaviors::Weather do
  it "hits the Google weather API" do
    EventMachine::HttpRequest.should_receive(:new).with(
      'http://www.google.com/ig/api'
    ) { stub.as_null_object }

    Yobot::Behaviors::Weather.new.react(stub, 'weather berlin')
  end

  it "extracts the city name from the message" do
    request = stub(:request)

    EventMachine::HttpRequest.stub(:new) { request }

    request.should_receive(:get).with(query: { weather: 'berlin' }) {
      stub.as_null_object
    }

    Yobot::Behaviors::Weather.new.react(stub, 'weather berlin')
  end

  it "strips the city name of superfluous whitespace" do
    request = stub(:request)

    EventMachine::HttpRequest.stub(:new) { request }

    request.should_receive(:get).with(query: { weather: 'berlin' }) {
      stub.as_null_object
    }

    Yobot::Behaviors::Weather.new.react(stub, 'weather  berlin  ')
  end

  it "ignores messages that don't start with weather" do
    EventMachine::HttpRequest.should_not_receive(:new)

    Yobot::Behaviors::Weather.new.react(stub, 'test')
  end

  it "prints an error when no city is given" do
    room = stub

    EventMachine::HttpRequest.should_not_receive(:new)

    room.should_receive(:paste).with("please name a city")

    Yobot::Behaviors::Weather.new.react(room, 'weather')
  end

  it "prints the weather to the room" do
    room = stub
    request = stub(:request)
    http = stub(:http)
    EventMachine::HttpRequest.stub(:new) { request }
    request.stub(:get) { http }
    http.stub(:callback).and_yield
    http.stub(:response) { weather_xml }

    room.should_receive(:paste).with("Weather in Berlin, Berlin: 19°C, Clear, Humidity: 60%, Wind: NE at 2 mph")

    Yobot::Behaviors::Weather.new.react(room, 'weather berlin')
  end

  it "reports an error when the weather could not be fetched" do
    room = stub
    request = stub(:request)
    http = stub(:http)
    EventMachine::HttpRequest.stub(:new) { request }
    request.stub(:get) { http }
    http.stub(:callback).and_yield
    http.stub(:response) { weather_error_xml }

    room.should_receive(:paste).with("couldn't fetch the weather information")

    Yobot::Behaviors::Weather.new.react(room, 'weather foobar')
  end

  def weather_xml
    <<-XML
    <?xml version="1.0"?>
    <xml_api_reply version="1">
      <weather module_id="0" tab_id="0" mobile_row="0" mobile_zipped="1" row="0" section="0" >
        <forecast_information>
          <city data="Berlin, Berlin"/>
          <postal_code data="Berlin"/>
          <latitude_e6 data=""/>
          <longitude_e6 data=""/>
          <forecast_date data="2011-06-29"/>
          <current_date_time data="2011-06-28 22:50:00 +0000"/>
          <unit_system data="US"/>
        </forecast_information>
        <current_conditions>
          <condition data="Clear"/>
          <temp_f data="66"/>
          <temp_c data="19"/>
          <humidity data="Humidity: 60%"/>
          <icon data="/ig/images/weather/sunny.gif"/>
          <wind_condition data="Wind: NE at 2 mph"/>
        </current_conditions>
        <forecast_conditions>
          <day_of_week data="Wed"/>
          <low data="61"/>
          <high data="86"/>
          <icon data="/ig/images/weather/sunny.gif"/>
          <condition data="Clear"/>
        </forecast_conditions>
        <forecast_conditions>
          <day_of_week data="Thu"/>
          <low data="52"/>
          <high data="66"/>
          <icon data="/ig/images/weather/mostly_sunny.gif"/>
          <condition data="Partly Sunny"/>
        </forecast_conditions>
        <forecast_conditions>
          <day_of_week data="Fri"/>
          <low data="54"/>
          <high data="70"/>
          <icon data="/ig/images/weather/mostly_sunny.gif"/>
          <condition data="Mostly Sunny"/>
        </forecast_conditions>
        <forecast_conditions>
          <day_of_week data="Sat"/>
          <low data="55"/>
          <high data="70"/>
          <icon data="/ig/images/weather/mostly_sunny.gif"/>
          <condition data="Mostly Sunny"/>
        </forecast_conditions>
      </weather>
    </xml_api_reply>
    XML
  end

  def weather_error_xml
    <<-XML
    <xml_api_reply version="1">
      <weather module_id="0" tab_id="0" mobile_row="0" mobile_zipped="1" row="0" section="0">
        <problem_cause data=""/>
      </weather>
    </xml_api_reply>
    XML
  end
end
