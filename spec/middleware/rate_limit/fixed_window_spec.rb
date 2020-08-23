require 'rails_helper'

RSpec.describe FixedWindow do
  subject { described_class.new(app) }

  let(:app) { ->(env) { [200, env, 'app'] } }
  let(:max_requests) { 100 }

  def request(ip: '1.1.1.1', url: 'www.localhost.com/home', opts: {})
    Rack::MockRequest.env_for(url, opts).tap do |env|
      env['REMOTE_ADDR'] = ip
    end
  end

  before do
    freeze_time
  end

  context 'when the limit has not been reached' do
    it 'returns ok status' do
      max_requests.times do
        code, _env, body = subject.call request

        expect(code).to eq 200
        expect(body).to eq 'app'
      end
    end
  end

  context 'when the limit has been reached' do
    it 'returns 429' do
      max_requests.times { subject.call request }

      code, _env = subject.call request
      expect(code).to eq 429
    end

    it 'returns message' do
      max_requests.times { subject.call request }

      _code, _env, body = subject.call request
      expect(body).to eq ['Rate limit exceeded. Try again in 3600 seconds.']
    end

    it 'expires the key after 1 hour' do
      max_requests.times { subject.call request }
      code, _env = subject.call request
      expect(code).to eq 429

      travel 1.hour

      code, _env = subject.call request
      expect(code).to eq 200
    end

    it 'returns 429 only for expired keys' do
      max_requests.times { subject.call request }

      code, _env = subject.call request
      expect(code).to eq 429

      code, _env = subject.call request(ip: '1.1.1.2')
      expect(code).to eq 200
    end
  end
end
