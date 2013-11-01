require 'rspec-given'
require 'juxtapose'
require 'juxtapose_manager'

describe Juxtapose do
  before :all do
    @juxtapose = Juxtapose.new 'test'
    JuxtaposeManager.reset_shots_folder @juxtapose.current_directory
    JuxtaposeManager.reset_shots_folder @juxtapose.baseline_directory
  end

  describe "#new" do
    it "takes one parameter and returns a Juxtapose object" do
      @juxtapose.should be_an_instance_of Juxtapose
    end
  end

  describe "#widths" do
    it "returns the correct widths"  do
      @juxtapose.widths.should eql [320, 600]
    end
  end

  describe "#baseline_directory" do
    it "returns the correct baseline directory"  do
      @juxtapose.baseline_directory.should eql 'public/screenshots_baseline'
    end
  end

  describe "#current_directory" do
    it "returns the correct current directory"  do
      @juxtapose.current_directory.should eql 'public/screenshots_current'
    end
  end

  describe "#widths" do
    it "returns the correct widths"  do
      @juxtapose.widths.should eql [320, 600]
    end
  end

  describe "#browsers" do
    it "returns an array of browsers" do
      @juxtapose.browsers.should eq ["firefox"]
    end
  end

  describe "#domain" do
  it "returns the domain being tested" do
  expected = {"google_uk"=>"www.google.co.uk"}
    @juxtapose.domain.should eq expected
  end
  end

  describe "#base_domain" do
    it "returns the base domain of the url being tested" do
      @juxtapose.base_domain.should eq "www.google.co.uk"
    end

  end

  describe "#base_domain_label" do
    it "returns the label of the base domain" do
      @juxtapose.base_domain_label.should eq 'google_uk'
    end
  end

  describe "#paths" do
    it "returns the paths to be tested" do
      expected = {"home"=>"/"}
      @juxtapose.paths.should eq expected
    end
  end

  describe "#capture_page_image" do
    it "captures and saves as screenshot of defined url" do
      arg1 = @juxtapose.base_domain + @juxtapose.paths.first[1]
      arg2 = @juxtapose.widths.first
      arg3 = @juxtapose.current_directory + '/' + @juxtapose.base_domain_label + '_test1.png'
      @juxtapose.capture_page_image arg1, arg2, arg3
      @juxtapose.close_browser
      File.exist?(arg3).should be_true
    end
  end

  describe "#compare_images" do
    it "compares 2 images and returns true if they are the same" do
      arg1 = @juxtapose.current_directory + '/' + @juxtapose.base_domain_label + '_test1.png'
      arg3 = @juxtapose.current_directory + '/' + @juxtapose.base_domain_label + '_test2.png'
      @juxtapose.compare_images(arg1, arg1, arg3).should be_true
    end

    it "compares 2 images and returns true if they are different" do
      arg1 = 'www.google.com.au' + @juxtapose.paths.first[1]
      arg2 = @juxtapose.widths.first
      arg3 = @juxtapose.current_directory + '/' + @juxtapose.base_domain_label + '_test3.png'
      @juxtapose.capture_page_image arg1, arg2, arg3
      @juxtapose.close_browser
      File.exist?(arg3).should be_true

      arg1 = @juxtapose.current_directory + '/' + @juxtapose.base_domain_label + '_test1.png'
      arg2 = @juxtapose.current_directory + '/' + @juxtapose.base_domain_label + '_test3.png'
      arg3 = @juxtapose.current_directory + '/' + @juxtapose.base_domain_label + '_test4.png'
      @juxtapose.compare_images(arg1, arg2, arg3).should_not be_true
      File.exist?(arg3).should be_true

    end
  end

  #describe "#crop_images" do
  #describe "#thumbnail_image"

end
