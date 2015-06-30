class AddItsClassToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      # t.boolean :its_class
      t.boolean :advanced_lab
    end
  end
end
