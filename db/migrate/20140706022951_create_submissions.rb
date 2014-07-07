class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :version_number
      t.text :feedback

      t.timestamps
    end
  end
end
