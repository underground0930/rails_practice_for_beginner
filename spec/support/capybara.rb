RSpec.configure do |config|
  config.before(:each) do
    driven_by :rack_test, screen_size: [1920, 1080]
  end

  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1920, 1080]
  end
end
