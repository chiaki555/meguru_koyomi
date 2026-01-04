# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_22_114728) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "event_foods", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_event_foods_on_name", unique: true
  end

  create_table "event_template_foods", force: :cascade do |t|
    t.bigint "event_food_id", null: false
    t.bigint "event_template_id", null: false
    t.index ["event_food_id"], name: "index_event_template_foods_on_event_food_id"
    t.index ["event_template_id", "event_food_id"], name: "idx_on_event_template_id_event_food_id_ecdcf5819e", unique: true
    t.index ["event_template_id"], name: "index_event_template_foods_on_event_template_id"
  end

  create_table "event_template_spots", force: :cascade do |t|
    t.bigint "event_template_id", null: false
    t.bigint "recommended_spot_id", null: false
    t.index ["event_template_id", "recommended_spot_id"], name: "idx_on_event_template_id_recommended_spot_id_c32efd685e", unique: true
    t.index ["event_template_id"], name: "index_event_template_spots_on_event_template_id"
    t.index ["recommended_spot_id"], name: "index_event_template_spots_on_recommended_spot_id"
  end

  create_table "event_templates", force: :cascade do |t|
    t.integer "area_type"
    t.datetime "created_at", null: false
    t.integer "date_type"
    t.integer "day"
    t.text "description"
    t.integer "month"
    t.string "name"
    t.integer "source_type"
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "event_template_id", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["event_template_id"], name: "index_events_on_event_template_id"
  end

  create_table "recommended_spots", force: :cascade do |t|
    t.string "address"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["url"], name: "index_recommended_spots_on_url", unique: true
  end

  create_table "seasonal_bath_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "date_type"
    t.integer "day"
    t.text "description"
    t.integer "month"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "seasonal_baths", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date"
    t.bigint "seasonal_bath_template_id", null: false
    t.datetime "updated_at", null: false
    t.integer "year"
    t.index ["seasonal_bath_template_id"], name: "index_seasonal_baths_on_seasonal_bath_template_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "event_template_foods", "event_foods"
  add_foreign_key "event_template_foods", "event_templates"
  add_foreign_key "event_template_spots", "event_templates"
  add_foreign_key "event_template_spots", "recommended_spots"
  add_foreign_key "events", "event_templates"
  add_foreign_key "seasonal_baths", "seasonal_bath_templates"
end
