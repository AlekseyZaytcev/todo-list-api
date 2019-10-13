# frozen_string_literal: true

# :reek:UncommunicativeModuleName
module Docs
  module V1
    module Tasks
      extend Dox::DSL::Syntax

      # define common resource data for each action
      document :api do
        resource 'Tasks' do
          endpoint '/projects/:project_id/tasks'
          group 'Tasks'
        end
      end

      # define data for specific action
      document :index do
        action 'A list of Tasks'
      end

      document :create do
        action 'Creates a Task'
      end

      document :show do
        action 'Shows the Task'
      end

      document :update do
        action 'Updates the Task'
      end

      document :destroy do
        action 'Deletes the Task'
      end

      document :complete do
        action 'Mark Task as completed'
      end

      document :update_priority do
        action 'Change Priority of Task'
      end
    end
  end
end
