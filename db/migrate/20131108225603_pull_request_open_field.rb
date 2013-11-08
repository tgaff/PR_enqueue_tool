class PullRequestOpenField < ActiveRecord::Migration
  def change
    add_column :pullrequests, :open, :boolean, default: true
  end
end
