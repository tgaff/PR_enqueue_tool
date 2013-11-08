class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.boolean :test_pushed, default: false

      t.timestamps
    end
  end
end
