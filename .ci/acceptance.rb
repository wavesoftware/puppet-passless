#!/usr/bin/env ruby

require 'rake'
require 'logger'

logger = Logger.new(STDOUT)

begin
  logger.info 'Running Litmus provision & install with gitlab group and puppet6...'
  system 'rake litmus:provision_install[gitlab,puppet6]'
  logger.info 'Checking installed modules...'
  system "bolt command run 'puppet --version && puppet module list --tree' -i inventory.yaml -n '*'"
  logger.info 'Running acceptance tests in parallel...'
  system 'rake litmus:acceptance:parallel'
ensure
  logger.info 'Tear down...'
  system 'rake litmus:tear_down'
end
