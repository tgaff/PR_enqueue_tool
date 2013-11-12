class AssociateCommitsWithPRs < ActiveRecord::Migration
  def change
    change_table :commits do |t|
      t.belongs_to :pull_request
    end
  end
end
