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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160919043100) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "changes_history_records", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "when"
    t.text     "how"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "what_id"
    t.string   "what_type",        limit: 255
    t.boolean  "reviewed",                     default: false
    t.string   "who_email",        limit: 255
    t.string   "who_organization", limit: 255
  end

  add_index "changes_history_records", ["user_id", "what_type", "when"], name: "index_changes_history_records_on_user_id_and_what_type_and_when", using: :btree

  create_table "changes_history_records_copy", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "when"
    t.text     "how"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "what_id"
    t.string   "what_type",        limit: 255
    t.boolean  "reviewed"
    t.string   "who_email",        limit: 255
    t.string   "who_organization", limit: 255
  end

  create_table "clusters", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "clusters_projects", id: false, force: :cascade do |t|
    t.integer "cluster_id"
    t.integer "project_id"
  end

  add_index "clusters_projects", ["cluster_id"], name: "index_clusters_projects_on_cluster_id", using: :btree
  add_index "clusters_projects", ["project_id"], name: "index_clusters_projects_on_project_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "code",             limit: 255
    t.geometry "the_geom",         limit: {:srid=>4326, :type=>"multi_polygon"}
    t.string   "wiki_url",         limit: 255
    t.text     "wiki_description"
    t.string   "iso2_code",        limit: 255
    t.string   "iso3_code",        limit: 255
    t.float    "center_lat"
    t.float    "center_lon"
    t.text     "the_geom_geojson"
  end

  add_index "countries", ["the_geom"], name: "index_countries_on_the_geom", using: :gist

  create_table "countries_projects", id: false, force: :cascade do |t|
    t.integer "country_id", null: false
    t.integer "project_id", null: false
  end

  add_index "countries_projects", ["country_id"], name: "index_countries_projects_on_country_id", using: :btree
  add_index "countries_projects", ["project_id"], name: "index_countries_projects_on_project_id", using: :btree

  create_table "data_denormalization", id: false, force: :cascade do |t|
    t.integer  "project_id"
    t.string   "project_name",        limit: 2000
    t.text     "project_description"
    t.integer  "organization_id"
    t.string   "organization_name",   limit: 2000
    t.date     "end_date"
    t.text     "regions"
    t.integer  "regions_ids",                      array: true
    t.text     "countries"
    t.integer  "countries_ids",                    array: true
    t.text     "sectors"
    t.integer  "sector_ids",                       array: true
    t.text     "clusters"
    t.integer  "cluster_ids",                      array: true
    t.integer  "donors_ids",                       array: true
    t.boolean  "is_active"
    t.integer  "site_id"
    t.datetime "created_at"
    t.date     "start_date"
  end

  add_index "data_denormalization", ["cluster_ids"], name: "data_denormalization_cluster_idsx", using: :gist
  add_index "data_denormalization", ["countries_ids"], name: "data_denormalization_countries_idsx", using: :gist
  add_index "data_denormalization", ["donors_ids"], name: "data_denormalization_donors_idsx", using: :gist
  add_index "data_denormalization", ["is_active"], name: "data_denormalization_is_activex", using: :btree
  add_index "data_denormalization", ["organization_id"], name: "data_denormalization_organization_idx", using: :btree
  add_index "data_denormalization", ["organization_name"], name: "data_denormalization_organization_namex", using: :btree
  add_index "data_denormalization", ["project_id"], name: "data_denormalization_project_idx", using: :btree
  add_index "data_denormalization", ["project_name"], name: "data_denormalization_project_name_idx", using: :btree
  add_index "data_denormalization", ["regions_ids"], name: "data_denormalization_regions_idsx", using: :gist
  add_index "data_denormalization", ["sector_ids"], name: "data_denormalization_sector_idsx", using: :gist
  add_index "data_denormalization", ["site_id"], name: "data_denormalization_site_idx", using: :btree

  create_table "data_export", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.string  "project_name",                            limit: 2000
    t.text    "project_description"
    t.integer "organization_id"
    t.string  "organization_name",                       limit: 2000
    t.text    "implementing_organization"
    t.text    "partner_organizations"
    t.text    "cross_cutting_issues"
    t.date    "start_date"
    t.date    "end_date"
    t.float   "budget"
    t.text    "target"
    t.integer "estimated_people_reached",                limit: 8
    t.string  "project_contact_person",                  limit: 255
    t.string  "project_contact_email",                   limit: 255
    t.string  "project_contact_phone_number",            limit: 255
    t.text    "activities"
    t.string  "intervention_id",                         limit: 255
    t.text    "additional_information"
    t.string  "awardee_type",                            limit: 255
    t.date    "date_provided"
    t.date    "date_updated"
    t.string  "project_contact_position",                limit: 255
    t.string  "project_website",                         limit: 255
    t.text    "verbatim_location"
    t.text    "calculation_of_number_of_people_reached"
    t.text    "project_needs"
    t.text    "sectors"
    t.text    "clusters"
    t.text    "project_tags"
    t.text    "countries"
    t.text    "regions_level1"
    t.text    "regions_level2"
    t.text    "regions_level3"
  end

  create_table "donations", force: :cascade do |t|
    t.integer "donor_id"
    t.integer "project_id"
    t.float   "amount"
    t.date    "date"
    t.integer "office_id"
  end

  add_index "donations", ["donor_id"], name: "index_donations_on_donor_id", using: :btree
  add_index "donations", ["project_id"], name: "index_donations_on_project_id", using: :btree

  create_table "geolocations", force: :cascade do |t|
    t.string   "uid"
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "fclass"
    t.string   "fcode"
    t.string   "country_code"
    t.string   "country_name"
    t.string   "country_uid"
    t.string   "cc2"
    t.string   "admin1"
    t.string   "admin2"
    t.string   "admin3"
    t.string   "admin4"
    t.string   "provider",          default: "Geonames"
    t.integer  "adm_level"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "g0"
    t.string   "g1"
    t.string   "g2"
    t.string   "g3"
    t.string   "g4"
    t.string   "custom_geo_source"
  end

  add_index "geolocations", ["country_code"], name: "index_geolocations_on_country_code", using: :btree
  add_index "geolocations", ["country_name"], name: "index_geolocations_on_country_name", using: :btree
  add_index "geolocations", ["g0"], name: "index_geolocations_on_g0", using: :btree
  add_index "geolocations", ["g1"], name: "index_geolocations_on_g1", using: :btree
  add_index "geolocations", ["g2"], name: "index_geolocations_on_g2", using: :btree
  add_index "geolocations", ["g3"], name: "index_geolocations_on_g3", using: :btree
  add_index "geolocations", ["g4"], name: "index_geolocations_on_g4", using: :btree
  add_index "geolocations", ["uid"], name: "index_geolocations_on_uid", using: :btree

  create_table "geolocations_projects", id: false, force: :cascade do |t|
    t.integer "geolocation_id"
    t.integer "project_id"
  end

  add_index "geolocations_projects", ["geolocation_id", "project_id"], name: "index_geolocations_projects_on_geolocation_id_and_project_id", using: :btree
  add_index "geolocations_projects", ["project_id"], name: "index_geolocations_projects_on_project_id", using: :btree

  create_table "implementer_partnerships", force: :cascade do |t|
    t.integer  "project_id",     null: false
    t.integer  "implementer_id", null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "layer_styles", force: :cascade do |t|
    t.string "title", limit: 255
    t.string "name",  limit: 255
  end

  create_table "layers", force: :cascade do |t|
    t.string   "title",         limit: 255
    t.text     "description"
    t.text     "credits"
    t.datetime "date"
    t.float    "min"
    t.float    "max"
    t.string   "units",         limit: 255
    t.boolean  "status"
    t.string   "cartodb_table", limit: 255
    t.text     "sql"
    t.string   "long_title",    limit: 255
  end

  create_table "media_resources", force: :cascade do |t|
    t.integer  "position",                             default: 0
    t.integer  "element_id"
    t.integer  "element_type"
    t.string   "picture_file_name",        limit: 255
    t.string   "picture_content_type",     limit: 255
    t.integer  "picture_filesize"
    t.datetime "picture_updated_at"
    t.string   "video_url",                limit: 255
    t.text     "video_embed_html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption",                  limit: 255
    t.string   "video_thumb_file_name",    limit: 255
    t.string   "video_thumb_content_type", limit: 255
    t.integer  "video_thumb_file_size"
    t.datetime "video_thumb_updated_at"
    t.string   "external_image_url"
  end

  add_index "media_resources", ["element_type", "element_id"], name: "index_media_resources_on_element_type_and_element_id", using: :btree

  create_table "offices", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "name",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",                           limit: 255
    t.text     "description"
    t.float    "budget"
    t.string   "website",                        limit: 255
    t.string   "twitter",                        limit: 255
    t.string   "facebook",                       limit: 255
    t.string   "hq_address",                     limit: 255
    t.string   "contact_email",                  limit: 255
    t.string   "contact_phone_number",           limit: 255
    t.string   "donation_address",               limit: 255
    t.string   "zip_code",                       limit: 255
    t.string   "city",                           limit: 255
    t.string   "state",                          limit: 255
    t.string   "donation_phone_number",          limit: 255
    t.string   "donation_website",               limit: 255
    t.text     "site_specific_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",                 limit: 255
    t.string   "logo_content_type",              limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "contact_name",                   limit: 255
    t.string   "contact_position",               limit: 255
    t.string   "contact_zip",                    limit: 255
    t.string   "contact_city",                   limit: 255
    t.string   "contact_state",                  limit: 255
    t.string   "contact_country",                limit: 255
    t.string   "donation_country",               limit: 255
    t.string   "media_contact_name",             limit: 255
    t.string   "media_contact_position",         limit: 255
    t.string   "media_contact_phone_number",     limit: 255
    t.string   "media_contact_email",            limit: 255
    t.string   "main_data_contact_name",         limit: 255
    t.string   "main_data_contact_position",     limit: 255
    t.string   "main_data_contact_phone_number", limit: 255
    t.string   "main_data_contact_email",        limit: 255
    t.string   "main_data_contact_zip",          limit: 255
    t.string   "main_data_contact_city",         limit: 255
    t.string   "main_data_contact_state",        limit: 255
    t.string   "main_data_contact_country",      limit: 255
    t.string   "organization_id",                limit: 255
    t.string   "organization_type",              limit: 255
    t.integer  "organization_type_code"
    t.string   "iati_organizationid",            limit: 255
    t.boolean  "publishing_to_iati",                                                  default: false
    t.string   "membership_status",              limit: 255,                          default: "Non Member"
    t.integer  "old_donor_id"
    t.boolean  "international"
    t.string   "acronym"
    t.date     "membership_add_date"
    t.date     "membership_drop_date"
    t.string   "budget_currency"
    t.decimal  "budget_usd",                                 precision: 13, scale: 2
    t.date     "budget_fiscal_year"
    t.string   "hq_address2"
    t.string   "donation_address2"
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", using: :btree

  create_table "organizations2", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.text     "description"
    t.float    "budget"
    t.string   "website",                         limit: 255
    t.integer  "national_staff"
    t.string   "twitter",                         limit: 255
    t.string   "facebook",                        limit: 255
    t.string   "hq_address",                      limit: 255
    t.string   "contact_email",                   limit: 255
    t.string   "contact_phone_number",            limit: 255
    t.string   "donation_address",                limit: 255
    t.string   "zip_code",                        limit: 255
    t.string   "city",                            limit: 255
    t.string   "state",                           limit: 255
    t.string   "donation_phone_number",           limit: 255
    t.string   "donation_website",                limit: 255
    t.text     "site_specific_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name",                  limit: 255
    t.string   "logo_content_type",               limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "international_staff",             limit: 255
    t.string   "contact_name",                    limit: 255
    t.string   "contact_position",                limit: 255
    t.string   "contact_zip",                     limit: 255
    t.string   "contact_city",                    limit: 255
    t.string   "contact_state",                   limit: 255
    t.string   "contact_country",                 limit: 255
    t.string   "donation_country",                limit: 255
    t.integer  "estimated_people_reached"
    t.float    "private_funding"
    t.float    "usg_funding"
    t.float    "other_funding"
    t.float    "private_funding_spent"
    t.float    "usg_funding_spent"
    t.float    "other_funding_spent"
    t.float    "spent_funding_on_relief"
    t.float    "spent_funding_on_reconstruction"
    t.integer  "percen_relief"
    t.integer  "percen_reconstruction"
    t.string   "media_contact_name",              limit: 255
    t.string   "media_contact_position",          limit: 255
    t.string   "media_contact_phone_number",      limit: 255
    t.string   "media_contact_email",             limit: 255
  end

  add_index "organizations2", ["name"], name: "index_organizations2_on_name", using: :btree

  create_table "organizations_projects", id: false, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "project_id"
  end

  add_index "organizations_projects", ["organization_id"], name: "index_organizations_projects_on_organization_id", using: :btree
  add_index "organizations_projects", ["project_id"], name: "index_organizations_projects_on_project_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.text     "body"
    t.integer  "site_id"
    t.boolean  "published"
    t.string   "permalink",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "order_index"
  end

  add_index "pages", ["parent_id"], name: "index_pages_on_parent_id", using: :btree
  add_index "pages", ["permalink"], name: "index_pages_on_permalink", using: :btree
  add_index "pages", ["site_id"], name: "index_pages_on_site_id", using: :btree

  create_table "partners", force: :cascade do |t|
    t.integer  "site_id"
    t.string   "name",              limit: 255
    t.string   "url",               limit: 255
    t.string   "logo_file_name",    limit: 255
    t.string   "logo_content_type", limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label",             limit: 255
  end

  add_index "partners", ["site_id"], name: "index_partners_on_site_id", using: :btree

  create_table "partnerships", force: :cascade do |t|
    t.integer  "partner_id", null: false
    t.integer  "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",                                    limit: 2000
    t.text     "description"
    t.integer  "primary_organization_id"
    t.text     "implementing_organization"
    t.text     "partner_organizations"
    t.text     "cross_cutting_issues"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "budget"
    t.text     "target"
    t.integer  "estimated_people_reached",                limit: 8
    t.string   "contact_person",                          limit: 255
    t.string   "contact_email",                           limit: 255
    t.string   "contact_phone_number",                    limit: 255
    t.text     "site_specific_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "the_geom",                                limit: {:srid=>4326, :type=>"geometry"}
    t.text     "activities"
    t.string   "intervention_id",                         limit: 255
    t.text     "additional_information"
    t.string   "awardee_type",                            limit: 255
    t.date     "date_provided"
    t.date     "date_updated"
    t.string   "contact_position",                        limit: 255
    t.string   "website",                                 limit: 255
    t.text     "verbatim_location"
    t.text     "calculation_of_number_of_people_reached"
    t.text     "project_needs"
    t.text     "idprefugee_camp"
    t.string   "organization_id",                         limit: 255
    t.string   "budget_currency",                         limit: 255,                                                       default: "USD"
    t.date     "budget_value_date"
    t.float    "target_project_reach"
    t.float    "actual_project_reach"
    t.string   "project_reach_unit",                      limit: 255,                                                       default: "individuals"
    t.integer  "prime_awardee_id"
    t.string   "geographical_scope",                      limit: 255,                                                       default: "regional"
    t.decimal  "budget_usd",                                                                       precision: 13, scale: 2
  end

  add_index "projects", ["end_date"], name: "index_projects_on_end_date", using: :btree
  add_index "projects", ["name"], name: "index_projects_on_name", using: :btree
  add_index "projects", ["primary_organization_id"], name: "index_projects_on_primary_organization_id", using: :btree
  add_index "projects", ["prime_awardee_id"], name: "index_projects_on_prime_awardee_id", using: :btree
  add_index "projects", ["the_geom"], name: "index_projects_on_the_geom", using: :gist

  create_table "projects_regions", id: false, force: :cascade do |t|
    t.integer "region_id"
    t.integer "project_id"
  end

  add_index "projects_regions", ["project_id"], name: "index_projects_regions_on_project_id", using: :btree
  add_index "projects_regions", ["region_id"], name: "index_projects_regions_on_region_id", using: :btree

  create_table "projects_sectors", id: false, force: :cascade do |t|
    t.integer "sector_id"
    t.integer "project_id"
  end

  add_index "projects_sectors", ["project_id"], name: "index_projects_sectors_on_project_id", using: :btree
  add_index "projects_sectors", ["sector_id"], name: "index_projects_sectors_on_sector_id", using: :btree

  create_table "projects_sites", id: false, force: :cascade do |t|
    t.integer "project_id"
    t.integer "site_id"
  end

  add_index "projects_sites", ["project_id", "site_id"], name: "index_projects_sites_on_project_id_and_site_id", unique: true, using: :btree
  add_index "projects_sites", ["project_id"], name: "index_projects_sites_on_project_id", using: :btree
  add_index "projects_sites", ["site_id"], name: "index_projects_sites_on_site_id", using: :btree

  create_table "projects_synchronizations", force: :cascade do |t|
    t.text     "projects_file_data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects_tags", id: false, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "project_id"
  end

  add_index "projects_tags", ["project_id"], name: "index_projects_tags_on_project_id", using: :btree
  add_index "projects_tags", ["tag_id"], name: "index_projects_tags_on_tag_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.integer  "level"
    t.integer  "country_id"
    t.integer  "parent_region_id"
    t.geometry "the_geom",         limit: {:srid=>4326, :type=>"geometry"}
    t.integer  "gadm_id"
    t.string   "wiki_url",         limit: 255
    t.text     "wiki_description"
    t.string   "code",             limit: 255
    t.float    "center_lat"
    t.float    "center_lon"
    t.text     "the_geom_geojson"
    t.text     "ia_name"
    t.string   "path",             limit: 255
  end

  add_index "regions", ["country_id"], name: "index_regions_on_country_id", using: :btree
  add_index "regions", ["level"], name: "index_regions_on_level", using: :btree
  add_index "regions", ["parent_region_id"], name: "index_regions_on_parent_region_id", using: :btree
  add_index "regions", ["the_geom"], name: "index_regions_on_the_geom", using: :gist

  create_table "resources", force: :cascade do |t|
    t.string   "title",                     limit: 255
    t.string   "url",                       limit: 255
    t.integer  "element_id"
    t.integer  "element_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "site_specific_information"
  end

  add_index "resources", ["element_type", "element_id"], name: "index_resources_on_element_type_and_element_id", using: :btree

  create_table "sectors", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.string   "oecd_dac_name",         limit: 255
    t.string   "oecd_dac_purpose_code", limit: 255
    t.string   "oec_dac_name",          limit: 255
    t.string   "sector_vocab_code",     limit: 255
    t.string   "oec_dac_purpose_code",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: :cascade do |t|
    t.text "data"
  end

  create_table "site_layers", id: false, force: :cascade do |t|
    t.integer "site_id"
    t.integer "layer_id"
    t.integer "layer_style_id"
  end

  add_index "site_layers", ["layer_id"], name: "index_site_layers_on_layer_id", using: :btree
  add_index "site_layers", ["layer_style_id"], name: "index_site_layers_on_layer_style_id", using: :btree
  add_index "site_layers", ["site_id"], name: "index_site_layers_on_site_id", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "name",                            limit: 255
    t.text     "short_description"
    t.text     "long_description"
    t.string   "contact_email",                   limit: 255
    t.string   "contact_person",                  limit: 255
    t.string   "url",                             limit: 255
    t.string   "permalink",                       limit: 255
    t.string   "google_analytics_id",             limit: 255
    t.string   "logo_file_name",                  limit: 255
    t.string   "logo_content_type",               limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "theme_id"
    t.string   "blog_url",                        limit: 255
    t.string   "word_for_clusters",               limit: 255
    t.string   "word_for_regions",                limit: 255
    t.boolean  "show_global_donations_raises",                                             default: false
    t.integer  "project_classification",                                                   default: 0
    t.string   "geographic_context_country_id"
    t.integer  "geographic_context_region_id"
    t.integer  "project_context_cluster_id"
    t.integer  "project_context_sector_id"
    t.integer  "project_context_organization_id"
    t.string   "project_context_tags",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "geographic_context_geometry",     limit: {:srid=>4326, :type=>"geometry"}
    t.string   "project_context_tags_ids",        limit: 255
    t.boolean  "status",                                                                   default: false
    t.float    "visits",                                                                   default: 0.0
    t.float    "visits_last_week",                                                         default: 0.0
    t.string   "aid_map_image_file_name",         limit: 255
    t.string   "aid_map_image_content_type",      limit: 255
    t.integer  "aid_map_image_file_size"
    t.datetime "aid_map_image_updated_at"
    t.boolean  "navigate_by_country",                                                      default: false
    t.boolean  "navigate_by_level1",                                                       default: false
    t.boolean  "navigate_by_level2",                                                       default: false
    t.boolean  "navigate_by_level3",                                                       default: false
    t.text     "map_styles"
    t.float    "overview_map_lat"
    t.float    "overview_map_lon"
    t.integer  "overview_map_zoom"
    t.text     "internal_description"
    t.boolean  "featured",                                                                 default: false
  end

  add_index "sites", ["geographic_context_geometry"], name: "index_sites_on_geographic_context_geometry", using: :gist
  add_index "sites", ["name"], name: "index_sites_on_name", using: :btree
  add_index "sites", ["status"], name: "index_sites_on_status", using: :btree
  add_index "sites", ["url"], name: "index_sites_on_url", using: :btree

  create_table "stats", force: :cascade do |t|
    t.integer "site_id"
    t.integer "visits"
    t.date    "date"
  end

  add_index "stats", ["site_id"], name: "index_stats_on_site_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",  limit: 255
    t.integer "count",             default: 0
  end

  create_table "themes", force: :cascade do |t|
    t.string "name",           limit: 255
    t.string "css_file",       limit: 255
    t.string "thumbnail_path", limit: 255
    t.text   "data"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                                   limit: 100, default: ""
    t.string   "email",                                  limit: 100
    t.string   "crypted_password",                       limit: 40
    t.string   "salt",                                   limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",                         limit: 40
    t.datetime "remember_token_expires_at"
    t.integer  "organization_id"
    t.string   "role",                                   limit: 255
    t.boolean  "blocked",                                            default: false
    t.string   "site_id",                                limit: 255
    t.text     "description"
    t.string   "password_reset_token",                   limit: 255
    t.datetime "password_reset_sent_at"
    t.datetime "last_login"
    t.boolean  "six_months_since_last_login_alert_sent",             default: false
    t.integer  "login_fails",                                        default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

  add_foreign_key "projects_regions", "regions", name: "region_id_fk"
end
