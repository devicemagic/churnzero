require "ostruct"
require "churnzero/client"
require "churnzero/version"

module Churnzero
  class Error < StandardError; end

  def self.configuration
    @configuration ||= OpenStruct.new
  end

  def self.configure
    yield(configuration)
  end
end
