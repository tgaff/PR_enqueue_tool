require 'spec_helper'
require "#{Rails.root}/lib/github"
describe GH do
  include GH

  describe '.get_and_enqueue_from_github', :vcr do
    fixtures :pull_requests, :commits
    before(:each) { allow(self).to receive(:test_pr).with(anything()).and_return('test') }

    context 'when the commit is already present' do
      it 'does not create a new commit' do
        expect { get_and_enqueue_from_github }.to_not change { PullRequest.find_by(number: 92).commits.count }
      end

      context 'and has not been tested' do
        let(:pr_record) { pull_requests(:github_open).reload }

        it 'enqueues a test' do
          allow(self).to receive(:test_pr).with(92)
          get_and_enqueue_from_github
        end

        it 'marks it as tested' do
          pr_record_commit = commits(:github_open)
          expect { get_and_enqueue_from_github }.to change { pr_record_commit.reload.test_pushed }.from(false).to(true)
        end
      end

      context 'and has been tested' do
        it 'does not enqueue anything' do
          c = commits(:github_open)
          c.test_pushed = true
          c.save!
          PullRequest.find_by(number: 92).reload.commits.last.test_pushed.should eq true
          self.should_not_receive(:test_pr).with(92)
          get_and_enqueue_from_github
        end
      end

    end

    context 'when the commit is not already present' do
      before(:each) do
        commits(:github_open).destroy
        expect(PullRequest.find_by(number: 92).reload.commits.count).to eq 0
      end

      it 'creates a new commit' do
        expect { get_and_enqueue_from_github }.to change {PullRequest.find_by(number: 92).commits.count }.by(1)
      end

      it 'enqueues a test' do
        self.should_receive(:test_pr).with(92)
        get_and_enqueue_from_github
      end
    end

    context 'when the pr is not open' do
      it 'opens the pr' do
        pr = pull_requests(:github_open)
        pr.open = false
        pr.save!

        expect { get_and_enqueue_from_github }.to change {PullRequest.find_by(number: 92).reload.open }.from(false).to(true)
      end
    end
    context 'when the pr does not exist' do
      it 'creates an open pr' do
        pr = pull_requests(:github_open)
        pr.destroy!

        expect { get_and_enqueue_from_github }.to change { PullRequest.find_by(number: 92) }.from(nil)
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
