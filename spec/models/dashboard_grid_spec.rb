require 'spec_helper'

describe DashboardGrid do
  let(:project) { Project.new }
  let(:aggregate_project) { AggregateProject.new }

  context "no tags" do
    before do
      Project.should_receive(:standalone).and_return [project]
      AggregateProject.should_receive(:all).and_return [aggregate_project]
    end

    it "assigns all projects and aggregate projects" do
      projects = DashboardGrid.generate
      projects.should include(project)
      projects.should include(aggregate_project)
    end
  end

  context "tags" do
    let!(:tagged_project) { FactoryGirl.create(:project, tag_list: "tag") }
    let!(:tagged_aggregate_project) { FactoryGirl.create(:aggregate_project, tag_list: "tag,awesome") }
    let!(:awesome_project) { FactoryGirl.create(:project, tag_list: "awesome", aggregate_project: tagged_aggregate_project) }

    it "assigns all projects and aggregate projects with the requested tags" do
      projects = DashboardGrid.generate(tags: "tag")
      projects.should include(tagged_project)
      projects.should include(tagged_aggregate_project)
    end

    context "aggregate contains project with same tags" do
      it "does not return projects that are included in an aggregate with the same tag" do
        projects = DashboardGrid.generate(tags: "awesome")
        projects.should_not include(awesome_project)
      end
    end

    context "aggregate project does not contain the tag" do
      it "should return all the children projects with that tag" do
        child_project = FactoryGirl.create(:project, tag_list: "other_tag", aggregate_project: tagged_aggregate_project)
        projects = DashboardGrid.generate(tags: "other_tag")
        projects.should include(child_project)
      end
    end
  end

  context "tiles_count" do
    it "displays 15 when no params present" do
      projects = DashboardGrid.generate
      projects.size.should == 15
    end

    [15, 24, 48, 63].each do |tiles_count|
      context "#{tiles_count} tiles" do
        it "displays #{tiles_count}" do
          projects = DashboardGrid.generate(tiles_count: tiles_count)
          projects.size.should == tiles_count
        end
      end
    end
  end

  context "view" do
    context "locations" do
      it "displays projects under the appropriate location" do
        Project.destroy_all
        AggregateProject.destroy_all

        FactoryGirl.create(:project, name: "Other 1")
        FactoryGirl.create(:project, name: "Other 2")
        FactoryGirl.create(:project, location: "Boston", name: "Boston 1")
        FactoryGirl.create(:project, location: "Boston", name: "Boston 2")
        FactoryGirl.create(:project, location: "Boston", name: "Boston 3")
        FactoryGirl.create(:project, location: "San Francisco", name: "San Francisco 1")
        FactoryGirl.create(:project, location: "Atlanta", name: "Atlanta 1")
        FactoryGirl.create(:project, location: "Atlanta", name: "Atlanta 2")

        projects = DashboardGrid.generate(view: "locations")

        projects.select { |p| p.is_a?(Location) }.count.should == 4
        projects.select { |p| p.is_a?(Project) }.count.should == 8
        projects.select { |p| p.nil? }.count.should == 51
        projects.count.should == 63

        projects.map(&:to_s).should == [
          "San Francisco",   "Atlanta",   "Boston",   "Other",   "", "", "",
          "San Francisco 1", "Atlanta 1", "Boston 1", "Other 1", "", "", "",
          "",                "Atlanta 2", "Boston 2", "Other 2", "", "", "",
          "",                "",          "Boston 3", "",        "", "", "",
          "",                "",          "",         "",        "", "", "",
          "",                "",          "",         "",        "", "", "",
          "",                "",          "",         "",        "", "", "",
          "",                "",          "",         "",        "", "", "",
          "",                "",          "",         "",        "", "", ""
        ]
      end
    end
  end

  context "with multiple projects" do
    fixtures :projects, :aggregate_projects

    let(:projects) { DashboardGrid.generate.compact }

    before do
      projects.size.should > 1
    end

    it "sorts the projects in alphabetical order" do
      projects.should == projects.sort_by(&:name)
    end
  end
end
