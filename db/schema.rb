# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130219165633) do

  create_table "geometry_columns", :id => false, :force => true do |t|
    t.string  "f_table_catalog",   :limit => 256, :null => false
    t.string  "f_table_schema",    :limit => 256, :null => false
    t.string  "f_table_name",      :limit => 256, :null => false
    t.string  "f_geometry_column", :limit => 256, :null => false
    t.integer "coord_dimension",                  :null => false
    t.integer "srid",                             :null => false
    t.string  "type",              :limit => 30,  :null => false
  end

  create_table "group_roles", :force => true do |t|
    t.integer  "group_id"
    t.integer  "role_id"
    t.string   "groupname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "group_roles", ["group_id", "role_id"], :name => "index_group_roles_on_group_id_and_role_id", :unique => true
  add_index "group_roles", ["groupname", "role_id"], :name => "index_group_roles_on_groupname_and_role_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "description"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "enabled",     :default => true
  end

  add_index "groups", ["name"], :name => "index_groups_on_name", :unique => true

  create_table "role_props", :force => true do |t|
    t.integer  "role_id"
    t.string   "rolename",   :null => false
    t.string   "propname",   :null => false
    t.string   "propvalue",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "role_props", ["role_id"], :name => "index_role_props_on_role_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.string   "description"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "parent"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
  end

  create_table "user_props", :force => true do |t|
    t.integer  "user_id"
    t.string   "username"
    t.string   "propname",   :null => false
    t.string   "propvalue",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_props", ["user_id"], :name => "index_user_props_on_user_id"

  create_table "user_roles", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.string  "username", :null => false
  end

  add_index "user_roles", ["user_id", "role_id"], :name => "index_user_roles_on_user_id_and_role_id"
  add_index "user_roles", ["username", "role_id"], :name => "index_user_roles_on_username_and_role_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "username",                                 :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "email",                  :default => "",   :null => false
    t.string   "encrypted_password",     :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.boolean  "enabled",                :default => true
    t.string   "remember_token"
    t.string   "invitation_token"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "users_groups", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  add_index "users_groups", ["user_id", "group_id"], :name => "index_users_groups_on_user_id_and_group_id"

end
