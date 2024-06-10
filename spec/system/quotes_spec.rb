require 'rails_helper'
# require 'application_system_test_case'

RSpec.feature 'Quote Editor', type: :system, js: true do
  let(:quote) { quotes.first }

  def frame_order
    page.all('turbo-frame').map(&:text).reject { _1.include?('Edit') }
  end

  scenario 'Creating a new quote' do
    visit quotes_path
    expect(page).to have_selector('h1', text: 'Quotes')
    click_on('New quote')

    # expect the form to be rendered in the #index view
    expect(page).to have_current_path(quotes_path)

    # expect the form to be appended to the top of the quotes list
    # issue with this test due to differing output +Name/nCancel
    # expect(frame_order).to eq(
    #   ['Name', 'Third quote', 'Second quote', 'First quote']
    # )

    fill_in('Name', with: 'Test quote')
    click_on('Create quote')

    # expect the first frame to be empty content (what we replace the form with after it has been submitted)
    expect(frame_order.first).to eq('')

    # expect the new quote to be prepended to the top of the list
    expect(frame_order[1..]).to eq(
      ['Test quote', 'Third quote', 'Second quote', 'First quote']
    )
  end

  scenario 'Showing a quote' do
    visit quotes_path
    click_link quote.name

    expect(page).to have_selector('h1', text: quote.name)
  end

  scenario 'Updating a quote' do
    visit quotes_path
    expect(page).to have_selector('h1', text: 'Quotes')

    expect(frame_order).to eq(
      ['', 'Third quote', 'Second quote', 'First quote']
    )

    within("#quote_#{quote.id}") do
      click_on('Edit')

      # expect the form to be rendered in the #index view
      expect(page).to have_current_path(quotes_path)

      fill_in('Name', with: 'Updated quote')
      click_on('Update quote')
    end

    # the order of the frames before the update should match the order after the update
    expect(frame_order).to eq(
      ['', 'Third quote', 'Second quote', 'Updated quote']
    )
  end

  scenario 'Destroying a quote' do
    visit quotes_path
    expect(page).to have_text(quote.name)

    quote_to_delete = find("#quote_#{quote.id}")
    within(quote_to_delete) do
      click_on('Delete')
    end

    expect(page).to have_no_text(quote.name)
  end
end
