class AddDocumentsToSubmissions < ActiveRecord::Migration
  def self.up
    add_attachment :submissions, :document
  end

  def self.down
    remove_attachment :submissions, :document
  end
end