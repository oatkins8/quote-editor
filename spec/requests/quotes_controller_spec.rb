require 'rails_helper'

RSpec.describe "Quotes", type: :request do
  describe "GET #index /quotes" do
    def do_request(url: "/quotes", params: {})
      get url, params: params
    end

    it "renders" do
      do_request

      expect(response).to be_successful
    end

    it "displays the all three Quotes" do
      do_request

      Quote.all.each do |quote|
        expect(page).to have_text(quote.name)
      end
    end
  end

  describe "GET #new /quotes/new" do
    def do_request(url: "/quotes/new", params: {})
      get url, params: params
    end

    it "renders" do
      do_request

      expect(response).to be_successful
    end
    
    it "displays the submit input" do
      do_request
      
      expect(page).to have_selector("input", class: "btn btn--secondary")
    end
  end
  
  describe "POST #create /quotes" do
    def do_request(url: "/quotes", params: {})
      post url, params: params
    end
    
    context "successful" do
      let(:params) {{quote: {name: "A famous thing once said"}}}
      
      it "creates a new Quote" do
        expect{ do_request(params: params) }.to change { Quote.count }.by(1)
      end
      
      it "redirects to quotes_path" do
        do_request(params: params)
        
        expect(response).to redirect_to(quotes_path)
      end
      
      it "displays a notice" do
        do_request(params: params)
        
        expect(flash[:notice]).to include("created")
      end
    end
    
    context "unsuccessful, name is an empty string" do
      let(:params) {{quote: {name: ""}}}
      
      it "does not create a new Quote" do
        expect{ do_request(params: params) }.not_to change { Quote.count }
      end
      
      it "renders :new" do
        do_request(params: params)
        
        expect(page).to have_selector('.header', text: "New quote")
      end
    end
  end

  describe "GET #show /quotes/:quote_id" do
    def do_request(url: "/quotes/#{quote.id}", params: {})
      get url, params: params
    end

    let(:quote) { quotes(:first) }

    it "renders" do
      do_request

      expect(response).to be_successful
    end

    it "displays the quote name as a header" do
      do_request

      expect(page).to have_text(quote.name)
    end

    it "displays the link back to the index" do
      do_request

      expect(page).to have_link("Back to quotes")
    end
  end

  describe "GET #edit /quote/:id/edit" do
    def do_request(url: "/quotes/new", params: {})
      get url, params: params
    end

    it "renders" do
      do_request

      expect(response).to be_successful
    end

    it "displays the submit input" do
      do_request

      expect(page).to have_selector("input", class: "btn btn--secondary")
    end
  end

  describe "PUT #update /quotes" do
    def do_request(url: "/quotes/#{quote.id}", params: {})
      put url, params: params
    end

    let(:quote) { quotes(:first) }
    let(:params) {{quote: {name: "This is a new name for this quote"}}}

    context "successful" do
      it "changes the name of the quote" do
        expect { do_request(params: params) }.to change { quote.reload.name }
          .from("First quote")
          .to("This is a new name for this quote")
      end

      it "redirects to quotes_path" do
        do_request(params: params)
        
        expect(response).to redirect_to(quotes_path)
      end
    end

    context "unsuccessful" do
      let(:params) {{quote: {name: ""}}}

      it "does not change the name of the quote" do
        expect { do_request(params: params) }.not_to change { quote.name }
      end

      it "renders :edit" do
        do_request(params: params)

        expect(page).to have_selector('.header', text: "Edit quote")
      end
    end
  end

  describe "DELETE #destroy /quotes/:quote_id" do
    def do_request(url: "/quotes/#{quote.id}", params: {})
      delete url, params: params
    end

    let(:quote) { quotes(:first) }

    context "successful" do
      it "destroys the quote" do
        expect { do_request }.to change { Quote.count }.by(-1)
        expect(Quote.find_by(id: quote.id)).to be_nil
      end

      it "displays a notice" do
        do_request

        expect(flash[:notice]).to include("destroyed")
      end
    end
  end
end
