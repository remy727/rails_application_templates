def do_bundle
	Bundler.with_unbundled_env { run "bundle install" }
end

def download_file(url, path)
	run "curl -o #{path} #{url}"
end

gem "sidekiq"
do_bundle

github_raw_url = "https://raw.githubusercontent.com/remy727/rails_application_templates/sidekiq/sidekiq.rb"
file_path = "config/initializers/sidekiq.rb"

download_file(github_raw_url, file_path)