RSpec.shared_context "setup_global_site" do
  let!(:global_site) do
    create(:site, name: 'global', theme: garnet_theme,
      "short_description"            => "global",
      "long_description"             => "Global site",
      "contact_email"                => "david@simbiotica.es",
      "contact_person"               => "David González @ Simbiótica",
      "url"                          => "global.ngoaidmap.org",
      "show_global_donations_raises" => false,
      "project_classification"       => 1,
      "status"                       => true,
      "navigate_by_country"          => true,
      "navigate_by_level1"           => true,
      "navigate_by_level2"           => false,
      "navigate_by_level3"           => false,
      "overview_map_lat"             => 24.5271348225978,
      "overview_map_lon"             => 5.625,
      "overview_map_zoom"            => 1,
      "internal_description"         => "Global site for unification",
      "featured"                     => false)
  end

  let!(:garnet_theme) do
    create(:theme, id: 1, name: "Garnet",
      thumbnail_path: '/images/themes/1/thumbnail.png',
      css_file:       "/stylesheets/themes/garnet.css",
      data: {
        overview_map_chco:           "F7F7F7,8BC856,336600",
        georegion_map_stroke_color:  "#000000",
        overview_map_chf:            "bg,s,2F84A3",
        georegion_map_fill_color:    "#000000",
        overview_map_marker_source:  "/images/themes/1/",
        georegion_map_chco:          "F7F7F7,8BC856,336600",
        georegion_map_chf:           "bg,s,2F84A3",
        georegion_map_marker_source: "/images/themes/1/"
      }
      )
  end

  let!(:main_site_settings) do
    create(:settings, data: {
      "geoiq_parameter_2"=>"",
      "main_site_host"=>"ngoaidmap.test",
      "default_email"=>"",
      "default_contact_name"=>"",
      "geoiq_parameter_1"=>""})
  end

  let!(:ethiopia) do
    Geolocation.create({
      uid: "gn_337996",
      name: "Ethiopia",
      latitude: 9.0,
      longitude: 39.5,
      fclass: "A",
      fcode: "PCLI",
      country_code: "ET",
      country_name: "Ethiopia",
      country_uid: "gn_337996",
      provider: "gn",
      adm_level: 0,
      g0: "gn_337996"
    })
  end

  let!(:education_sector) do
    create(:sector, {
      name:                  "Education",
      oecd_dac_name:         "Education",
      oecd_dac_purpose_code: "110",
      sector_vocab_code:     "2",
    })
  end

  let!(:save_the_children) do
    create(:organization, {
      name:                            "Save the Children",
      description:                     "Save the Children invests in childhood – every day, in times of crisis and for our future. In the United States and around the world, we are dedicated to ensuring every child has the best chance for success. Our pioneering programs give children a healthy start, the opportunity to learn and protection from harm. Our advocacy efforts provide a voice for children who cannot speak for themselves. As the leading expert on children, we inspire and achieve lasting impact for millions of the world’s most vulnerable girls and boys. By transforming children’s lives now, we change the course of their future and ours.",
      budget:                          87173102.0,
      website:                         "http://www.savethechildren.org",
      national_staff:                  0,
      twitter:                         "https://twitter.com/SavetheChildren",
      facebook:                        "https://www.facebook.com/savethechildren",
      hq_address:                      "899 North Capitol Street, NE, Suite 900",
      contact_email:                   "mchekol@savechildren.org",
      contact_phone_number:            "202-640-6723",
      donation_address:                "501 Kings Highway East",
      zip_code:                        "06825",
      city:                            "Fairfield ",
      state:                           "CT",
      donation_phone_number:           "800-728-3843",
      donation_website:                "http://www.savethechildren.org",
      contact_name:                    "Muluemebet Chekol",
      contact_position:                "Senior Director, Monitoring & Evaluation and Knowledge Management",
      contact_zip:                     "20002",
      contact_city:                    "Washington",
      contact_state:                   "District of Columbia",
      estimated_people_reached:        1,
      private_funding_spent:           37712734.0,
      usg_funding_spent:               8374366.0,
      other_funding_spent:             nil,
      spent_funding_on_relief:         100.0,
      spent_funding_on_reconstruction: 0.0,
      percen_relief:                   100,
      percen_reconstruction:           0,
      media_contact_name:              " Francine Uenuma",
      media_contact_position:          " Director, Media Relations ＆ Communications",
      media_contact_phone_number:      " 202-640-6810",
      media_contact_email:             " FUenuma@savechildren.org ",
      main_data_contact_zip:           "20036",
      main_data_contact_city:          "Washington",
      main_data_contact_state:         "District of Columbia",
      organization_id:                 "STC",
      organization_type:               "International NGO",
      organization_type_code:          21,
      iati_organizationid:             "US-EIN-06-0726487",
      publishing_to_iati:              true,
      membership_status:               "Current Member"
    })
  end

  let!(:project1) do
    create(:project, {
      name:                    "Integrated Multi-sectorial Response in Guradhamole, Lega Hida, Rayitu, Dawe Kachana and Sewena woredas, Bale zone, Oromia Region. Education",
      description:             "The overall project is to contribute to the reduction of morbidity and mortality related to drought conditions through Nutrition.",
      primary_organization:    save_the_children,
      start_date:              Date.parse("2016/6/1"),
      end_date:                1.year.from_now.to_date,
      budget:                  550699.37,
      contact_person:          "Suzanne Ammari",
      contact_email:           "SAmmari@savechildren.org",
      intervention_id:         "STC-ET-16-19075",
      organization_id:         "84004319",
      budget_currency:         "USD",
      budget_value_date:       Date.parse("2016/6/1"),
      geographical_scope:      "specific_locations"
    })
  end

  let!(:project2) do
    create(:project, {
      name: "Enhance the Participation of Children with Disabilities. Education",
      description: "Parents, teachers, health professionals and policy makers in Save the Children Sweden program areas are aware of situations of children with disabilities.",
      primary_organization: save_the_children,
      implementing_organization: "Save the Children Sweden",
      partner_organizations: "Handicap National",
      start_date: Date.parse("2009/1/1"),
      end_date: 1.year.from_now.to_date,
      budget: 452000.0,
      contact_person: "Awraris Alemayehu",
      contact_email: "awrarisa@ecaf.savethechildren.se",
      the_geom: "0104000020E61000000100000001010000005E652B376A604240331F705A79E61940",
      intervention_id: "STC-ET-09-2448",
      additional_information: "The start and end dates are approximate.",
      date_provided: Date.parse("2011/9/2"),
      date_updated: Date.parse("2011/9/2"),
      budget_currency: "USD",
      budget_value_date: Date.parse("2009/1/1"),
      geographical_scope: "specific_locations"
    })
  end

  let!(:wfp_donor) { create(:donor, name: "World Food Program (WFP)") }

  let!(:project1_donation) { create(:donation, project: project1, donor: wfp_donor)}
  let!(:project2_donation) { create(:donation, project: project2, donor: wfp_donor)}

  before do
    project1.sites << global_site
    project1.sectors << education_sector
    project2.sites << global_site
    project2.sectors << education_sector
  end

end
