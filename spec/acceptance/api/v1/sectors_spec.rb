require 'acceptance_helper'

resource 'Sectors' do
  header "Accept", "application/json; application/vnd.ngoaidmap-api-v1+json"
  header "Content-Type", "application/vnd.api+json"
  header 'Host', 'http://ngoaidmap.org'

  let!(:sector) do
    FactoryGirl.create(:sector, name: "Sector")
  end

  get "/api/sectors/:id" do
    parameter :id, "A sector id"
    let(:id) { sector.id }

    example_request "Get data for one sector", focus: true do
      #expect(status).to eq(200)
      results = JSON.parse(response_body)
      expect(results.length).to be == 1
      expect(results['data']['attributes']['name']).to  be == "Sector"
    end
  end

  get "/api/sectors" do

    parameter :include, "Optional, string. Should be 'projects_count' to get the sum of projects per sector."
    parameter :status, "Optional, string. Should be 'active' to get only sectors that include active projects."
    let(:include){'projects_count'}
    let(:status){'inactive'}
    let!(:sectors) do
      3.times do |p|
          FactoryGirl.create(:sector, name: "sector #{p}")
      end
    end

    example_request "Getting a list of sectors" do
      #expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?(['sector 0',
                               'sector 1', 'sector 2'])
    end
  end
end

