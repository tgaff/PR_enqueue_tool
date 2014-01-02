namespace :github do

  desc 'run the build loop' 
  task :run => :environment do
    timeout = ENV['POLLING_TIMEOUT'] || 15
    require "#{Rails.root}/lib/github"
    include GH
    while true
      get_and_enqueue_from_github
      sleep timeout
    end
  end
end
