module VarnishTestHelper
  def varnish_uri(path)
    URI( URI.join('http://localhost:4567/', path) )
  end

  def self.varnish_uri(path)
    URI( URI.join('http://localhost:4567/', path) )
  end

  def self.start_varnish
    require 'open3'
    varnishcmd = "varnishd -F -p vcl_dir=#{Rails.root + 'config'} -f #{Rails.root + 'config/varnish.test.vcl'} -a :4567"
    Open3.popen3(varnishcmd)
  end

  def self.start_rails
    require 'open3'
    railscmd = "rails s --port 3456 -e test"
    Open3.popen3(railscmd)
  end

  def self.process_close(io_and_process)
    pid = io_and_process.last.pid.to_i
    io_and_process[0..2].map(&:close)
    begin
      Process.kill("TERM", pid)
    rescue Errno::ESRCH
      puts "Could not kill #{pid} - does not exist?"
    end
  end

  def self.setup!
    $varnish           = start_varnish
    $integration_rails = start_rails

    begin
      Timeout.timeout(3) do
        print "Waiting for varnish"
        loop do
          print "."
          sleep(0.1)
          response = Net::HTTP.get_response(varnish_uri('/static/about')) rescue nil
          break if response && response.code.to_i == 200
        end
        puts "ready!"
      end
    rescue Timeout::Error
      process_close($varnish)
      process_close($integration_rails)
      fail "Timed out starting Varnish!"
    rescue => e
      process_close($varnish)
      process_close($integration_rails)
      fail(e)
    end

    MiniTest.after_run do
      process_close($varnish)
      process_close($integration_rails)
    end
  end
end

