require 'spec_helper'

module ZenApi
  describe Client do
    context 'initialize' do
      it 'raises ArgumentError if api_key is missing' do
        expect { ZenApi::Client.new }.to raise_error ArgumentError
      end
    end
  end
end

