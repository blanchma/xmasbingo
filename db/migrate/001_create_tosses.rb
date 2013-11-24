class CreateTosses < ActiveRecord::Migration
  def self.up
    create_table :tosses do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :tosses
  end
end
