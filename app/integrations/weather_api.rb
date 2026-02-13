class WeatherApi
  class ApiError < StandardError; end
  class NoDataFound < StandardError; end

  include HTTParty
  include IntegrationHelper

  base_uri 'https://api.weatherapi.com/v1'

  attr_reader :location_data
  
  def initialize(location_data)
    @location_data = location_data
    self.class.headers 'key' => ENV['WEATHER_API_COM_API_KEY']
  end

  def get_forecast
    result = self.class.get(get_url_params('forecast'))

    raise WeatherApi::ApiError unless success?(result)
    raise WeatherApi::NoDataFound if success_but_no_data?(result)

    JSON.parse(result.body)
  end

  def get_current
    result = self.class.get(get_url_params('current'))
    
    raise WeatherApi::ApiError unless success?(result)
    raise WeatherApi::NodataFound if success_but_no_data?(result)

    JSON.parse(result.body)
  end

  private

  def get_url_params(type)
    "/#{type}.json?q=#{location_data}"
  end
end
