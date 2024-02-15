# Allow Capybara finders to be used on response HTML
# e.g. expect(page).to have_link("Create clips", href: book_upload_path(workspace, book, Upload.last))
# Override #raw_html if using outside of request spec.
module HtmlPageHelper
  def page
    @page ||= Capybara::Node::Simple.new(response.body)
  end

  def raw_html
    response.body
  end
end