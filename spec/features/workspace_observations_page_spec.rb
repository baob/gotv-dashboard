require 'rails_helper'

RSpec.feature 'raw data page', type: :feature, js: true do
  it 'shows all past turnout observations' do
    work_space = create(:work_space)
    create(
      :turnout_observation,
      count: 42,
      work_space: work_space,
      user: create(:user, name: 'Some Campaigner', phone_number: '555 123'),
      work_space_polling_station: create(
        :work_space_polling_station,
        polling_station: create(
          :polling_station, name: 'First Polling Station'
        )
      )
    )
    create(
      :turnout_observation,
      count: 66,
      work_space: work_space,
      work_space_polling_station: create(
        :work_space_polling_station,
        polling_station: create(
          :polling_station, name: 'Second Polling Station'
        )
      )
    )

    visit observations_work_space_path(work_space)

    expect(page).to have_text('First Polling Station')
    expect(page).to have_text('42')
    expect(page).to have_text('Some Campaigner')
    expect(page).to have_text('Second Polling Station')
    expect(page).to have_text('66')
  end
end
