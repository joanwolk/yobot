require 'spec_helper'

describe Yobot::Behaviors::Dog do
  it "requests the image information" do
  	request = stub(:request)

		EventMachine::HttpRequest.should_receive(:new).with('http://api.cheezburger.com/xml/category/dogs/lol/random') {request}
		request.should_receive(:get) {stub.as_null_object}
		
		Yobot::Behaviors::Dog.new.react(stub, 'dog')
	end

  it "ignores messages that don't start with weather" do
    EventMachine::HttpRequest.should_not_receive(:new)

    Yobot::Behaviors::Dog.new.react(stub, 'cat')
	end

	it "prints the image to the room" do
    room = stub
    request = stub(:request)
    http = stub(:http)
    EventMachine::HttpRequest.stub(:new) { request }
    request.stub(:get) { http }
    http.stub(:callback).and_yield
    http.stub(:response) { dog_xml }

    room.should_receive(:paste).and_return("images.cheezburger.com/completestore/2010/1/12/th_129078083665888173.jpg")

    Yobot::Behaviors::Dog.new.react(room, 'dog')
	end

	def dog_xml
    <<-XML
		<Lol>
		<LolId>http://api.cheezburger.com/xml/lol/6445483</LolId>
		<LolImageUrl>
			http://images.cheezburger.com/completestore/2010/1/12/129078083665888173.jpg
		</LolImageUrl>
		<ThumbnailImageUrl>
			http://images.cheezburger.com/completestore/2010/1/12/th_129078083665888173.jpg
		</ThumbnailImageUrl>
		<LolPageUrl>http://cheezburger.com/View/3059823872</LolPageUrl>
		<FullText>THROW DA BALL,THROW DA BALL THROW IT NOW!!!!</FullText>
		<PictureId>http://api.cheezburger.com/xml/picture/2212749</PictureId>
		<PictureImageUrl>
			http://images.cheezburger.com/imagestore/2010/1/11/fcadb09d-d87b-4cb4-ae4a-d6e5f12893a2.jpg
		</PictureImageUrl>
		<UserId>http://api.cheezburger.com/xml/user/JayJayxoxo</UserId>
		<Title>THROW DA BALL,THROW DA BALL THROW IT NOW!!!!</Title>
		<SourcePictures/>
		<TimeStamp>2010-01-12T14:19:27.09</TimeStamp>
		</Lol>
		XML
	end
end
