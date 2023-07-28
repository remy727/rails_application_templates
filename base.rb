if yes?("== Prepare database? [y/N] ==")
	rails_command "db:prepare"
end

if yes?("== Disable helper generator? [y/N] ==")
	environment "config.generators.help = nil"
end
