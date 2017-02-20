xml = Builder::XmlMarkup.new
xml.instruct!
xml.tag!("iati-activities", {
    "generated-datetime" => Time.now.xmlschema,
    "version" => "2.02",
    "linked-data-default" => "https://www.ngoaidmap.org"
}) do
    render partial: 'activity', locals: {x: xml, p: @project}
end
