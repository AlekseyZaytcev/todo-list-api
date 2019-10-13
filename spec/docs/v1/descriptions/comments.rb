# frozen_string_literal: true

# :reek:UncommunicativeModuleName
module Docs
  module V1
    module Comments
      extend Dox::DSL::Syntax

      # define common resource data for each action
      document :api do
        resource 'Comments' do
          endpoint '/tasks/:task_id/comments'
          group 'Comments'
        end
      end

      # define data for specific action
      document :index do
        action 'A list of Comments'
      end

      document :create do
        action 'Creates a Comment'
      end

      document :destroy do
        action 'Deletes the Comment'
      end
    end
  end
end
