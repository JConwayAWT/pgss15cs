class AddRatingToSubmissions < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.string :rating
    end
  end
end
