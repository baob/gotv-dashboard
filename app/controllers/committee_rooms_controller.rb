class CommitteeRoomsController < ApplicationController
  layout 'organiser_dashboard'

  def new
    @committee_room = CommitteeRoom.new
    @work_space = find_work_space
    @skip_creation_url = work_space_path(@work_space)
  end

  def create
    work_space = find_work_space

    polling_districts = params[:polling_districts]
    work_space_polling_stations = WorkSpacePollingStation.joins(
      :polling_station
    ).where(
      work_space: work_space,
      polling_stations: {
        polling_district: polling_districts
      }
    )

    ActiveRecord::Base.transaction do
      committee_room = CommitteeRoom.create!(
        committee_room_params.merge(work_space: work_space)
      )
      work_space_polling_stations.update_all(committee_room_id: committee_room.id)
    end

    redirect_to work_space_path(work_space)
  end

  def canvassers
    volunteers_observation_action(CanvassersObservation)
  end

  def cars
    volunteers_observation_action(CarsObservation)
  end

  private

  def volunteers_observation_action(observation_class)
    committee_room = CommitteeRoom.find(params[:committee_room_id])
    # XXX More ad-hoc authorization, should improve.
    return if committee_room.work_space != find_work_space

    observation_class.create!(
      committee_room: committee_room,
      count: params[:count],
      user: @current_user
    )
  end

  def committee_room_params
    params.require(:committee_room).permit(:address, :organiser_name)
  end
end
