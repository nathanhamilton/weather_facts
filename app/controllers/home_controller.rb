class HomeController < ApplicationController

  def index
  end

  def create

    # 1. call the geo api
    # 2. capture the data from the geo response
    # 3. call the weather api
    # 4. capture the data from the weather api
    # 5. process the json
    # 6. return the data to the page
  end

  private

  def basic_query_params
    params.expect(query)
  end

  def advanced_query_params
    params.expect(location: [:street, :city, :state, :country, :zipcode])
  end
end
