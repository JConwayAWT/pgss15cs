class AddDocumentsToAssignments < ActiveRecord::Migration
  def self.up
    add_attachment :assignments, :document
  end

  def self.down
    remove_attachment :assignments, :document
  end
end