# frozen_string_literal: true

RSpec.shared_examples 'respond unauthorized' do
  it { expect(response).to have_http_status(:unauthorized) }
  it { expect(response.content_type).to eq('application/json; charset=utf-8') }
  it { expect(JSON.parse(response.body).dig('error')).to eq('You need to sign in or sign up before continuing.') }
end
