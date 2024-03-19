# frozen_string_literal: true

require 'pry'

module LocaleManager
  # This class provides support for sorting yml locale files and
  # adding/changing keys.
  class Base
    attr_reader :locale

    def initialize(filepath, *_args)
      @filepath = filepath
    end

    # sorts yaml file using yq
    def sort
      system "yq -i -P 'sort_keys(..)' #{@filepath}"
    end

    # add new keys
    # it can add keys second, third, fourth
    # level nested keys. It can only work if the parent key
    # has not a value assigned.
    # It also updates the value of a preexisting key.
    def add_new(key, value)
      new_key = ".#{key}"
      new_key_value = "\'#{new_key}=\"#{value}\"\'"

      system "yq -i  #{new_key_value}  #{@filepath}"
    end

    # delete existing key
    def del(key)
      system "yq -i 'del(.#{key})' #{@filepath}"
    end

    def update_key(key, value)
      new_key = ".#{key}"
      new_key_value = "\'(#{new_key} | key) = \"#{value}\"\'"

      system "yq -i  #{new_key_value}  #{@filepath}"
    end
  end
end
