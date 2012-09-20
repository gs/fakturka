class CreateKontrahent < ActiveRecord::Migration
  def self.up
    create_table :kontrahent do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :kontrahent
  end
end
