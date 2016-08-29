class MoveDonorsToOrgs < ActiveRecord::Migration
  def change
    add_column :organizations, :old_donor_id, :integer
    remove_column :organizations, :estimated_people_reached, :integer
    remove_column :organizations, :interaction_member, :boolean, default: false
    remove_column :organizations, :international_staff, :string
    remove_column :organizations, :national_staff, :integer
    remove_column :organizations, :other_funding, :float
    remove_column :organizations, :other_funding_spent, :float
    remove_column :organizations, :percen_reconstruction, :integer
    remove_column :organizations, :percen_relief, :integer
    remove_column :organizations, :private_funding, :float
    remove_column :organizations, :private_funding_spent, :float
    remove_column :organizations, :spent_funding_on_reconstruction, :float
    remove_column :organizations, :spent_funding_on_relief, :float
    remove_column :organizations, :usg_funding, :float
    remove_column :organizations, :usg_funding_spent, :float
    rename_column :offices, :donor_id, :organization_id

    reversible do |dir|
      dir.up do
        execute <<-SQL
          INSERT INTO organizations (contact_email, contact_name, contact_phone_number,
            contact_position, created_at, description, facebook, iati_organizationid,
            logo_content_type, logo_file_name, logo_file_size, logo_updated_at,
            name, organization_type, organization_type_code, site_specific_information, twitter,
            updated_at, website, old_donor_id)
          SELECT contact_email, contact_person_name, contact_phone_number,
            contact_person_position, created_at, description, facebook, iati_organizationid,
            logo_content_type, logo_file_name, logo_file_size, logo_updated_at,
            name, organization_type, organization_type_code, site_specific_information, twitter,
            updated_at, website, donors.id
          FROM donors
        SQL

        execute <<-SQL
          UPDATE donations
          SET donor_id = organizations.id
          FROM organizations
          WHERE donations.donor_id IS NOT NULL
            AND organizations.old_donor_id IS NOT NULL
            AND donations.donor_id = organizations.old_donor_id
        SQL

        execute <<-SQL
          UPDATE offices
          SET organization_id = organizations.id
          FROM organizations
          WHERE offices.organization_id IS NOT NULL
            AND organizations.old_donor_id IS NOT NULL
            AND offices.organization_id = organizations.old_donor_id
        SQL
      end
      dir.down do
        execute <<-SQL
          UPDATE offices
          SET organization_id = organizations.old_donor_id
          FROM organizations
          where offices.organization_id IS NOT NULL
            AND organizations.old_donor_id IS NOT NULL
            AND offices.organization_id = organizations.id
        SQL

        execute <<-SQL
          UPDATE donations
          SET donor_id = organizations.old_donor_id
          FROM organizations
          where donations.donor_id IS NOT NULL
            AND organizations.old_donor_id IS NOT NULL
            AND donations.donor_id = organizations.id
        SQL

        execute <<-SQL
          INSERT INTO donors (contact_email, contact_person_name, contact_phone_number, contact_person_position,
            created_at, description, facebook, iati_organizationid, logo_content_type,
            logo_file_name, logo_file_size, logo_updated_at, name, organization_type,
            organization_type_code, site_specific_information, twitter, updated_at,
            website, id)
          SELECT contact_email, contact_name, contact_phone_number,
            contact_position, created_at, description, facebook, iati_organizationid,
            logo_content_type, logo_file_name, logo_file_size, logo_updated_at,
            name, organization_type, organization_type_code, site_specific_information, twitter,
            updated_at, website, old_donor_id
          FROM organizations
          WHERE organizations.old_donor_id IS NOT NULL
        SQL
      end
    end

    drop_table :donors do |t|
      t.string   "name"
      t.text     "description"
      t.string   "website"
      t.string   "twitter"
      t.string   "facebook"
      t.string   "contact_person_name"
      t.string   "contact_company"
      t.string   "contact_person_position"
      t.string   "contact_email"
      t.string   "contact_phone_number"
      t.string   "logo_file_name"
      t.string   "logo_content_type"
      t.integer  "logo_file_size"
      t.datetime "logo_updated_at"
      t.text     "site_specific_information"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "iati_organizationid"
      t.string   "organization_type"
      t.integer  "organization_type_code"
    end
  end
end
