class AddInstructionsToAssignments < ActiveRecord::Migration
  def change
    change_table :assignments do |t|
      t.text :instructions
    end
  end
end
