class WarpCountObservation < ApplicationRecord
  # XXX But really a WorkSpacePollingDistrict

  include WorkSpacePollingStationObservation

  belongs_to :user
  has_one :work_space, through: :work_space_polling_station

  # Note: Unlike other observations, WARP counts are additive rather than a
  # snapshot of the latest state for some statistic in some area. This makes
  # more sense in this case as organisers want to be able to put in the count
  # from WARP of all the new confirmed votes in an area, from the latest
  # canvassing, and then the total count will be the sum of all the (valid)
  # such counts throughout the day.
  # validates_presence_of :count
end
