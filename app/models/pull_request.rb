class PullRequest < ActiveRecord::Base
  validates_uniqueness_of :number
  
  has_many :commits
end
