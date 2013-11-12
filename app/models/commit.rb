class Commit < ActiveRecord::Base
  belongs_to :pull_request

  validates :test_pushed, presence: true
  validates :sha, length: { is: 40 }
end
