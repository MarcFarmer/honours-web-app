require 'spec_helper'

describe StepsHelper do
  describe '#html_icon' do
    it 'returns nil for an unrecognised icon name' do
      result = html_icon('delete-entire-website')
      expect(result).to eq(nil)
    end

    context 'it returns valid HTML for icon' do
      it 'edit' do
        result = html_icon('edit')
        expect(result.html_safe?).to eq(true)
      end

      it 'remove' do
        result = html_icon('remove')
        expect(result.html_safe?).to eq(true)
      end

      it 'up' do
        result = html_icon('up')
        expect(result.html_safe?).to eq(true)
      end

      it 'down' do
        result = html_icon('down')
        expect(result.html_safe?).to eq(true)
      end

      it 'home' do
        result = html_icon('home')
        expect(result.html_safe?).to eq(true)
      end

      it 'all' do
        result = html_icon('all')
        expect(result.html_safe?).to eq(true)
      end

      it 'back' do
        result = html_icon('back')
        expect(result.html_safe?).to eq(true)
      end

      it 'tab-left' do
        result = html_icon('tab-left')
        expect(result.html_safe?).to eq(true)
      end

      it 'tab-right' do
        result = html_icon('tab-right')
        expect(result.html_safe?).to eq(true)
      end

      it 'info' do
        result = html_icon('info')
        expect(result.html_safe?).to eq(true)
      end
    end

    it 'returns a different icon for names: edit, remove, home, all, back, ok, tab-left, tab-right, info' do
      results = []
      results << html_icon('edit')
      results << html_icon('remove')
      results << html_icon('up')
      results << html_icon('down')
      results << html_icon('home')
      results << html_icon('all')
      results << html_icon('back')
      results << html_icon('ok')
      results << html_icon('tab-left')
      results << html_icon('tab-right')
      results << html_icon('info')
      expect(results).to eq(results.uniq)
    end
  end
end
