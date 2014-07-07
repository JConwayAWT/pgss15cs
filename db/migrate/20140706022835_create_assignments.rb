class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.string :status
      t.datetime :duedate

      t.timestamps
    end
  end
end
