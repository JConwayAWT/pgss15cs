class AddAdvancedSectionToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :cs_advanced_section
    end
  end
end
