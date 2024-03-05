require "capybara/cuprite"
Capybara.register_driver(:headless_cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    browser_options: {"disable-smooth-scrolling" => true},
    headless: !ENV["HEADLESS"].in?(%w[n 0 no false]),
    inspector: true,
    process_timeout: 10, # Increase Chrome startup wait time (required for stable CI builds)
    timeout: 30, # default is 5
    window_size: [1920, 1080]
  )
end

# Configure Capybara to use :cuprite driver by default
Capybara.default_driver = Capybara.javascript_driver = :headless_cuprite
Capybara.default_max_wait_time = 30
