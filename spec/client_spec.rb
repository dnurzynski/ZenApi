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
            resources :invites
            resources :roles do
              resources :members
            end

            resources :tags do
              resources :stories
            end

            resources :stories do
              resources :tasks
              resources :tags
              resources :comments
              resources :attachments
            end

            resources :phases do
              resources :stories
            end

          end

        end

      end

      describe '#resources :projects' do
        subject { client.call.projects }

        it "defines :all and :create requests in projects schema" do
          subject.schema.requests[:all].should eql :get
          subject.schema.requests[:create].should eql :post
        end

      end

      describe '#call.me' do
        subject { client.call.me }

        it '#me.path - eql "me"' do
          subject.path.should eql "me"
        end

        it '#stories.path - eql "me/stories"' do
          subject.stories.path.should eql "me/stories"
        end

        it '#undefined_path - raises NoMethodError' do
          expect { subject.undefined_path }.to raise_error NoMethodError
        end
      end

      describe '#call.projects' do
        subject { client.call.projects }

        it '#path - eql "projects"' do
          subject.path.should eql "projects"
        end

        it '#all - sends request GET "projects"' do
          subject.client.conn.should_receive(:get).with('projects', {}).and_return mock(:body => "")
          subject.all
        end

        it '#create - sends request POST "projects" with given arguments' do
          subject.client.conn.should_receive(:post).with('projects', {:name => "Project name"}).and_return mock(:body => "")
          subject.create :name => "Project name"
        end

        it '#members.path - raises NoMethodError"' do
          expect { client.call.projects.members.path }.to raise_error NoMethodError
        end

        describe '#projects.show(1)' do
          subject { client.call.projects.show(1) }

          it '#path - eql "projects/1"' do
            subject.path.should eql "projects/1"
          end

          it '#find - sends request GET "projects/1"' do
            subject.client.conn.should_receive(:get).with('projects/1', {}).and_return mock(:body => "")
            subject.find
          end

          it '#members.path - eql "projects/1/members"' do
            subject.members.path.should eql "projects/1/members"
          end

          it '#invites.path - eql "projects/1/invites"' do
            subject.invites.path.should eql "projects/1/invites"
          end

          it '#invites.show(1).path - eql "projects/1/invites/1"' do
            subject.invites.show(2).path.should eql "projects/1/invites/2"
          end

          it '#stories.path - eql "projects/1/stories"' do
            subject.stories.path.should eql "projects/1/stories"
          end

          describe '#stories.show(2)' do
            subject { client.call.projects.show(1).stories.show(2) }

            it '#path - eql "projects/1/stories/2' do
              subject.path.should eql "projects/1/stories/2"
            end

            it '#tags.path - eql "projects/1/stories/2/tags"' do
              subject.tags.path.should eql "projects/1/stories/2/tags"
            end

            it '#tags.show(3) - raises NoMethodError' do
              pending
            end

            it '#comments.path - eql "projects/1/stories/2/comments"' do
              subject.comments.path.should eql "projects/1/stories/2/comments"
            end

            it '#comments.show(3).path - eql "projects/1/stories/2/comments/3"' do
              subject.comments.show(3).path.should eql "projects/1/stories/2/comments/3"
            end

            it '#attachments.path - eql "projects/1/stories/2/attachments"' do
              subject.attachments.path.should eql "projects/1/stories/2/attachments"
            end

            it '#attachments.show(3).path - eql "projects/1/stories/2/attachments/3"' do
              subject.attachments.show(3).path.should eql "projects/1/stories/2/attachments/3"
            end

            it '#tasks.path - eql "projects/1/stories/2/tasks"' do
              subject.tasks.path.should eql "projects/1/stories/2/tasks"
            end

            describe "#tasks.show(3)" do
              subject { client.call.projects.show(1).stories.show(2).tasks.show(3) }
              it '#path - eql "projects/1/stories/2/tasks/3' do
                subject.path.should eql "projects/1/stories/2/tasks/3"
              end
            end


          end

          it '#phases.path - eql "projects/1/phases"' do
            subject.phases.path.should eql "projects/1/phases"
          end

          describe "#phases.show(2)" do
            subject { client.call.projects.show(1).phases.show(2) }

            it '#path - eql "projects/1/phases/2' do
              subject.path.should eql "projects/1/phases/2"
            end

            it '#stories.path - eql "projects/1/phases/2/stories' do
              subject.stories.path.should eql "projects/1/phases/2/stories"
            end

            it '#stories.show(3) - raises NoMethodError' do
              pending
            end
          end

          it '#tags.path - eql "projects/1/tags"' do
            subject.tags.path.should eql "projects/1/tags"
          end

          describe "#tags.show(2)" do
            subject { client.call.projects.show(1).tags.show(2) }

            it '#path - eql "projects/1/tags/2' do
              subject.path.should eql "projects/1/tags/2"
            end

            it '#stories.path - eql "projects/1/tags/2/stories' do
              subject.stories.path.should eql "projects/1/tags/2/stories"
            end

            it '#stories.show(3) - raises NoMethodError' do
              pending
            end
          end

          it '#roles.path - eql "projects/1/roles"' do
            subject.roles.path.should eql "projects/1/roles"
          end

          describe "#roles.show(2)" do
            subject { client.call.projects.show(1).roles.show(2) }

            it '#path - eql "projects/1/roles/2' do
              subject.path.should eql "projects/1/roles/2"
            end

            it '#members.path - eql "projects/1/roles/2/members' do
              subject.members.path.should eql "projects/1/roles/2/members"
            end

            it '#members.show(3) - raises NoMethodError' do
              pending
            end
          end

        end
      end
    end
  end
end
