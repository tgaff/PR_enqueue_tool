class RenamePullrequestsToPullRequests < ActiveRecord::Migration
  def change
    rename_table 'Pullrequests', '_tmp_pr'
    rename_table '_tmp_pr', 'PullRequests'
  end
end
