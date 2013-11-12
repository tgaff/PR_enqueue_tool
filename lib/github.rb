
module GH

  GITHUB_TOKEN =  ENV['GITHUB_TOKEN']
  USER =          ENV['GITHUB_USER']
  REPO =          ENV['GITHUB_REPO']




  def get_and_enqueue_from_github
    gh_pr = Github::PullRequests.new oauth_token: GITHUB_TOKEN, user: USER, repo: REPO

    pull_requests = gh_pr.list
    open_prs = pull_requests

    open_prs.each do |github_pr|
      pr_record = PullRequest.find_or_create_by_number(github_pr.number)

      # if the pr was closed we know its open now, re-open it locally
      if pr_record.open == false
        pr_record.open = true
        pr_record.save!
      end

      current_sha = github_pr.sha
      # create a new commit record or find the current one
      commit_record = pr_record.commits.find_or_create_by_sha(current_sha)
      Rails.logger.info "found commit #{commit_record}"

      # has the sha been tested yet?
      test_pr unless commit_record.test_pushed?
    end
  end

  def test_pr(pr)
    puts "I will test pr#{pr}"
  end

  def close_prs_locally_if_closed_on_github
    gh_pr = Github::PullRequests.new oauth_token: GITHUB_TOKEN, user: USER, repo: REPO
    github_pr_numbers = []
    gh_pr.list.each { |pr| github_pr_numbers << pr.number }

    PullRequests.where(open: true).each do |local_pr|
      unless github_pr_numbers.include? local_pr.number
        Rails.logger.info "closing pr #{local_pr.number}"
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

