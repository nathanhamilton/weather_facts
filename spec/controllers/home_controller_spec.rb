require 'rails_helper'

RSpec.describe HomeController, type: :controller do

  describe 'GET Index' do
    it 'should return 200' do
      response = get(:index)
      expect(response).to eq 200
    end
  end
end
