require_relative "./test_helper"
require "test/unit"
require "palta"

class TestServer < Test::Unit::TestCase

  def test_default_creation_yields_no_error
    s = Palta::Server.new
  end

  def test_creation_with_paramaters_ok
    options = {
      :host => "127.0.0.1",
      :port => 9898,
      :debug => true,
      :dir => ".palta-data",
      :max_threads => 16
    }
    s = Palta::Server.new options
    assert_equal options[:host], s.host
    assert_equal options[:port], s.port
    assert_equal options[:debug], s.debug
    assert_equal options[:dir], s.dir
    assert_equal options[:max_threads], s.max_threads
  end

  def test_with_wrong_port_should_fail_to_start
    # Without root permissions the server should fail to start in a
    # port number lower than 1024
    options = {
      :port => 567
    }
    s = Palta::Server.new options
    assert_raise Errno::EACCES do
      s.start
      s.stop
    end
  end

  def test_with_wrong_host_should_fail_to_start
    # See http://stackoverflow.com/questions/10456044/what-is-a-good-invalid-ip-address-to-use-for-unit-tests
    # for info about IP addresses that should not be routed anywhere
    options = {
      :host => "192.0.2.1"
    }
    s = Palta::Server.new options
    assert_raise Errno::EADDRNOTAVAIL do
      s.start
      s.stop
    end
  end
end
