require 'rails_helper'
require 'ostruct'

RSpec.describe IntegrationHelper, type: :helper do
  
  describe '#success?' do

    let!(:success_result) { OpenStruct.new(response: OpenStruct.new(code: '200')) } 
    let!(:failure_result) { OpenStruct.new(response: OpenStruct.new(code: '400')) } 

    context 'when the response is successful' do
      it 'responds true the response is HTTP 200' do
        expect(helper.success?(success_result)).to eq true
      end
    end

    context 'when the response is unsuccessful' do

      it 'responds false if the response is not HTTP 200' do
        expect(helper.success?(failure_result)).to eq false
      end
    end
  end

  describe '#success_but_no_data' do

    let!(:success_result) { OpenStruct.new(response: OpenStruct.new( code: '200'), body: "[{object: 1}, {object: 2}]") }
    let!(:failure_result) { OpenStruct.new(response: OpenStruct.new( code: '200'), body: "[]") }

    context 'when the response is successful but no data exists' do
      it 'returns true' do
        expect(helper.success_but_no_data?(failure_result)).to eq true
      end
    end

    context 'when the response is successful and data does exist' do
      it 'returns false' do
        expect(helper.success_but_no_data?(success_result)).to eq false
      end
    end
  end
end