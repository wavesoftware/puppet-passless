#!/usr/bin/env ruby

require 'logger'

@logger = Logger.new(STDOUT)

def rake(task)
  @logger.info "Executing: rake #{task}..."
  system "rake #{task}"
  raise "rake #{task} exited with exit status of #{$?.exitstatus}" unless $?.success?
end

key = ENV['LITMUS_KEY'] || 'default'
collection = ENV['LITMUS_COLLECTION'] || 'puppet6'

begin
  rake "litmus:provision_list[#{key}]"
  rake "litmus:install_agent[#{collection}]"
  rake 'litmus:install_module'
  
  rake 'litmus:acceptance:parallel'
ensure
  rake 'litmus:tear_down'
end
