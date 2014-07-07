class AddAssignmentToSubmissions < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.belongs_to :assignment
    end
  end
end
