class CreateFakKontSumas < ActiveRecord::Migration
  def self.up
    create_table :fak_kont_suma do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :fak_kont_suma
  end
end
