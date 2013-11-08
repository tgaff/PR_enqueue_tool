class CreatePullrequests < ActiveRecord::Migration
  def change
    create_table :pullrequests do |t|
      t.integer :number

      t.timestamps
    end
  end
end
