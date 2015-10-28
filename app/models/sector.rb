# == Schema Information
#
# Table name: sectors
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  oecd_dac_name         :string(255)
#  sector_vocab_code     :string(255)
#  oecd_dac_purpose_code :string(255)
#

class Sector < ActiveRecord::Base
  has_and_belongs_to_many :projects
  scope :active, -> {joins(:projects).where("projects.end_date > ? AND projects.start_date < ?", Date.today.to_s(:db), Date.today.to_s(:db)).uniq}
  def donors
    Project.active.joins([:sectors, :donors]).where(sectors: {id: self.id}).pluck('donors.id', 'donors.name').uniq
  end
  def self.counting_projects(options={})
    if options && options[:status] == 'active'
      # Sector.eager_load(:projects).select('sectors.id', 'sectors.name').group('sectors.id', 'sectors.name').order('sectors.name').where('(projects.end_date is null OR projects.end_date > now()) and (projects.start_date < now())').distinct.count('distinct(projects.id)')
      sql=%Q(
        WITH sp AS (
          SELECT DISTINCT COUNT(distinct(projects.id)) AS sp_count_distinct_projects_id, sectors.id AS sp_sectors_id, sectors.name AS sp_sectors_name FROM "sectors"
          LEFT JOIN "projects_sectors" ON "projects_sectors"."sector_id" = "sectors"."id"
          LEFT JOIN "projects" ON "projects"."id" = "projects_sectors"."project_id"
          WHERE (projects.end_date is null OR projects.end_date > now()) and (projects.start_date < now())
            GROUP BY sectors.id, sectors.name
            ), s as(
            SELECT sectors.id AS s_sectors_id, sectors.name AS s_sectors_name FROM "sectors"
            )
          select s.s_sectors_id AS id, s.s_sectors_name AS name, coalesce(sp.sp_count_distinct_projects_id, 0) AS count_distinct_projects_id FROM s
          LEFT JOIN sp ON sp.sp_sectors_id = s.s_sectors_id
          GROUP BY id, name, count_distinct_projects_id
          ORDER BY name
      )
      Sector.find_by_sql(sql)
    else
      Sector.eager_load(:projects).select('sectors.id', 'sectors.name').group('sectors.id', 'sectors.name').order('sectors.name').distinct.count('distinct(projects.id)')
    end
  end
  def self.fetch_all(options={})
    sectors = Sector.all
    sectors = sectors.active if options && options[:status] && options[:status] == 'active'
    sectors
  end
end
