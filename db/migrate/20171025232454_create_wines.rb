class CreateWines < ActiveRecord::Migration
  def change
    create_table :wines do |t|
      t.string :producer
      t.string :wine_name
      t.integer :vintage
      t.string :price
      t.integer :quantity
      t.integer :user_id
    end
  end
end
