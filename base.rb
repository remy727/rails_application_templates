if yes?("Prepare database? [y/N]")
	rails_command "db:prepare"
end

if yes?("Disable helper generator? [y/N]")
	environment "config.generators.helper = false"
end

if yes?("Disable helper generator? [y/N]")
	run "bundle lock --add-platform x86_64-linux"
end
