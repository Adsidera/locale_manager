# frozen_string_literal: true

# require File.expand_path('lib/locale_manager/base', __dir__)
require File.expand_path('lib/locale_manager/multiple_manager', __dir__)
require 'pry'
require 'colorize'

namespace :lm do
  desc 'Sorts all YAML files specified.'
  task :sort do
    ARGV.delete_at(0)
    ARGV.each do |filepath|
      lm = LocaleManager::Base.new filepath
      begin
        lm.sort
        puts 'A sorted version of '.yellow + filepath.red + ' is now available'.yellow
      rescue StandardError => e
        puts e
      end
    end
  end

  desc 'Adds or updates a new key/value to a specified YAML file. Keys must be specified in their full path'
  task :add do
    ARGV.delete_at(0)
    key = ARGV[0]
    value = ARGV[1]
    filepath = ARGV.last

    lm = LocaleManager::Base.new filepath
    begin
      lm.add_new(key, value)
      puts "#{key.red}: #{value.cyan}#{' was added to '.yellow}#{filepath.yellow}"
    rescue StandardError => e
      puts e.red
    end
  end

  desc 'Removes a key from a specified YAML file'
  task :del do
    ARGV.delete_at(0)
    key = ARGV[0]
    filepath = ARGV.last

    lm = LocaleManager::Base.new filepath
    begin
      lm.del(key)
      puts key.red + ' removed from '.yellow + filepath.yellow
    rescue StandardError => e
      puts e.to_s.red
    end
  end

  desc 'Updates a key but maintains its value for a specific YAML file'
  task :update_key do
    ARGV.delete_at(0)
    key = ARGV[0]
    value = ARGV[1]
    filepath = ARGV.last

    lm = LocaleManager::Base.new filepath
    begin
      lm.update_key(key, value)
      puts "#{'Changed '.yellow}#{key.red} to #{value.cyan} in #{filepath.yellow}"
    rescue StandardError => e
      puts e.red
    end
  end

  desc 'Adds multiple translations'
  # rake lm:add_multiple path/to/files new.key en:en_key fr:fr_key etc.
  task :add_multiple do
    ARGV.delete_at(0)
    directory = ARGV.delete_at(0)
    key = ARGV.delete_at(0)
    trans = ARGV
    hash = {}
    trans.each do |translation|
      arr = translation.split(':')
      hash[arr.first] = arr.last
    end

    translations = { key:, values: hash }
    begin
      lm = LocaleManager::MultipleManager.new(directory)
      lm.add_multiple translations
      puts "Added translations for all files in #{directory}".yellow
    rescue TypeError => e
    rescue StandardError => e
      puts 'Done with errors'.red
    end
  end
end
