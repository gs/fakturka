# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20080822081724) do

  create_table "fak_kont_suma", :force => true do |t|
    t.integer "nr_faktury",                                     :null => false
    t.integer "id_wystawcy",      :limit => 5,                  :null => false
    t.integer "id_kontrahenta",   :limit => 5,                  :null => false
    t.string  "suma_faktury",     :limit => 50,                 :null => false
    t.string  "data_wystawienia", :limit => 50,                 :null => false
    t.string  "data_sprzedazy",   :limit => 50,                 :null => false
    t.string  "termin",           :limit => 50,                 :null => false
    t.string  "stan_faktury",     :limit => 50,                 :null => false
    t.string  "forma_platnosci",  :limit => 50,                 :null => false
    t.string  "miejsce_w",        :limit => 100
    t.integer "rabat",            :limit => 3,   :default => 0, :null => false
  end

  create_table "faktury", :force => true do |t|
    t.string  "nr_faktury",     :limit => 100, :null => false
    t.integer "id_towaru",      :limit => 5,   :null => false
    t.integer "f_ilosc_towaru", :limit => 100, :null => false
    t.string  "f_ctn",          :limit => 20,  :null => false
    t.integer "pod",            :limit => 10,  :null => false
    t.string  "f_wys_pod",      :limit => 100, :null => false
    t.string  "f_ctb",          :limit => 20,  :null => false
    t.string  "f_stb",          :limit => 20,  :null => false
    t.string  "created_on",     :limit => 40,  :null => false
    t.string  "updated_on",     :limit => 40,  :null => false
  end

  create_table "kontrahent", :force => true do |t|
    t.string    "nazwa",       :limit => 100,                       :null => false
    t.string    "nip",         :limit => 20,                        :null => false
    t.string    "ulica_nr",    :limit => 50,                        :null => false
    t.string    "kod",         :limit => 10,                        :null => false
    t.string    "miejscowosc", :limit => 40,                        :null => false
    t.string    "panstwo",     :limit => 20,  :default => "Polska", :null => false
    t.string    "osoba_up",    :limit => 100,                       :null => false
    t.timestamp "created_on",  :limit => 14,                        :null => false
    t.timestamp "updated_on",  :limit => 14,                        :null => false
    t.string    "regon",       :limit => 30
  end

  create_table "towar", :force => true do |t|
    t.string    "nazwa_towaru",   :limit => 50,                   :null => false
    t.string    "symbol_towaru",  :limit => 50,                   :null => false
    t.text      "opis_towaru",                                    :null => false
    t.integer   "ilosc_towaru",   :limit => 100, :default => 0,   :null => false
    t.string    "cena_netto",     :limit => 100, :default => "0", :null => false
    t.string    "podatek",        :limit => 20,  :default => "0", :null => false
    t.string    "cena_brutto",    :limit => 100, :default => "0", :null => false
    t.integer   "done",           :limit => 5,   :default => 0,   :null => false
    t.timestamp "created_on",     :limit => 14,                   :null => false
    t.timestamp "updated_on",     :limit => 14,                   :null => false
    t.string    "t_ilosc",        :limit => 20,  :default => "0", :null => false
    t.string    "t_cena",         :limit => 20,  :default => "0", :null => false
    t.string    "t_ord",          :limit => 20,  :default => "0", :null => false
    t.string    "t_pod",          :limit => 20,  :default => "e", :null => false
    t.integer   "t_ilosc_towaru", :limit => 100, :default => 0,   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
  end

  create_table "wystawca", :force => true do |t|
    t.string    "nazwa",       :limit => 100,                       :null => false
    t.string    "nip",         :limit => 20,                        :null => false
    t.string    "ulica_nr",    :limit => 50,                        :null => false
    t.string    "kod",         :limit => 10,                        :null => false
    t.string    "miejscowosc", :limit => 40,                        :null => false
    t.string    "panstwo",     :limit => 20,  :default => "Polska", :null => false
    t.string    "osoba_up",    :limit => 100,                       :null => false
    t.timestamp "created_on",  :limit => 14,                        :null => false
    t.timestamp "updated_on",  :limit => 14,                        :null => false
    t.string    "regon",       :limit => 20,                        :null => false
    t.string    "bank",        :limit => 100,                       :null => false
    t.string    "nr_konta",    :limit => 100, :default => "0",      :null => false
  end

end
