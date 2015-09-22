require 'acceptance_helper'

resource 'Countries' do
  header "Accept", "application/json; application/vnd.ngoaidmap-api-v1+json"
  header "Content-Type", "application/vnd.api+json"
  header 'Host', 'http://ngoaidmap.org'

  let!(:country) do
    FactoryGirl.create(:geolocation, adm_level: 0, name: "country", uid: "gn00001")
  end

  get "/api/countries/:id" do
    parameter :id, "A country geolocaton uid"
    let(:id) { country.uid }

    example_request "Get data for one country" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)
      expect(results.length).to be == 1
      expect(results['data']['attributes']['name']).to  be == "country"
    end
  end

  get "/api/countries" do
    let!(:countries) do
      3.times do |p|
          FactoryGirl.create(:geolocation, adm_level: 0, name: "country #{p}", uid: "gn{p}",country_uid: "gn#{}")
      end
    end

    example_request "Getting a list of countries" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?(['country 0',
                               'country 1', 'country 2'])
    end
  end

  get "/api/countries?summing=:summing&status=:status" do
    parameter :summing, "String, value should be 'projects'"
    parameter :status, "String, Optional, should be 'active' to sum only active projects"
    let(:items) { 'projects' }
    p = FactoryGirl.create(:project, name: "project_in_different_countries")
    p.geolocations do
     3.times do |p|
        FactoryGirl.create(:geolocation, adm_level: 0, name: "country #{p}", uid: "gn{p}",country_uid: "gn#{}")
      end
    end
    p.save!
    example_request "Getting a list of countries summing projects", summing: 'projects', status: 'active' do
      expect(status).to eq(200)
      # results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      # expect results.include?("donor_with_sector")
    end
  end
end

