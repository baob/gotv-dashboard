
class WorkSpacesController < ApplicationController
  layout 'organiser_dashboard'

  def show
    @work_space = WorkSpace.find_by_identifier!(params[:id])
  end

  def demo
    polling_stations_csv = File.read('example_data/polling_stations.csv')
    campaign_stats_csv = File.read('example_data/campaign_stats.csv')

    work_space = ContactCreatorImporter.import(
      work_space_name: "Vauxhall Election #{Time.zone.now.year} [Demo]",
      polling_stations_csv: polling_stations_csv,
      campaign_stats_csv: campaign_stats_csv
    )

    redirect_to work_space_path(work_space)
  end

  def observations
    @work_space = WorkSpace.find_by_identifier!(params[:id])

    @turnout_observations = @work_space.turnout_observations.order(created_at: :desc)
    @warp_counts = @work_space.warp_count_observations.order(created_at: :desc)
    # XXX could do with a test for the sorting
    @observations = (@turnout_observations + @warp_counts).sort{ |a,b| a.created_at <=> b.created_at}

    render layout: 'organiser_dashboard'
  end

  def update
    work_space = WorkSpace.find_by_identifier!(params[:id])
    work_space.update!(update_work_space_params)
    redirect_to work_space_path(work_space)
  end

  private

  def update_work_space_params
    params.require(:work_space).permit(:suggested_target_district_method)
  end
end
