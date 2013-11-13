require 'spec_helper'

describe Commit do
  it { should belong_to(:pull_request) }
  it { should_not allow_value(nil).for(:test_pushed) }
  context 'sha' do
    it { should_not allow_value('asdf').for(:sha) }
    it { should allow_value('4a847531a7363eb06df64c4a44101ac4ee1b65d4').for(:sha) }
  end
end
