class CreateFakturkas < ActiveRecord::Migration
  def self.up
    create_table :fakturkas do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :fakturkas
  end
end
