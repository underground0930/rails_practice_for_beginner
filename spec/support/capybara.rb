RSpec.configure do |config|
  config.before(:each, type: :system) do
    # Capybara.reset_sessions!
    driven_by :selenium, using: :headless_chrome, screen_size: [1000, 600] do |driver_options|
      driver_options.add_argument('--disable-dev-sim-usage')
      driver_options.add_argument('--no-sandbox')
    end
  end
end
