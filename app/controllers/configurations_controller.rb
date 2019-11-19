
class ConfigurationsController < ApplicationController
  layout 'setup'

  def show
    @work_space = find_work_space

  end
end
