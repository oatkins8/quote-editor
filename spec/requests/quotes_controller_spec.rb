require 'rails_helper'

RSpec.describe "Quotes", type: :request do
  describe "GET #index /quotes" do
    def do_request(url: "/quotes", params: {})
      get url, params: params
    end

    let(:quote1) { quotes(:first) }

    it "renders" do
      do_request

      expect(response).to be_successful
    end

    it "displays the first quote" do
      do_request

      expect(page).to have_text(quote1.name)
    end
  end
end
