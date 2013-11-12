class AddShaToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :sha, :string, limit: 40
  end
end
