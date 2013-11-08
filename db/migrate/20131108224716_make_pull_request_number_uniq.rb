class MakePullRequestNumberUniq < ActiveRecord::Migration
  def change
    add_index :pullrequests, :number, unique: true
  end
end
