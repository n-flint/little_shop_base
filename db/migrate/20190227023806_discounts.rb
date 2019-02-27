class Discounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.string :name
      t.float :min_p
      t.float :price_off
      t.integer :type
    end
  end
end
