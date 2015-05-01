require "spec_helper"

describe "Yes or No", :type => :helper do
  it "returns yes for true" do
    expect(helper.yes_no(true)).to eq("Yes")
  end
  it "returns no for false" do
    expect(helper.yes_no(false)).to eq("No")
  end
end

describe "url with http", :type => :helper do
  it "adds protocol to link with missing protocol" do
    expect(helper.url_with_http("www.google.com")).to eq("http://www.google.com")
  end
  it "does not add protocol if already exists in link" do
    expect(helper.url_with_http("http://www.google.com")).to eq("http://www.google.com")
  end
  it "returns an empty string if the link is nil" do
    expect(helper.url_with_http(nil)).to eq("")
  end
end
