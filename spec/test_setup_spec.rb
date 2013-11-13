require 'spec_helper'

describe 'the test env setup' do
  it 'has the github setup pointing to a public gem' do
    Rails.configuration.github_user = 'octocat'
    Rails.configuration.github_repo = 'Hello-World'
  end
end
