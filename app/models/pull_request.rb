class PullRequest < ActiveRecord::Base
  validates_uniqueness_of :number
end
