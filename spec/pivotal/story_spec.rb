require 'spec_helper'

describe Pivotal::Story do

  before(:each) do
    @story = Pivotal::Story.new :resource => pivotal_api.resource["projects"][1]["stories"][1]
  end
  
  it "should be connected to the story resource" do
    @story.resource.url.should == "https://www.pivotaltracker.com/services/v3/projects/1/stories/1"
  end
  
    [:id, :story_type, :url, :estimate, :current_state,
       :description, :name, :requested_by, :owned_by,
       :created_at, :accepted_at, :labels].map(&:to_s).each do |method|
    it "should have an accessor method for #{method}" do
      @story.methods.should include(method)
    end
    
    it "should include #{method} in the list of valid attributes" do
      @story.class.attributes.should include(method)
    end
  end
  
  it "should be able to mark the story as started" do
    @xpath = "//current_state = 'started'"
    @story.resource.expects(:put).with { |xml| Nokogiri::XML(xml).xpath(@xpath) }
    @story.start!
  end
  
  it "should be able to update other attributes when marking the story as started" do
    # Check the XML contains the right options.
    # Can't just check the XML string, because the elements may be in a
    # different order (because it's built from a hash).
    @xpath = "//current_state = 'started' and //owned_by = 'Jeff Tucker'"
    @story.resource.expects(:put).with {|xml| Nokogiri.XML(xml).xpath(@xpath) }
    @story.start!(:owned_by => "Jeff Tucker")
  end
  
end
