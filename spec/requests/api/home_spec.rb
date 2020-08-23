require 'rails_helper'

describe '/api/v1/home/', type: :request do
  describe 'GET /api/v1/home' do
    let(:endpoint) do
      '/api/v1/home'
    end

    context 'when successful' do
      it 'returns status ok' do
        get(endpoint)

        expect(response).to have_http_status :ok
      end
    end
  end
end
