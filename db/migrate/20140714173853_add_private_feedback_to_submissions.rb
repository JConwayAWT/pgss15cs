class AddPrivateFeedbackToSubmissions < ActiveRecord::Migration
  def change
    change_table :submissions do |t|
      t.text :private_feedback
    end
  end
end
