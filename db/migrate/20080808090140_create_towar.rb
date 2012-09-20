class CreateTowar < ActiveRecord::Migration
  def self.up
    create_table :towar do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :towar
  end
end
