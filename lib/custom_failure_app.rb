# frozen_string_literal: true

class CustomFailureApp < Devise::FailureApp
  def respond
    http_auth
  end
end
