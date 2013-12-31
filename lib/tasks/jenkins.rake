namespace :jenkins do
  
  
  desc 'run a build'
  task :enqueue_pr, [:pr_num] => :environment do |t, args|
    require "#{Rails.root}/lib/jenkins"
    include Jenkins
    pr_num = args[:pr_num]
    puts "I was called with #{pr_num}"
    build_pr(pr_num)
  end
end
