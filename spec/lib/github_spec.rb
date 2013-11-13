require 'spec_helper'
require "#{Rails.root}/lib/github"
describe GH do
  include GH

  describe '.get_and_enqueue_from_github' do
    context 'when the commit is already present' do
      it 'does not create a new commit' do
        pending
      end

      context 'and has not been tested' do
        it 'enqueues a test' do
          pending
        end
      end

      context 'and has been tested' do
        it 'does not enqueue anything' do
          pending
        end
      end

    end

    context 'when the commit is not already present' do
      it 'does create a new commit' do
        pending
      end
      it 'enqueues a test' do
        pending
      end
    end
  end


  describe '.close_prs' do
    fixtures :pull_requests

    it 'closes the open pr' do
      expect { close_pr(100000) }.to change { PullRequest.find_by_number(100000).open }.from(true).to(false)
    end

  end


  context '.close_prs_locally_if_closed_on_github', :vcr do

    fixtures :pull_requests
    let(:pr_record_github_open) { PullRequest.find_by_number(pull_requests(:github_open).number) }
    let(:pr_record_github_closed) { PullRequest.find_by_number(pull_requests(:open).number) }

    it "does not close open PRs still open remotely" do
      expect { close_prs_locally_if_closed_on_github }.to_not change{ pr_record_github_open.reload.open }
    end

    it "closes open PRs when not open on the remote" do
      expect { close_prs_locally_if_closed_on_github }.to change { pr_record_github_closed.reload.open }.from(true).to(false)
    end
  end

end
