# frozen_string_literal: true

require 'locale_manager/multiple_manager'
require 'yaml'
require 'pry'

RSpec.describe LocaleManager::MultipleManager do
  subject(:locale_manager) { described_class.new directory }
  let(:directory) { 'spec/locale_manager/files/' }
  let(:original_directory) { 'spec/locale_manager/files/original/' }

  it 'loads a directory' do
    expect { locale_manager }.not_to raise_error
  end

  after do
    %w[test-en.yml test-fr.yml].each do |filepath|
      system "rm #{directory}#{filepath}"
      system "cat #{original_directory}original.#{filepath} >>  #{directory}#{filepath}"
    end
  end

  it 'adds translations to all files in the directory' do
    translations = { key: 'dummy.key', values: { 'en': 'New new key', 'fr': 'Nouvelle clé' } }

    expect(locale_manager.add_multiple(translations)).to be_truthy

    en_yml = YAML.unsafe_load(File.read('spec/locale_manager/files/test-en.yml'))
    fr_yml = YAML.unsafe_load(File.read('spec/locale_manager/files/test-fr.yml'))

    expect(en_yml['en']['dummy']['key']).to eq 'New new key'
    expect(fr_yml['fr']['dummy']['key']).to eq 'Nouvelle clé'
  end
end
