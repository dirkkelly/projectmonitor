class DashboardsController < ApplicationController
  layout "dashboard"

  def index
    @projects = DashboardGrid.generate params
  end

  def builds
    @projects = Project.standalone.with_statuses + AggregateProject.with_statuses
  end
end

