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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_24_135853) do

  create_table "contributors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "package_id"
    t.bigint "person_id"
    t.integer "position"
    t.string "role"
    t.text "comment"
    t.boolean "maintainer", default: false
    t.string "name"
    t.index ["maintainer"], name: "index_contributors_on_maintainer"
    t.index ["package_id"], name: "index_contributors_on_package_id"
    t.index ["person_id"], name: "index_contributors_on_person_id"
  end

  create_table "packages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "version"
    t.datetime "published_at"
    t.text "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "description_parsed"
    t.text "raw_description"
    t.boolean "author_with_errors", default: false
    t.boolean "maintainer_with_errors", default: false
    t.text "packages_depends"
    t.text "packages_suggests"
    t.text "packages_imports"
    t.text "packages_enhances"
    t.text "packages_linking_to"
    t.string "packages_priority"
    t.string "packages_license"
    t.string "packages_license_restricts_use"
    t.string "packages_license_is_foss"
    t.string "packages_needs_compilation"
    t.string "packages_os_type"
    t.string "packages_archs"
    t.string "packages_md5sum"
    t.string "packages_path"
    t.text "packages_content"
    t.boolean "packages_has_new_field", default: false
  end

  create_table "people", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "email"
  end

end
