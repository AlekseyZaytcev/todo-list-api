# frozen_string_literal: true

# :reek:UncommunicativeModuleName
module Docs
  module V1
    module Projects
      extend Dox::DSL::Syntax

      # define common resource data for each action
      document :api do
        resource 'Projects' do
          endpoint '/projects'
          group 'Projects'
        end
      end

      # define data for specific action
      document :index do
        action 'A list of Projects'
      end

      document :create do
        action 'Creates a Project'
      end

      document :show do
        action 'Shows the Project'
      end

      document :update do
        action 'Updates the Project'
      end

      document :destroy do
        action 'Deletes the Project'
      end
    end
  end
end
