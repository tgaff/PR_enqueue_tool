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
      expect { close_pr(1000) }.to change { PullRequest.find_by_number(1000).open }.from(true).to(false)
    end

  end
end
