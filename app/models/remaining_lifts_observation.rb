class RemainingLiftsObservation < ApplicationRecord
  # XXX But really a WorkSpacePollingDistrict

  include WorkSpacePollingStationObservation

  belongs_to :user
end
