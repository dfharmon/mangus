class CreateRandomMessages < ActiveRecord::Migration
  def change
    create_table :message_categories do |t|
      t.string :name
      t.timestamps
    end

    create_table :messages do |t|
      t.string :content
      t.integer :message_category_id
      t.timestamps
    end
  end
end
