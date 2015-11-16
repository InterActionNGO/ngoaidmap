# == Schema Information
#
# Table name: projects
#
#  id                                      :integer          not null, primary key
#  name                                    :string(2000)
#  description                             :text
#  primary_organization_id                 :integer
#  implementing_organization               :text
#  partner_organizations                   :text
#  cross_cutting_issues                    :text
#  start_date                              :date
#  end_date                                :date
#  budget                                  :float
#  target                                  :text
#  estimated_people_reached                :integer
#  contact_person                          :string(255)
#  contact_email                           :string(255)
#  contact_phone_number                    :string(255)
#  site_specific_information               :text
#  created_at                              :datetime
#  updated_at                              :datetime
#  the_geom                                :geometry
#  activities                              :text
#  intervention_id                         :string(255)
#  additional_information                  :text
#  awardee_type                            :string(255)
#  date_provided                           :date
#  date_updated                            :date
#  contact_position                        :string(255)
#  website                                 :string(255)
#  verbatim_location                       :text
#  calculation_of_number_of_people_reached :text
#  project_needs                           :text
#  idprefugee_camp                         :text
#  organization_id                         :string(255)
#  budget_currency                         :string(255)
#  budget_value_date                       :date
#  target_project_reach                    :float
#  actual_project_reach                    :float
#  project_reach_unit                      :string(255)
#  prime_awardee_id                        :integer
#  geographical_scope                      :string(255)      default("regional")
#

require 'rails_helper'
#ActiveRecord::Base.logger = Logger.new(STDOUT) if defined?(ActiveRecord::Base)
describe Project do
  describe "scoping and associations" do
    before :each do
      @c = FactoryGirl.create(:geolocation, name: 'country', g0: 'g0', uid: 'g0', adm_level: 0)
      @r1 = FactoryGirl.create(:geolocation, name: 'region1', g0: 'g0', g1: 'g1', uid: 'g1', adm_level: 1)
      @r2 = FactoryGirl.create(:geolocation, name: 'region2', g0: 'g0', g1: 'g1', g2: 'g2', uid: 'g2', adm_level: 2)
      @r3 = FactoryGirl.create(:geolocation, name: 'region3', g0: 'g0', g1: 'g1', g2: 'g2', g3: 'g3', uid: 'g3', adm_level: 3)
      @project = FactoryGirl.create(:project)
      @project.geolocations = [@r3]
      @project.save
      @project.reload
    end
    it 'should be shown on map on level 0' do
      map_points = Project.get_projects_on_map(level: 0)
      expect(map_points.map{|m| m.name}).to match_array(['country'])
    end
    it 'should be shown on map on level 1' do
      map_points = Project.get_projects_on_map(level: 1)
      expect(map_points.map{|m| m.name}).to match_array(['country', 'region1'])
    end
    it 'should be shown on map on level 2' do
      map_points = Project.get_projects_on_map(level: 2)
      expect(map_points.map{|m| m.name}).to match_array(['region1', 'region2'])
    end
    it 'should be shown on map on level 3' do
      map_points = Project.get_projects_on_map(level: 3)
      expect(map_points.map{|m| m.name}).to match_array(['region2', 'region3'])
    end
    it 'should be shown on map on level 4' do
      map_points = Project.get_projects_on_map(level: 4)
      expect(map_points.map{|m| m.name}).to match_array(['region3'])
    end
  end
end

