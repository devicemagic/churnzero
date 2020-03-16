require "ostruct"
require "net/http"
require "time"
require "churnzero/account"
require "churnzero/client"
require "churnzero/contact"
require "churnzero/event"
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
