# frozen_string_literal: true

# :reek:UncommunicativeModuleName
module Docs
  module V1
    module Users
      extend Dox::DSL::Syntax

      # define common resource data for each action
      document :api do
        resource 'Users' do
          endpoint '/users'
          group 'Users'
        end
      end

      # define data for specific action
      document :create do
        action 'Registration'
      end

      document :destroy do
        action 'Delete Registration'
      end

      document :sign_in do
        action 'Sign In'
      end

      document :sign_out do
        action 'Sign Out'
      end
    end
  end
end
