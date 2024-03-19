# frozen_string_literal: true

# This class works from a directory,
# that is a list of files. We already know the major
# locales, so we can create a mapping between locales and
# related files.
module LocaleManager
  class MultipleManager
    def initialize(directory)
      @directory = Dir.new(directory)
    end

    def translation_files
      @directory.children.select { |path| path.include? 'yml' }
    end

    def find_translation_file(locale)
      path = translation_files.find { |file| file.include? locale.to_s }
      "#{@directory.path}/" + path
    end

    # @param hash {key: string, values: {locale: string} },
    # e.g, translations = {key: 'new.key', values: {'en': 'This is a new key', 'fr': 'Nouvelle cle'}}
    def add_multiple(translations)
      key = translations[:key]
      values = translations[:values]
      values.each do |k, v|
        tk = ".#{k}.#{key}"
        new_key_value = "\'#{tk}=\"#{v}\"\'"
        filepath = find_translation_file(k)

        system "yq -i  #{new_key_value}  #{filepath}"
      end
    end
  end
end
