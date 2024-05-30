require 'rails_helper'
# require 'application_system_test_case'

RSpec.feature 'Quote Editor', type: :system, js: true do
  let!(:quote) { quotes(:first) }

  # when we click on the 'New quote' button:
  # - we expect a name text field to appear
  # - we expect to be able to fill out the name text field with a quote
  # - we expect to be able to save that quote after clicking 'Create quote'
  # - we expect the quote to be visibly saved below all the other saved quotes

  scenario 'Creating a new quote' do
    visit quotes_path
    expect(page).to have_selector('h1', text: 'Quotes')

    click_on('New quote')
    expect(page).to have_current_path('/quotes')

    fill_in('Name', with: 'Test quote')
    click_on('Create quote')
    expect(page).to have_text('Test quote')

    quotes_order = page.all('.quote a').map(&:text).reject { _1 == 'Edit' }
    expect(quotes_order).to eq(
      [['First quote', 'Second quote', 'Third quote', 'Test quote']]
    )
  end

  scenario 'Showing a quote' do
    visit quotes_path
    click_link quote.name

    expect(page).to have_selector('h1', text: quote.name)
  end

  # # when we click on the 'Edit quote' button:
  # # - we expect a name text field to appear
  # # - we expect to be able to fill out the name text field with a new quote
  # # - we expect to be able to save that quote after clicking 'Update quote'
  # # - we expect the quote to be saved with the new name in the same position

  scenario 'Updating a quote' do
    page.driver.debug(binding.irb)
    visit quotes_path
    expect(page).to have_selector('h1', text: 'Quotes')

    quote_to_edit = find(:css, 'div.quote', text: 'Second quote')
    within(quote_to_edit) do
      click_on('Edit')
      expect(page).to have_current_path('/quotes')

      fill_in('Name', with: 'Updated second quote')
      expect(page).to have_text('Updated second quote')
    end

    quotes_order = page.all('.quote a').map(&:text).reject { _1 == 'Edit' }
    expect(quotes_order).to eq(
      [['First quote', 'Updated second quote', 'Third quote', 'Test quote']]
    )
  end

  scenario 'Destroying a quote' do
    visit quotes_path
    expect(page).to have_text(quote.name)

    click_on 'Delete', match: :first
    expect(page).to have_no_text(quote.name)
  end
end
