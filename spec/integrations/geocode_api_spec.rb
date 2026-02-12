require 'rails_helper'

RSpec.describe GeocodeApi do

  describe '#initialize' do
    context 'when no parameters are passed' do
      it 'returns and error' do
        expect {
          GeocodeApi.new
        }.to raise_error(ArgumentError)
      end
    end

    context 'when parameters are passed' do
      it 'provides the parameters to the class as an instance variable' do
        instance = GeocodeApi.new('variable')

        expect(instance.methods.include?(:options)).to be true
      end
    end
  end

  describe '#retrieve_from_freeform' do

    let(:geocode_success_body) {
      [
        {
          "place_id": 330930455,
          "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
          "osm_type": "node",
          "osm_id": 3850050664,
          "lat": "30.2766200",
          "lon": "-97.7397670",
          "class": "place",
          "type": "house",
          "place_rank": 30,
          "importance": 7.494392309448413e-05,
          "addresstype": "place",
          "name": "",
          "display_name": "1400, Congress Avenue, Austin, Travis County, Texas, 78701, United States",
          "address": {
              "house_number": "1400",
              "road": "Congress Avenue",
              "city": "Austin",
              "county": "Travis County",
              "state": "Texas",
              "ISO3166-2-lvl4": "US-TX",
              "postcode": "78701",
              "country": "United States",
              "country_code": "us"
          },
          "extratags": nil,
          "namedetails": nil,
          "boundingbox": [
              "30.2765700",
              "30.2766700",
              "-97.7398170",
              "-97.7397170"
          ]
        }
      ]
    }

    let(:shortened_geocode_multiple_success_body) {
      [
        {
          "place_id": 330571165,
          "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
          "osm_type": "way",
          "osm_id": 165170438,
          "lat": "30.2248464",
          "lon": "-97.7666015",
          "class": "highway",
          "type": "motorway",
          "place_rank": 26,
          "importance": 0.05340827725642783,
          "addresstype": "road",
          "name": "US 290;TX 71",
          "display_name": "US 290;TX 71, Placidena, Austin, Travis County, Texas, 78704, United States",
          "address": {
            "road": "US 290;TX 71",
            "neighbourhood": "Placidena",
            "city": "Austin",
            "county": "Travis County",
            "state": "Texas",
            "ISO3166-2-lvl4": "US-TX",
            "postcode": "78704",
            "country": "United States",
            "country_code": "us"
          }
        },
        {
          "place_id": 330571221,
          "licence": "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
          "osm_type": "way",
          "osm_id": 1051214395,
          "lat": "30.2226168",
          "lon": "-97.7636001",
          "class": "highway",
          "type": "motorway",
          "place_rank": 26,
          "importance": 0.05340827725642783,
          "addresstype": "road",
          "name": "US 290;TX 71",
          "display_name": "US 290;TX 71, Austin, Travis County, Texas, 78704, United States",
          "address": {
            "road": "US 290;TX 71",
            "city": "Austin",
            "county": "Travis County",
            "state": "Texas",
            "ISO3166-2-lvl4": "US-TX",
            "postcode": "78704",
            "country": "United States",
            "country_code": "us"
          }
        }
      ]
    }
  
    context 'when data is successfully returns' do
      it 'returns the body with the data' do
        address = '1400 Congress Avenue, Austin, TX 78701 US'
        options = {}
        options[:freeform_address] = address
        geocode_object = GeocodeApi.new(options)

        expect(geocode_object.retrieve_from_freeform["lat"]).to eq geocode_success_body.first[:lat]
        expect(geocode_object.retrieve_from_freeform["lon"]).to eq geocode_success_body.first[:lon]
      end
    end

    context 'when multiple results are returned from the geolocation' do
      # From my tests using the Geocode Api, it always attempted to return the most accurate result first.
      it 'returns the first option' do
        address = 'TX 78701 US'
        options = {}
        options[:freeform_address] = address
        geocode_object = GeocodeApi.new(options)
        result = geocode_object.retrieve_from_freeform

        expect(result.is_a?(Hash)).to be true # This proves that there are no other results since it is not an array
        expect(result["lon"]).to eq shortened_geocode_multiple_success_body.first[:lon]
      end
    end

    context 'when the status is 200 but no data is returned' do
      it 'raises the NoDataFound Error' do
        address = '1126 Viral Way Austin, TX 78701 US'
        options = {}
        options[:freeform_address] = address
        geocode_object = GeocodeApi.new(options)

        expect {
          geocode_object.retrieve_from_freeform
        }.to raise_error(GeocodeApi::NoDataFound)
      end
    end
  end
end
