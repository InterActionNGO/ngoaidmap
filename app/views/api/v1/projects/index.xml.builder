xml = Builder::XmlMarkup.new
xml.instruct!
xml.tag!("iati-activities", {
    "xmlns:interactions-ngoaidmap" => "https://www.ngoaidmap.org/",
    "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
    "xmlns:xsd" => "http://www.w3.org/2001/XMLSchema",
    "interactions-ngoaidmap:records-returned" => @projects_size,
    "interactions-ngoaidmap:total-records-available" => @total_projects,
    "interactions-ngoaidmap:record-offset" => params[:offset] || 0,
    "generated-datetime" => Time.now.xmlschema,
    "version" => "2.02",
    "linked-data-default" => "https://www.ngoaidmap.org"
}) do
    @projects.each do |project|
        render partial: 'activity', locals: {x: xml, p: project}
    end
end