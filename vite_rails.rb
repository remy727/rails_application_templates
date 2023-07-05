puts "== Installing Vite =="
gem "vite_rails"
Bundler.with_unbundled_env { run "bundle install" }
run "bundle exec vite install"

puts
if yes?("== Create bin/dev? [y/N] ==")
  file "bin/dev", <<-CODE
#!/usr/bin/env sh

if ! gem list foreman -i --silent; then
  echo "Installing foreman... =="
  gem install foreman
fi

exec foreman start -f Procfile.dev "$@"
CODE

  run "chmod a+x bin/dev"
end

puts
if yes?("== Generate Home controller? [y/N] ==")
  puts "== Generating Home controller =="
  generate(:controller, "Home", "index")

  puts "== Adding root route... =="
  route "root 'home#index'"
end

puts
if yes?("== Add React? [y/N] ==")

  puts "== Adding React packages =="
  run "yarn add react react-dom"

  puts "== Removing app/frontend/entrypoints/application.js file... =="
  run "rm 'app/frontend/entrypoints/application.js'"

  puts "== Creating app/frontend/entrypoints/application.jsx file... =="
  run "rm 'app/frontend/entrypoints/application.jsx'"
  file "app/frontend/entrypoints/application.jsx", <<-CODE
import React from 'react';
import { createRoot } from "react-dom/client";

import App from './App';

const container = document.getElementById("root");
const root = createRoot(container);
root.render(
  <App />
);
CODE

  run "rm 'app/frontend/entrypoints/App.jsx'"
  file "app/frontend/entrypoints/App.jsx", <<-CODE
import React from 'react';

const App = () => {
  return (
    <div>
      Page
    </div>
  );
};

export default App;
CODE

  puts "== Replacing the existing code in app/views/home/index.html.erb... =="
  run "rm 'app/views/home/index.html.erb'"
  file "app/views/home/index.html.erb", <<-CODE
<div id="root" />
CODE

  puts "== Update application layout to use .jsx... =="
  application_layout = "app/views/layouts/application.html.erb"
  text = File.read(application_layout)
  text.gsub!("<%= vite_javascript_tag 'application' %>", "<%= vite_javascript_tag 'application.jsx' %>")
  File.open(application_layout, "w") { |file| file.puts text }

end
