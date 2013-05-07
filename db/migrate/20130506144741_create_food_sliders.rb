class CreateFoodSliders < ActiveRecord::Migration
  def change
    create_table :food_sliders do |t|
      t.boolean :hidden

      t.timestamps
    end
  end
end
