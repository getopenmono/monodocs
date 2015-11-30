#!/usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
require 'gollum/app'

gollum_path = File.expand_path(File.dirname(__FILE__))
wiki_options = {:universal_toc => true}
Precious::App.set(:gollum_path, gollum_path)
Precious::App.set(:default_markup, :markdown)
Precious::App.set(:wiki_options, wiki_options)
run Precious::App
