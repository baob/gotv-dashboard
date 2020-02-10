class ImproveDataModel < ActiveRecord::Migration[5.2]
  # This migration expects no data to exist in database; will probably break or
  # do unexpected things if data does exist.
  def change
    [
      :turnout_observations,
      :warp_count_observations,
      :remaining_lifts_observations
    ].each do |table|
      remove_column table,
        :work_space_polling_station_id,
        :integer,
        null: false,
        default: 0
    end

    drop_table :work_space_polling_stations, force: :cascade do |t|
      t.integer "polling_station_id", null: false
      t.integer "work_space_id", null: false
      t.integer "box_electors", null: false
      t.integer "box_labour_promises", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "committee_room_id"
      t.integer "postal_labour_promises", default: 0, null: false
      t.integer "postal_electors", default: 0, null: false
      t.index ["committee_room_id"], name: "index_work_space_polling_stations_on_committee_room_id"
      t.index ["polling_station_id"], name: "index_work_space_polling_stations_on_polling_station_id"
      t.index ["work_space_id"], name: "index_work_space_polling_stations_on_work_space_id"
    end

    [
      :turnout_observations,
      :warp_count_observations,
      :remaining_lifts_observations
    ].each do |table|
      add_reference table,
        :polling_district,
        :integer
      change_column_null table,
        :polling_district_id
        false
    end
end

