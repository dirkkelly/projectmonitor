require 'spec_helper'

describe DashboardsController do
  describe "#feed" do
    let(:project) { Project.new }
    let(:aggregate_project) { AggregateProject.new }

    before do
      Project.stub_chain(:standalone, :with_statuses).and_return [project]
      AggregateProject.stub_chain(:with_statuses).and_return [aggregate_project]
      get :builds, :format => "rss"
    end

    it "renders an RSS feed" do
      response.should render_template("builds")
    end

    it "assigns all projects and aggregate projects" do
      assigns(:projects).should =~ [project, aggregate_project]
    end
  end

  describe "#index" do
    let(:project_collection) { double(:project_grid_collection) }
    before do
      DashboardGrid.should_receive(:generate).and_return(project_collection)
    end

    it "should generate the grid to determine the projects" do
      get :index
      assigns(:projects).should == project_collection
    end
  end
end
