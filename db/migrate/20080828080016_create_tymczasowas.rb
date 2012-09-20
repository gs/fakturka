class CreateTymczasowas < ActiveRecord::Migration
  def self.up
    create_table :tymczasowas do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :tymczasowas
  end
end
