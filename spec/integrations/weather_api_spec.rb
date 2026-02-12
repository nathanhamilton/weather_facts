require 'rails_helper'

RSpec.describe WeatherApi do

  describe '#initialize' do
    it 'creates an instance with an available options hash' do
      location_hash = {"lat" => "30.2766200", "lon" => "-97.7397670"}
      result = WeatherApi.new(location_hash)

      expect(result.methods.include?(:location_data)).to be true
      expect(result.send(:location_data)["lat"]).to match location_hash["lat"]
      expect(result.send(:location_data)["lon"]).to match location_hash["lon"]
    end

    
  end

  describe '#get_forcast' do
    context 'when the data provided is correct' do
      it 'returns the forcast data' do
        location_hash = {"lat" => "30.2766200", "lon" => "-97.7397670"}
        api_instance = WeatherApi.new(location_hash)

        result = api_instance.get_forecast
        
        expect(result.keys).to eq %w[location current forecast]
      end
    end

    context 'when the data provided is not correct' do
      it 'throws an error' do
        location_hash = {"lat" => "", "lon" => "-97.7397670"}
        api_instance = WeatherApi.new(location_hash)

        expect {
          api_instance.get_forecast
        }.to raise_error(WeatherApi::ApiError)
      end
    end
  end

  describe '#get_current' do
  end

  context 'private methods' do

    describe '#get_url_params' do
      before(:each) do
        # Temporarily modifying the value so that it's not shown in the test
        @temp_api_key_value = ENV['WEATHER_API_COM_API_KEY']
        ENV['WEATHER_API_COM_API_KEY'] = '123456789'
      end

      after(:each) do
        ENV['WEATHER_API_COM_API_KEY'] = @temp_api_key_value
      end

      it 'returns the specific url required for submitting a request to weather api' do
        location_hash = {"lat" => "30.2766200", "lon" => "-97.7397670"}
        api_instance = WeatherApi.new(location_hash)
        url_params = api_instance.send('get_url_params', 'forecast')

        expect(url_params).to eq '/forecast.json?key=123456789&q=30.2766200,-97.7397670'
      end
    end

    describe '#convert_location_hash' do
      it 'correctly parses the geolocation data as the API wants to receive it' do
        location_hash = {"lat" => "30.2766200", "lon" => "-97.7397670"}
        api_instance = WeatherApi.new(location_hash)

        expect(api_instance.send('convert_location_hash')).to eq '30.2766200,-97.7397670'
      end
    end
  end
end
