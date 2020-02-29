module WorkSpacePollingStationObservation
  extend ActiveSupport::Concern

  included do
    belongs_to :work_space_polling_station
    def self.observed_for ; :work_space_polling_station ; end
  
    validates_presence_of :count

    def past_counts
        []
    end  
  end
end
