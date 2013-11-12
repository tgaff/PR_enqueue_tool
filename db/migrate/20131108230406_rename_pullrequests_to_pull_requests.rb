class RenamePullrequestsToPullRequests < ActiveRecord::Migration
  def change
    rename_table 'pullrequests', '_tmp_pr'
    rename_table '_tmp_pr', 'pull_requests'
  end
end
