require 'spec_helper'

describe Commit do
  it { should belong_to(:pull_request) }
end
