require 'acceptance_helper'

resource 'Geolocations' do
  header "Accept", "application/json; application/vnd.ngoaidmap-api-v1+json"
  header "Content-Type", "application/vnd.api+json"
  header 'Host', 'http://ngoaidmap.org'

  let!(:geolocation) do
    FactoryGirl.create(:geolocation, adm_level: 0, name: "geo", uid: "gn00001")
  end

  get "/api/geolocations/:id" do
    parameter :id, "A geolocaton uid"
    parameter :get_parents, "Optional, boolean. Tells the API whether sow the parent regions (if any) or not. "
    let(:id) { geolocation.uid }
    let(:get_parents){false}

    example_request "Get data for one geolocation" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)
      expect(results.length).to be == 1
      expect(results['data']['attributes']['name']).to  be == "geo"
    end
  end

  get "/api/geolocations" do

    parameter :offset, "Optional, integer. Shows the list with a particular offset."
    parameter :limit, "Optional, integer. Shows the list with a particular limit of results."
    parameter :order, "Optional, string. Shows the list with a particular order. Can be 'name', 'id', 'uid' or 'country_name'"
    let(:offset){0}
    let(:limit){10}
    let(:order){'name'}
    let!(:geolocations) do
      3.times do |p|
          FactoryGirl.create(:geolocation, adm_level: 0, name: "geolocation #{p}", uid: "gn{p}",country_uid: "gn#{}")
      end
    end

    example_request "Getting a list of geolocations" do
      expect(status).to eq(200)
      results = JSON.parse(response_body)['data'].map{|r| r['attributes']['name']}
      expect results.include?(['geolocations 0',
                               'geolocations 1', 'geolocations 2'])
    end
  end
end

