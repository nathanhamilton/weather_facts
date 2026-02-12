class GeocodeApi
  class NoDataFound < StandardError; end
  class ApiError < StandardError; end

  include HTTParty
  include IntegrationHelpers

  base_uri 'https://geocode.maps.co/search'

  attr_reader :options

  def initialize(options)
    @options = options
    self.class.headers 'Authorization' => "Bearer #{ENV['GEOCODING_API_KEY']}"
  end

  def retrieve_from_freeform
    freeform_address = options[:freeform_address]

    result = self.class.get("?q=" + freeform_address)
    
    raise GoecodeApi::ApiError unless success?(result)
    raise GeocodeApi::NoDataFound if success_but_no_data?(result)

    json_body = JSON.parse(result.body).first
    json_body.select { |key, value| %w[lat lon].include?(key) }
  end

  def retrieve_from_structured
    structured_address = options[:structured_address]
    result = self.class.get("?=#{structured_address}")

    raise GeoCodeApi::NodataFound if success_but_no_data?(result)

    JSON.parse(result.body).first
  end

  private

  end
