module HomeControllerHelper

  # Method: convert_location_hash
  # Receives a hash and expectss two keys of lat and lon.
  # Example: {"lat" => "30.2766200", "lon" => "-97.7397670"}
  def lat_and_lon(geo_data)
    return if geo_data.nil?
    data = geo_data.select { |key, value| %w[lat lon].include?(key) }
    data['lat'] + ',' + data['lon']
  end

  def cache_signiture(geo_data)
    return if geo_data.nil?
    data = geo_data['address'].select { |key, value| %w[postcode country_code].include?(key) }
    data['postcode'] + '_' + data['country_code']
  end
end
