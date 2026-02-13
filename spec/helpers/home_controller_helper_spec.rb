require 'rails_helper'

RSpec.describe HomeControllerHelper, type: :helper do

  let!(:geo_data) {
    {
      "place_id" => 330571221,
      "licence" => "Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright",
      "osm_type" => "way",
      "osm_id" => 1051214395,
      "lat" => "30.2226168",
      "lon" => "-97.7636001",
      "class" => "highway",
      "type" => "motorway",
      "place_rank" => 26,
      "importance" => 0.05340827725642783,
      "addresstype" => "road",
      "name" => "US 290;TX 71",
      "display_name" => "US 290;TX 71, Ajjjustin, Travis County, Texas, 78704, United States",
      "address" => {
        "road" => "US 290;TX 71",
        "city" => "Austin",
        "county" => "Travis County",
        "state" => "Texas",
        "ISO3166-2-lvl4" => "US-TX",
        "postcode" => "78704",
        "country" => "United States",
        "country_code" => "us"
      }
    }
  }
  
  describe '#lat_and_lon' do
    it 'returns the lat and lon for use' do
      expect(helper.lat_and_lon(geo_data)).to eq '30.2226168,-97.7636001'
    end
  end

  describe '#cache_signiture' do
    it 'returns the postalcode and country code signiture for caching' do
      expect(helper.cache_signiture(geo_data)).to eq '78704_us'
    end
  end
end
