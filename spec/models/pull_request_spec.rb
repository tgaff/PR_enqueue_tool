require 'spec_helper'

describe PullRequest do
  it { should have_many(:commits) }
end
