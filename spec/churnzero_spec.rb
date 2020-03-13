require 'spec_helper'
require 'pry'

RSpec.describe Churnzero do
  it "has a version number" do
    expect(Churnzero::VERSION).not_to be nil
  end

  describe ".configure" do
    it "can set the app_key" do
      Churnzero.configure do |config|
        config.app_key = 'some-app-key'
      end

      expect(Churnzero.configuration.app_key).to eq 'some-app-key'
    end
  end
end
