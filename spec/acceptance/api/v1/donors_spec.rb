require 'acceptance_helper'

resource 'Donors' do
  header "Accept", "application/json; application/vnd.ngoaidmap-api-v1+json"
  header "Content-Type", "application/vnd.api+json"
  header 'Host', 'http://ngoaidmap.org'

  let!(:donor) do
    create(:donor)
  end

  get "/api/donors/:id" do
    parameter :id, "A donor's id"
    let(:id) { donor.id }
    let(:name) { donor.name }

    example_request "Get data for one donor" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)
      expect(results.length).to be == 1
      expect(results['data']['attributes']['name']).to  be == name
    end
  end

  get "/api/donors/:id" do
    parameter :id, "A donor's id"
    let(:id) { donor.id + 1 }

    example "Get the data of a non existing donor", document: false do
      do_request(id: :id)
      expect(status).to eq(404)
      results = JSON.parse(response_body)
      expect(results.length).to be == 1
      expect(results['errors'].first['status']).to be == '404'
    end
  end

  get "/api/donors" do
    parameter :status, "Optional, string. Should be 'active' to filter active projects only."
    let(:status){'active'}
    let!(:organizations) do
      3.times do |o|
        FactoryGirl.create(:organization, name: "donor#{o}")
      end
    end

    example_request "Getting a list of donors" do
      #expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?(['donor0',
                               'donor1', 'donor2'])
    end
  end

  get "/api/donors?sectors[]=:sector" do
    parameter :sectors, "Array. Sector ids"
    parameter :status, "Optional, string. Should be 'active' to filter active projects only."
    p = FactoryGirl.create(:project, name: "project_with_organization")
    s = FactoryGirl.create(:sector)
    p.sectors = [s]
    p.save!
    let(:status){'active'}
    let(:sector) do
      s.id
    end
    let!(:donor) do
      FactoryGirl.create(:donor, name: "donor_with_sector", donations: [FactoryGirl.create(:donation, project_id: p.id)])
    end

    example_request "Getting a list of donors for a particular sector" do
      #expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?("donor_with_sector")
    end
  end
end

