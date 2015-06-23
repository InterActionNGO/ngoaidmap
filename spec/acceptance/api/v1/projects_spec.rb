require 'acceptance_helper'

resource 'Projects' do
  header "Accept", "application/json; application/vnd.esios-api-v1+json"
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
      results = JSON.parse(response_body)['data'].map{|r| r['name']}
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
      results = JSON.parse(response_body)['data'].map{|r| r['name']}
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
      results = JSON.parse(response_body)['data'].map{|r| r['name']}
      expect results.include?(['project1', 'project2', 'project3'])
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
      results = JSON.parse(response_body)['data'].map{|r| r['name']}
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
      results = JSON.parse(response_body)['data'].map{|r| r['name']}
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
      results = JSON.parse(response_body)['data'].map{|r| r['name']}
      expect(results).to eq(['project_with_sector'])
    end
  end

  get "/api/projects?countries[]=:country" do
    parameter :countries, "Array. Country ids"
    p = FactoryGirl.create(:project, name: "project_with_country")
    s = FactoryGirl.create(:country)
    p.countries=[s]
    let(:country) do
      s.id
    end

    example_request "Getting a list of projects by countries" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['name']}
      expect(results).to eq(['project_with_country'])
    end
  end

  get "/api/projects?regions[]=:region" do
    parameter :regions, "Array. Region ids"
    p = FactoryGirl.create(:project, name: "project_with_region")
    s = FactoryGirl.create(:region)
    p.regions=[s]
    let(:region) do
      s.id
    end

    example_request "Getting a list of projects by regions" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['name']}
      expect(results).to eq(['project_with_region'])
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
      expect(results['data']['name']).to  be == name
    end
  end

end
