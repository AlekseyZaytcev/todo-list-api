# frozen_string_literal: true

namespace :api do
  namespace :doc do
    desc 'Generate API documentation markdown'
    task :md do
      require 'rspec/core/rake_task'

      RSpec::Core::RakeTask.new(:api_spec) do |t|
        t.pattern = 'spec/requests/'
        t.rspec_opts = '--require rails_helper -f Dox::Formatter --order defined ' \
                       '--tag dox --out public/api/docs/v1/documentation.md'
      end

      Rake::Task['api_spec'].invoke
    end

    task html: :md do
      `aglio --theme-full-width -i public/api/docs/v1/documentation.md -o public/api/docs/v1/documentation.html`
    end

    task open: :html do
      `xdg-open public/api/docs/v1/documentation.html`
    end
  end
end
