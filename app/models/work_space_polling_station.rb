class WorkSpacePollingStation < ApplicationRecord
  belongs_to :work_space
  belongs_to :polling_station
  belongs_to :committee_room, required: false
  has_one :polling_district, through: :polling_station
  has_one :ward, through: :polling_station
  has_many :turnout_observations
  # XXX These are more PollingDistrict proxy fields - refactor to move to
  # PollingDistrict level
  has_many :remaining_lifts_observations
  has_many :warp_count_observations

  delegate :reference,
    :name,
    :postcode,
    :fully_specified_name,
    to: :polling_station

  validates_presence_of :box_labour_promises
  validates_presence_of :box_electors
  validates_presence_of :postal_labour_promises
  validates_presence_of :postal_electors

  def as_json(options = {})
    super(options).merge(fully_specified_name: fully_specified_name)
  end

  def colocated_polling_stations
    # Try to merge equivalent postcodes, and reject the polling station we are
    # looking at.
    work_space.work_space_polling_stations.select do |ps|
      ps.id != id && ps.postcode.upcase.gsub(/\s+/, "") == postcode.upcase.gsub(/\s+/, "")
    end
  end

  # XXX Refactor this to same style as other obsevations - use
  # `last_observation_for` etc?
  def last_observation
    turnout_observations.max_by(&:created_at)
  end

  def last_remaining_lifts_observation
    last_observation_for(remaining_lifts_observations)
  end

  # XXX Existence of these 2 methods and all usage is a total hack - we use
  # first WorkSpacePollingStation for PollingDistrict as a proxy for a
  # 'WorkSpacePollingDistrict', to work around this not existing and being
  # involved to add. Should fix at some point post-election -
  # https://github.com/bobwhitelock/gotv-dashboard/issues/100.
  def work_space_polling_district_proxy?
    work_space_polling_district_stations.first == self
  end

  def work_space_polling_district_stations
    WorkSpacePollingStation.joins(
      :polling_station
    ).where(
      polling_stations: { polling_district: polling_district },
      work_space: work_space
    ).order(:reference)
  end

  def confirmed_labour_votes_from_warp
    warp_count_observations.where(is_valid: true).sum('count')
  end

  def remaining_labour_votes_from_warp
    box_labour_promises - confirmed_labour_votes_from_warp
  end
end
