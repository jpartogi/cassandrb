require 'rubygems'
require "bundler/setup"

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'cassandra'
require 'cassandra/mock'
require 'cassandrb'