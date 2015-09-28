require 'acceptance_helper'

resource 'Projects' do
  header "Accept", "application/json; application/vnd.ngoaidmap-api-v1+json"
  header "Content-Type", "application/json"
  header 'Host', 'http://ngoaidmap.org'

  get "/api/projects" do
    let!(:projects) do
      3.times do |p|
        FactoryGirl.create(:project, name: "project#{p}")
      end
    end

    example_request "Getting a list of projects" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?(['project0', 'project1', 'project2'])
    end
  end

  get "/api/projects?offset=:offset" do
    parameter :offset, "Integer. An integer number representing the number of projects from where to start the collection"
    let(:offset) {7}
    let!(:projects) do
      10.times do |p|
        FactoryGirl.create(:project, name: "project#{p}")
      end
    end

    example_request "Getting a list of projects with an offset" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?(['project8', 'project9', 'project10'])
    end
  end

  get "/api/projects?limit=:limit" do
    parameter :limit, "Integer. An integer number representing the maximum number of projects"
    let(:limit) {3}
    let!(:projects) do
      10.times do |p|
        FactoryGirl.create(:project, name: "project#{p}")
      end
    end

    example_request "Getting a list of projects with a limit" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?(['project1', 'project2', 'project3'])
    end
  end

  get "/api/projects?status=:status" do
    parameter :status, "String. should be 'active' for active projects or 'inactive' for inactive projects"
    let(:status) {'active'}
    let!(:projects) do
      3.times do |p|
        FactoryGirl.create(:project, name: "project#{p}", end_date: Time.now + 10.years, start_date: 1.year.ago)
      end
    end
    let!(:project) do
        FactoryGirl.create(:project, name: "inactive project", end_date: Time.now - 10.years, start_date: 11.years.ago)
    end

    example_request "Getting a list of active projects only" do
      #expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?(['project1', 'project2', 'project3'])
      expect !results.include?(['inactive project'])
    end
  end


  get "/api/projects?organizations[]=:organization" do
    parameter :organizations, "Array. Organization ids"
    p = FactoryGirl.create(:project, name: "project_with_organization")
    s = FactoryGirl.create(:organization)
    p.primary_organization_id = s.id
    p.save!
    let(:organization) do
      s.id
    end

    example_request "Getting a list of projects by implementing organization" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_organization'])
    end
  end

  get "/api/projects?donors[]=:donor" do
    parameter :donors, "Array. Donor ids"
    p = FactoryGirl.create(:project, name: "project_with_donor")
    d = FactoryGirl.create(:donor)
    p.donors=[d]
    let(:donor) do
      d.id
    end

    example_request "Getting a list of projects by donors" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_donor'])
    end
  end

  get "/api/projects?sectors[]=:sector" do
    parameter :sector, "Array. Sector ids"
    p = FactoryGirl.create(:project, name: "project_with_sector")
    s = FactoryGirl.create(:sector)
    p.sectors=[s]
    let(:sector) do
      s.id
    end

    example_request "Getting a list of projects by sectors" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_sector'])
    end
  end

  get "/api/projects?countries[]=:country" do
    parameter :countries, "Array. Country uids"
    p = FactoryGirl.create(:project, name: "project_with_country")
    c = FactoryGirl.create(:geolocation, name: 'India', adm_level: 0, uid: 'ggg', country_uid: 'ggg')
    p.geolocations=[c]
    let(:country) do
      c.uid
    end

    example_request "Getting a list of projects by countries" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_country'])
    end
  end

  get "/api/projects?geolocation=:geolocation&level=:level" do
    parameter :geolocation, "Geolocation uid"
    parameter :level, "Admin level"
    p = FactoryGirl.create(:project, name: "project_with_geolocation")
    g1 = FactoryGirl.create(:geolocation, name: 'Madrid', adm_level: 1, uid: '111', g0: '000', g1: '111')
    g = FactoryGirl.create(:geolocation, name: 'Spain', adm_level: 0, uid: '000', g0: '000')
    p.geolocations=[g]
    let(:level) { 0 }
    let(:geolocation) do
      g.uid
    end

    example_request "Getting a list of projects by geolocation" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_geolocation'])
    end
  end

  let!(:project) do
    create(:project)
  end

  get "/api/projects/:id" do
    parameter :id, "A project's id"
    let(:id) { project.id }
    let(:name) { project.name }

    example_request "Get a particular project data" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)
      expect(results.length).to be == 1
      expect(results['data']['attributes']['name']).to  be == name
    end
  end

    get "/api/projects?q=:q" do
    parameter :q, "String. Text to search"
    p = FactoryGirl.create(:project, name: "project", description:'lore ipsum text to find')
    let(:q){'text to find'}

    example_request "Getting a list of projects by text search on name or description" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['description']}
      expect(results).to eq(['lore ipsum text to find'])
    end
  end

end
