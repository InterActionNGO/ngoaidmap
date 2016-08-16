require 'rails_helper'

RSpec.describe "viewing the homepage", :type => :feature do
  include_context("setup_global_site")

  it "is visitable" do
    visit '/'
    expect(page).to have_content('All projects')
  end

  describe 'working with filters', js: true do
    it "can select a country" do
      visit '/'
      find('#filtersView .countries .father').hover
      sleep(0.1)
      find('#filtersView .mod-categories-child.countries-child').click_link("Ethiopia")
      expect(current_path).to eql("/location/gn_337996")
      expect(page).to have_content('projects in Ethiopia')
    end

    it "can select a sector" do
      visit '/'
      find('#filtersView .sector .father').hover
      sleep(0.1)
      find('#filtersView .mod-categories-child.sector-child a.education').click
      expect(current_path).to eql("/sectors/#{education_sector.id}")
      expect(page).to have_content('Education projects')
    end

    it "can select an organization" do
      visit '/'
      find('#filtersView .organizations .father').hover
      sleep(0.1)
      find('#filtersView .mod-categories-child.organizations-child').click_link("Save the Children")
      expect(current_path).to eql("/organizations/#{save_the_children.id}")
      expect(page).to have_content('projects by Save the Children')
    end

    it "can select a donor" do
      visit '/'
      find('#filtersView .donors .father').hover
      sleep(0.1)
      find('#filtersView .mod-categories-child.donors-child').click_link("World Food Program (WFP)")
      expect(current_path).to eql("/donors/#{wfp_donor.id}")
      expect(page).to have_content('projects funded by World Food Program (WFP)')
    end

    it "can search projects" do
      visit '/'
      fill_in('q', with: 'education')
      find('#filtersView form input[type="submit"]').click
      expect(current_path).to eql("/search")
      expect(page).to have_content("Showing results for: 'education'")
    end
  end

  describe "working with projects in the list" do
    
  end
end
