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

ActiveRecord::Schema.define(version: 20160822165723) do

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
    t.string   "what_type"
    t.boolean  "reviewed",         default: false
    t.string   "who_email"
    t.string   "who_organization"
  end

  add_index "changes_history_records", ["user_id", "what_type", "when"], name: "index_changes_history_records_on_user_id_and_what_type_and_when", using: :btree

  create_table "clusters", force: :cascade do |t|
    t.string "name"
  end

  create_table "clusters_projects", id: false, force: :cascade do |t|
    t.integer "cluster_id"
    t.integer "project_id"
  end

  add_index "clusters_projects", ["cluster_id"], name: "index_clusters_projects_on_cluster_id", using: :btree
  add_index "clusters_projects", ["project_id"], name: "index_clusters_projects_on_project_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.float    "center_lat"
    t.float    "center_lon"
    t.geometry "the_geom",         limit: {:srid=>4326, :type=>"multi_polygon"}
    t.string   "wiki_url"
    t.text     "wiki_description"
    t.string   "iso2_code"
    t.string   "iso3_code"
    t.text     "the_geom_geojson"
  end

  add_index "countries", ["the_geom"], name: "index_countries_on_the_geom", using: :gist

  create_table "countries_projects", id: false, force: :cascade do |t|
    t.integer "country_id"
    t.integer "project_id"
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

  add_index "data_denormalization", ["created_at"], name: "index_data_denormalization_on_created_at", using: :btree
  add_index "data_denormalization", ["is_active"], name: "index_data_denormalization_on_is_active", using: :btree
  add_index "data_denormalization", ["organization_id"], name: "index_data_denormalization_on_organization_id", using: :btree
  add_index "data_denormalization", ["project_id"], name: "index_data_denormalization_on_project_id", using: :btree
  add_index "data_denormalization", ["project_name"], name: "index_data_denormalization_on_project_name", using: :btree
  add_index "data_denormalization", ["site_id"], name: "index_data_denormalization_on_site_id", using: :btree

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
    t.string   "g1"
    t.string   "g2"
    t.string   "g3"
    t.string   "g4"
    t.string   "provider",          default: "Geonames"
    t.integer  "adm_level"
    t.string   "custom_geo_source"
    t.string   "string"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "g0"
  end

  add_index "geolocations", ["country_name"], name: "index_geolocations_on_country_name", using: :btree
  add_index "geolocations", ["country_uid"], name: "index_geolocations_on_country_uid", using: :btree
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

  create_table "layer_styles", force: :cascade do |t|
    t.string "title"
    t.string "name"
  end

  create_table "layers", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "credits"
    t.datetime "date"
    t.float    "min"
    t.float    "max"
    t.string   "units"
    t.boolean  "status"
    t.string   "cartodb_table"
    t.text     "sql"
    t.string   "long_title"
  end

  create_table "media_resources", force: :cascade do |t|
    t.integer  "position",                 default: 0
    t.integer  "element_id"
    t.integer  "element_type"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_filesize"
    t.datetime "picture_updated_at"
    t.string   "video_url"
    t.text     "video_embed_html"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption"
    t.string   "video_thumb_file_name"
    t.string   "video_thumb_content_type"
    t.integer  "video_thumb_file_size"
    t.datetime "video_thumb_updated_at"
  end

  add_index "media_resources", ["element_type", "element_id"], name: "index_media_resources_on_element_type_and_element_id", using: :btree

  create_table "offices", force: :cascade do |t|
    t.integer  "organization_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.float    "budget"
    t.string   "website"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "hq_address"
    t.string   "contact_email"
    t.string   "contact_phone_number"
    t.string   "donation_address"
    t.string   "zip_code"
    t.string   "city"
    t.string   "state"
    t.string   "donation_phone_number"
    t.string   "donation_website"
    t.text     "site_specific_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "contact_name"
    t.string   "contact_position"
    t.string   "contact_zip"
    t.string   "contact_city"
    t.string   "contact_state"
    t.string   "contact_country"
    t.string   "donation_country"
    t.string   "media_contact_name"
    t.string   "media_contact_position"
    t.string   "media_contact_phone_number"
    t.string   "media_contact_email"
    t.string   "main_data_contact_name"
    t.string   "main_data_contact_position"
    t.string   "main_data_contact_phone_number"
    t.string   "main_data_contact_email"
    t.string   "main_data_contact_zip"
    t.string   "main_data_contact_city"
    t.string   "main_data_contact_state"
    t.string   "main_data_contact_country"
    t.string   "organization_id"
    t.string   "organization_type"
    t.integer  "organization_type_code"
    t.string   "iati_organizationid"
    t.boolean  "publishing_to_iati",             default: false
    t.string   "membership_status",              default: "Non Member"
    t.integer  "old_donor_id"
  end

  add_index "organizations", ["name"], name: "index_organizations_on_name", using: :btree

  create_table "organizations_projects", id: false, force: :cascade do |t|
    t.integer "organization_id"
    t.integer "project_id"
  end

  add_index "organizations_projects", ["organization_id"], name: "index_organizations_projects_on_organization_id", using: :btree
  add_index "organizations_projects", ["project_id"], name: "index_organizations_projects_on_project_id", using: :btree

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "site_id"
    t.boolean  "published"
    t.string   "permalink"
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
    t.string   "name"
    t.string   "url"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "label"
  end

  add_index "partners", ["site_id"], name: "index_partners_on_site_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",                                    limit: 2000
    t.text     "description"
    t.integer  "primary_organization_id"
    t.text     "implementing_organization"
    t.text     "partner_organizations"
    t.text     "cross_cutting_issues"
    t.geometry "the_geom",                                limit: {:srid=>4326, :type=>"geometry"}
    t.date     "start_date"
    t.date     "end_date"
    t.float    "budget"
    t.text     "target"
    t.integer  "estimated_people_reached",                limit: 8
    t.string   "contact_person"
    t.string   "contact_email"
    t.string   "contact_phone_number"
    t.text     "site_specific_information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "activities"
    t.string   "intervention_id"
    t.text     "additional_information"
    t.string   "awardee_type"
    t.date     "date_provided"
    t.date     "date_updated"
    t.string   "contact_position"
    t.string   "website"
    t.text     "verbatim_location"
    t.text     "calculation_of_number_of_people_reached"
    t.text     "project_needs"
    t.text     "idprefugee_camp"
    t.string   "organization_id"
    t.string   "budget_currency",                                                                  default: "USD"
    t.date     "budget_value_date"
    t.float    "target_project_reach"
    t.float    "actual_project_reach"
    t.string   "project_reach_unit"
    t.integer  "prime_awardee_id"
    t.string   "geographical_scope",                                                               default: "regional"
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
    t.string   "name"
    t.integer  "level"
    t.integer  "country_id"
    t.integer  "parent_region_id"
    t.float    "center_lat"
    t.float    "center_lon"
    t.string   "path"
    t.geometry "the_geom",         limit: {:srid=>4326, :type=>"geometry"}
    t.integer  "gadm_id"
    t.string   "wiki_url"
    t.text     "wiki_description"
    t.string   "code"
    t.text     "the_geom_geojson"
    t.text     "ia_name"
  end

  add_index "regions", ["country_id"], name: "index_regions_on_country_id", using: :btree
  add_index "regions", ["level"], name: "index_regions_on_level", using: :btree
  add_index "regions", ["parent_region_id"], name: "index_regions_on_parent_region_id", using: :btree
  add_index "regions", ["the_geom"], name: "index_regions_on_the_geom", using: :gist

  create_table "resources", force: :cascade do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "element_id"
    t.integer  "element_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "site_specific_information"
  end

  add_index "resources", ["element_type", "element_id"], name: "index_resources_on_element_type_and_element_id", using: :btree

  create_table "sectors", force: :cascade do |t|
    t.string   "name"
    t.string   "oecd_dac_name"
    t.string   "sector_vocab_code"
    t.string   "oecd_dac_purpose_code"
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
    t.string   "name"
    t.text     "short_description"
    t.text     "long_description"
    t.string   "contact_email"
    t.string   "contact_person"
    t.string   "url"
    t.string   "permalink"
    t.string   "google_analytics_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "theme_id"
    t.string   "blog_url"
    t.string   "word_for_clusters"
    t.string   "word_for_regions"
    t.boolean  "show_global_donations_raises",                                             default: false
    t.integer  "project_classification",                                                   default: 0
    t.string   "geographic_context_country_id"
    t.integer  "geographic_context_region_id"
    t.geometry "geographic_context_geometry",     limit: {:srid=>4326, :type=>"geometry"}
    t.integer  "project_context_cluster_id"
    t.integer  "project_context_sector_id"
    t.integer  "project_context_organization_id"
    t.string   "project_context_tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "project_context_tags_ids"
    t.boolean  "status",                                                                   default: false
    t.float    "visits",                                                                   default: 0.0
    t.float    "visits_last_week",                                                         default: 0.0
    t.string   "aid_map_image_file_name"
    t.string   "aid_map_image_content_type"
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
    t.string  "name"
    t.integer "count", default: 0
  end

  create_table "themes", force: :cascade do |t|
    t.string "name"
    t.string "css_file"
    t.string "thumbnail_path"
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
    t.string   "role"
    t.boolean  "blocked",                                            default: false
    t.string   "site_id"
    t.text     "description"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "last_login"
    t.boolean  "six_months_since_last_login_alert_sent",             default: false
    t.integer  "login_fails",                                        default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree

end
