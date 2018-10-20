namespace :dev do
    desc "Rebuild system"
    task :seed => [ "db:seed" ]
end