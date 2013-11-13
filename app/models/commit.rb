class Commit < ActiveRecord::Base
  belongs_to :pull_request

  validates :test_pushed, inclusion: { in: [true, false] }
  validates :sha, length: { is: 40 }
end
