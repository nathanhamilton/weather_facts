require 'rails_helper'

RSpec.describe HomesController, type: :controller do

  describe 'GET Index' do
    it 'should return 200' do
      get(:index)
      expect(response.status).to eq 200
    end
  end

  #TODO: More tests to be added here.
end
