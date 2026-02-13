class HomesController < ApplicationController

  include HomeControllerHelper

  # Calling rescue_from here as it allows us to handle expections
  # in a DRY way.
  rescue_from ::GeocodeApi::NoDataFound, with: :no_data_found_error
  rescue_from ::GeocodeApi::ApiError, with: :api_error
  rescue_from ::WeatherApi::NoDataFound, with: :no_data_found_error
  rescue_from ::WeatherApi::ApiError, with: :api_error

  def index
  end

  # 1. call the geo api
  # 2. capture the data from the geo response
  # 3. check the cache to see if we have data available and retreive if so
  # 4. call the weather api if not
  # 5. capture the data from the weather api
  # 6. process the json
  # 7. store the data in the cache
  # 8. return the data to the page
  def create
    data_options = {}
    data_options[:freeform_address] = basic_query_params

    geo_data = GeocodeApi.new(data_options).retrieve_from_freeform
    cached_data = get_cached_weather_data(geo_data)
    Rails.logger.info("[HomeController#create|cached_data] This is the result from the call for cached data: #{cached_data}")
    fetch_data = fetch_weather_data(geo_data) if cached_data.nil?
    Rails.logger.info("[HomeController#create|fetch_data] This is the result from the call for fetch data: #{fetch_data}")

    if cached_data.present?
      @weather_facts = cached_data.merge({cached: true})
      respond_to do |format|
        format.turbo_stream { render turbo_stream: 
                              turbo_stream.update("weather_facts",
                                                  partial: "facts") }
      end  
    elsif fetch_data.present?
      @weather_facts = fetch_data.merge({cached: false})
      respond_to do |format|
        format.turbo_stream { render turbo_stream: 
                              turbo_stream.update("weather_facts",
                                                  partial: "facts") }
      end
    else
      no_data_found_error
    end
  end

  private

  def fetch_weather_data(geo_data)
    Rails.logger.info("[Home Controller#fetch_weather_data] Fetching and Saving Data by Cache Signiture #{cache_signiture(geo_data)}")
    Rails.cache.fetch(cache_signiture(geo_data), expires_in: 30.minutes) do
      weather_object = WeatherApi.new(lat_and_lon(geo_data))
      weather_object.get_forecast
    end
  end

  def get_cached_weather_data(geo_data)
    Rails.logger.info("[Home Controller#get_cached_weather_data] Fetching and Saving Data by Cache Signiture #{cache_signiture(geo_data)}")
    Rails.cache.read(cache_signiture(geo_data))
  end

  def no_data_found_error
    respond_to do |format|
      format.turbo_stream { render turbo_stream: 
                            turbo_stream.update("weather_facts",
                                                partial: "data_error") } 
    end 
  end

  def api_error
    respond_to do |format|
      format.turbo_stream { render turbo_stream: 
                            turbo_stream.update("weather_facts",
                                                partial: "api_error") } 
    end
  end

  def basic_query_params
    params.expect(:query)
  end

  def advanced_query_params
    params.expect(location: [:street, :city, :state, :country, :zipcode])
  end
end
