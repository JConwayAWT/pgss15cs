class AddItsClassToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :its_class
    end
  end
end
