
module GH
  require "#{Rails.root}/lib/jenkins"

  GITHUB_TOKEN =  Rails.configuration.github_token || ENV['GITHUB_TOKEN'].nil? ? nil : ENV['GITHUB_TOKEN']
  USER =          Rails.configuration.github_user || ENV['GITHUB_USER']
  REPO =          Rails.configuration.github_repo || ENV['GITHUB_REPO']

  def get_and_enqueue_from_github
    pull_requests = get_github_prs
    open_prs = pull_requests.sort { |x,y| x.number <=> y.number } # oldest first

    open_prs.each do |github_pr|
      pr_record = PullRequest.find_or_create_by(number: github_pr.number)

      # if the pr was closed we know its open now, re-open it locally
      if pr_record.open == false
        pr_record.open = true
        pr_record.save!
      end
      current_sha = github_pr.head.sha
      # create a new commit record or find the current one
      commit_record = pr_record.commits.find_or_create_by(sha: current_sha)
      Rails.logger.info "found commit #{commit_record.id}, #{commit_record.sha}, test_pushed=#{commit_record.test_pushed}"
      # has the sha been tested yet?
      unless commit_record.test_pushed?
        commit_record.test_pushed = true
        commit_record.save!
        test_pr(commit_record.pull_request.number)
      end
    end
  end

  def test_pr(pr_num)
    puts "I will test pr#{pr_num}"
    Jenkins::build_pr(pr_num)
    if comment_on_prs?
      comment_on_pr(pr_num, "Enqueueing #{pr_num}" )
    end
  end

  def comment_on_pr(pr_num, comment)
    gh = Github.new(oauth_token: GITHUB_TOKEN, user: USER, repo: REPO)
    gh.issues.comments.create( USER, REPO, pr_num, body: comment )
  end

  def comment_on_prs?
    ENV['COMMENT_ON_PRS'] or false
  end

  def get_github_prs
    Github::PullRequests.new(oauth_token: GITHUB_TOKEN, user: USER, repo: REPO).list
  end

  def close_prs_locally_if_closed_on_github
    gh_prs = get_github_prs
    github_pr_numbers = []
    gh_prs.each { |pr| github_pr_numbers << pr.number }

    PullRequest.where(open: true).each do |local_pr|
      unless github_pr_numbers.include? local_pr.number
        Rails.logger.info "closing local pr record for #{local_pr.number}"
        close_pr local_pr.number
      end
    end
  end

  def close_pr(number)
    pr = PullRequest.find_by_number(number)
    pr.open = false
    pr.save
  end
end

