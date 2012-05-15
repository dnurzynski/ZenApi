require 'spec_helper'

module ZenApi
  describe Client do
    let(:client) { ZenApi::Client.new :api_key => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' }

    specify '#initialize - raises ArgumentError if api_key is missing' do
      expect { ZenApi::Client.new }.to raise_error ArgumentError
    end
  end
end
