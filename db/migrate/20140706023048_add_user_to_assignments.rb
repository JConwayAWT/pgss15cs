class AddUserToAssignments < ActiveRecord::Migration
  def change
    change_table :assignments do |t|
      t.belongs_to :user
    end
  end
end
