namespace :enqueue do

  desc 'run the build loop' 
  task :run => :environment do
    timeout = ENV['POLLING_TIMEOUT'] || 30
    require "#{Rails.root}/lib/github"
    include GH
    Rails.logger.info "Starting enqueues #{Time.now}"
    while true
      begin
        get_and_enqueue_from_github
        sleep timeout
      rescue => e
        Rails.logger.info e.message
        Rails.logger.info e.backtrace.join("\n")
        puts e.backtrace.join("\n")
        sleep timeout*4
      end
    end
  end
end
