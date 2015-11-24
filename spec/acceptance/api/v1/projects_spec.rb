require 'acceptance_helper'

resource 'Projects' do
  header "Accept", "application/json; application/vnd.ngoaidmap-api-v1+json"
  header "Content-Type", "application/json"
  header 'Host', 'http://ngoaidmap.org'

  get "/api/projects" do
    let(:projects) do
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
    let(:projects) do
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
    let(:projects) do
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
    let(:projects) do
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
    let(:project) do
      FactoryGirl.create(:project, name: "project_with_organization", primary_organization: FactoryGirl.create(:organization))
    end
    let(:organization) do
      project.primary_organization_id
    end

    example_request "Getting a list of projects by implementing organization" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_organization'])
    end
  end

  get "/api/projects?donors[]=:donor" do
    parameter :donors, "Array. Donor ids"
    let(:project) do
      FactoryGirl.create(:project, name: "project_with_donor")
    end
    let(:donor_object) do
      FactoryGirl.create(:donor)
    end
    let(:donors) do
      project.donors=[donor_object]
    end
    let(:donor) do
      donor_object.id
    end

    example_request "Getting a list of projects by donors" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_donor'])
    end
  end

  get "/api/projects?sectors[]=:sector" do
    parameter :sectors, "Array. Sector ids"
    let(:sector_object) do
      FactoryGirl.create(:sector)
    end
    let(:project) do
      FactoryGirl.create(:project, name: "project_with_sector")
    end
    let(:sectors) do
      project.sectors=[sector_object]
    end
    let(:sector) do
      sector_object.id
    end

    example_request "Getting a list of projects by sectors" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_sector'])
    end
  end

  get "/api/projects?countries[]=:country" do
    parameter :countries, "Array. Country uids"
    let(:country_object) do
      FactoryGirl.create(:geolocation, name: 'India', adm_level: 0, uid: 'ggg', country_uid: 'ggg')
    end
    let!(:project) do
      FactoryGirl.create(:project, name: "project_with_country", geolocations: [country_object])
    end
    let(:country) do
      country_object.uid
    end
    example_request "Getting a list of projects by countries" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_country'])
    end
  end

  get "/api/projects?geolocation=:geolocation" do
    parameter :geolocation, "Geolocation uid"
    let(:geolocation_object) do
      FactoryGirl.create(:geolocation, name: 'Spain', adm_level: 0, uid: '000', g0: '000')
    end
    let!(:project) do
      FactoryGirl.create(:project, name: "project_with_geolocation", geolocations: [geolocation_object])
    end
    let(:geolocation) do
      geolocation_object.uid
    end

    example_request "Getting a list of projects by geolocation" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect(results).to eq(['project_with_geolocation'])
    end
  end

  get "/api/projects/:id" do
    parameter :id, "A project's id"
    let(:project) do
      create(:project)
    end
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
    let!(:project) do
      FactoryGirl.create(:project, name: "project", description:'lore ipsum text to find')
    end
    let(:q){'text to find'}

    example_request "Getting a list of projects by text search on name or description" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['description']}
      expect(results).to eq(['lore ipsum text to find'])
    end
  end

end
