class AddNotesToWines < ActiveRecord::Migration
  def change
    add_column :wines, :notes, :text
  end
end
