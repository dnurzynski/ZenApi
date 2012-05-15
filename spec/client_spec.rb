require 'spec_helper'

module ZenApi
  describe Client do
    let(:client) do
      c = ZenApi::Client.new(:api_key => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx')
      c.define_schema {}
      c
    end

    specify '#initialize - raises ArgumentError if api_key is missing' do
      expect { ZenApi::Client.new }.to raise_error ArgumentError
    end

    specify '#call - returns instance of ZenApi::Call with current client schema' do
      client.call.should be_an_instance_of ZenApi::Call
      client.call.schema.should eql client.schema
    end

    describe '#define_schema - defines API schema' do
      before do
        client.define_schema do
          resource :me do
            resources :stories
          end

          resources :projects do
            resources :members
          end

        end

      end

      it '#call.me.path - eql "/me"' do
        client.call.me.path.should eql "/me"
      end

      it '#call.me.stories.path - eql "/me/stories"' do
        client.call.me.stories.path.should eql "/me/stories"
      end

      it '#call.me.undefined_path - raises NoMethodError' do
        expect { client.call.me.undefined_path }.to raise_error NoMethodError
      end

      it '#call.projects.show(1).path - eql "/projects/1"' do
        client.call.projects.show(1).path.should eql "/projects/1"
      end

      it '#call.projects.members.path - raises NoMethodError"' do
        expect { client.call.projects.members.path }.to raise_error NoMethodError
      end

      it '#call.projects.show(2).members.path - eql "/projects/2/members"' do
        client.call.projects.show(2).members.path.should eql "/projects/2/members"
      end

    end
  end
end
