#!/usr/bin/env ruby

require 'rake'
require 'logger'

logger = Logger.new(STDOUT)

def rake(task)
  app = Rake.application
  app.init
  app.load_rakefile
  app[task]
end

begin
  logger.info('Running Litmus provision & install with gitlab group and puppet6...')
  rake('litmus:provision_install').invoke('gitlab', 'puppet6')
  logger.info('Checking installed modules...')
  system("bolt command run 'puppet --version && puppet module list --tree' -i inventory.yaml -n '*'")
  logger.info('Running acceptance tests in parallel...')
  rake('litmus:acceptance:parallel').invoke
ensure
  logger.info('Tear down...')
  rake('litmus:tear_down').invoke
end
