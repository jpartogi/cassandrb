require 'rubygems'
require "bundler/setup"

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'cassandra/0.7'
require 'cassandra/mock'
require 'cassandrb'