# frozen_string_literal: true

require 'locale_manager/base'
require 'yaml'
require 'pry'

RSpec.describe LocaleManager::Base do
  subject(:locale_manager) { described_class.new filepath }
  let(:filepath) { 'spec/locale_manager/files/test-en.yml' }
  let(:fr_filepath) { 'spec/locale_manager/files/test-fr.yml' }
  let(:original_filepath) { 'spec/locale_manager/files/original/original.test-en.yml' }

  it 'loads and parses a yaml file' do
    expect { locale_manager }.not_to raise_error
  end

  let(:original_yml) { YAML.unsafe_load(File.read(original_filepath)) }

  after do
    system "rm #{filepath}"
    system "cat #{original_filepath} >> #{filepath}"
  end

  describe '#sort' do
    before { locale_manager.sort }

    it 'sorts the keys of the yaml file' do
      sorted_yml = YAML.unsafe_load(File.read(filepath))

      expect(sorted_yml['en'].keys).to match original_yml['en'].keys.sort
      expect(sorted_yml['en']['buttons'].keys).to eq original_yml['en']['buttons'].keys.sort
      expect(sorted_yml['en']['buttons']['another_key'].keys).to eq original_yml['en']['buttons']['another_key'].keys.sort
    end

    context 'for a different locale than english' do
      let(:filepath) { 'spec/locale_manager/files/test-fr.yml' }
      let(:original_filepath) { 'spec/locale_manager/files/original/original.test-fr.yml' }
      let(:locale) { 'fr' }

      it 'sorts the keys of the french locale file' do
        sorted_yml = YAML.unsafe_load(File.read(filepath))

        expect(sorted_yml['fr'].keys).to match original_yml['fr'].keys.sort
        expect(sorted_yml['fr']['buttons'].keys).to eq original_yml['fr']['buttons'].keys.sort
        expect(sorted_yml['fr']['buttons']['another_key'].keys).to eq original_yml['fr']['buttons']['another_key'].keys.sort
      end
    end
  end

  describe '#add_new' do
    let(:value) { 'new value' }
    let(:yml) { YAML.unsafe_load(File.read(filepath)) }
    let(:locale) { 'en' }

    context 'with english locale' do
      context 'when appended at second level' do
        let(:key) { 'en.new_key' }

        before { locale_manager.add_new(key, value) }

        it 'adds a new key' do
          expect(yml[locale].keys).to include 'new_key'
          expect(yml[locale]['new_key']).to eq 'new value'
        end
      end

      context 'when appended in third level' do
        let(:key) { 'en.buttons.new_key' }

        before { locale_manager.add_new(key, value) }

        it 'adds a new three level nested key' do
          expect(yml[locale]['buttons'].keys).to include 'new_key'
          expect(yml[locale]['buttons']['new_key']).to eq 'new value'
        end
      end

      context 'when appended in fourth level' do
        let(:key) { 'en.buttons.another_key.new_nested_key' }

        before { locale_manager.add_new(key, value) }

        it 'adds a new four level nested key' do
          expect(yml[locale]['buttons']['another_key']).to have_key 'new_nested_key'
          expect(yml[locale]['buttons']['another_key']['new_nested_key']).to eq 'new value'
        end
      end
    end

    context 'with other locale' do
      let(:filepath) { 'spec/locale_manager/files/test-fr.yml' }
      let(:original_filepath) { 'spec/locale_manager/files/original/original.test-fr.yml' }
      let(:locale) { 'fr' }
      let(:value) { 'nouvelle valeur' }

      context 'when appended at second level' do
        let(:key) { 'fr.new_key' }

        before { locale_manager.add_new(key, value) }

        it 'adds a new key' do
          expect(yml[locale].keys).to include 'new_key'
          expect(yml[locale]['new_key']).to eq 'nouvelle valeur'
        end
      end

      context 'when appended in third level' do
        let(:key) { 'fr.buttons.new_key' }

        before { locale_manager.add_new(key, value) }

        it 'adds a new three level nested key' do
          expect(yml[locale]['buttons'].keys).to include 'new_key'
          expect(yml[locale]['buttons']['new_key']).to eq 'nouvelle valeur'
        end
      end

      context 'when appended in fourth level' do
        let(:key) { 'fr.buttons.another_key.new_nested_key' }

        before { locale_manager.add_new(key, value) }

        it 'adds a new four level nested key' do
          expect(yml[locale]['buttons']['another_key']).to have_key 'new_nested_key'
          expect(yml[locale]['buttons']['another_key']['new_nested_key']).to eq 'nouvelle valeur'
        end
      end
    end
  end

  describe '#del' do
    let(:key) { 'en.errors' }

    before { locale_manager.del(key) }

    it 'removes the specified key' do
      yml = YAML.unsafe_load(File.read(filepath))
      expect(yml['en'].keys).not_to include 'errors'
    end
  end

  describe '#update_key' do
    subject(:update_key) { locale_manager.update_key(key, 'updated_key') }
    let(:key) { 'en.errors' }

    it 'updates the key' do
      update_key
      yml = YAML.unsafe_load(File.read(filepath))

      expect(update_key).to be_truthy
      expect(yml['en'].keys).to include 'updated_key'
    end

    context 'when key is at third level' do
      let(:key) { 'en.buttons.show_advanced_settings' }

      it 'updates the nested key' do
        update_key
        yml = YAML.unsafe_load(File.read(filepath))

        expect(update_key).to be_truthy
        expect(yml['en']['buttons'].keys).to include 'updated_key'
        expect(yml['en']['buttons']['updated_key']).to eq 'Advanced settings'
      end
    end

    context 'when the key is at fourth level' do
      let(:key) { 'en.buttons.another_key.add_key' }

      it 'updates the nested key' do
        update_key
        yml = YAML.unsafe_load(File.read(filepath))

        expect(update_key).to be_truthy
        expect(yml['en']['buttons']['another_key'].keys).to include 'updated_key'
        expect(yml['en']['buttons']['another_key']['updated_key']).to eq 'Something first'
      end
    end
  end
end
