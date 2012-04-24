require 'spec_helper'

describe DashboardHelper do
  context "#container_class" do
    subject { helper.container_class }

    context "when there are no projects" do
      it { should == "container_12" }
    end

    context "when there are 15 projects" do
      before do
        @projects = stub(GridCollection, :size => 15)
      end
      it { should == "container_12" }
    end

    context "when there are 24 projects" do
      before do
        @projects = stub(GridCollection, :size => 24)
      end
      it { should == "container_12" }
    end

    context "when there are 48 projects" do
      before do
        @projects = stub(GridCollection, :size => 48)
      end
      it { should == "container_12" }
    end

    context "when there are 63 projects" do
      before do
        @projects = stub(GridCollection, :size => 63)
      end
      it { should == "container_7" }
    end
  end

  context "#grid_class" do
    subject { helper.grid_class }

    context "when there are no projects" do
      it { should == "grid_4" }
    end

    context "when there are 15 projects" do
      before do
        @projects = stub(GridCollection, :size => 15)
      end
      it { should == "grid_4" }
    end

    context "when there are 24 projects" do
      before do
        @projects = stub(GridCollection, :size => 24)
      end
      it { should == "grid_3" }
    end

    context "when there are 48 projects" do
      before do
        @projects = stub(GridCollection, :size => 48)
      end
      it { should == "grid_2" }
    end

    context "when there are 63 projects" do
      before do
        @projects = stub(GridCollection, :size => 63)
      end
      it { should == "grid_1" }
    end
  end

  context "#tile_for" do
    subject { helper.tile_for @tile_obj }

    context "when nil" do
      it { should be_nil }
    end

    context "when a location" do
      before do
        @tile_obj = Location.new("Georgia")
      end
      it { should == @tile_obj }
    end

    context "when a ProjectDecorator" do
      before do
        ProjectDecorator.stub(:new).and_return(:project_decorator)
        @tile_obj = Project.new
      end
      it { should == :project_decorator }
    end

  end
end
