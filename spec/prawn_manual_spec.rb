# frozen_string_literal: true

require 'spec_helper'
require 'digest/sha2'

MANUAL_HASH =
  case RUBY_ENGINE
  when 'ruby'
    'cd8b1757d1f45243f09db4b71a1b45d8eb801d411fa293710ccf995eceedea50'\
    'efa453e9bcc9291e27186e6258f1a828a6a469881624ae5c0af9c604cd972012'
  when 'jruby'
    'd21fbc4db393f430326e8c093697e373b68021ef0c240c6f0dd05c739e7612cc'\
    '3d2039ec399e56c9ce4fddd41ab595c655f0f7c91511751948f8c181c5301ce0'
  end

RSpec.describe Prawn do
  describe 'manual' do
    # JRuby's zlib is a bit quirky. It sometimes produces different output to
    # libzlib (used by MRI). It's still a proper deflate stream and can be
    # decompressed just fine but for whatever reason compressin produses
    # different output.
    #
    # See: https://github.com/jruby/jruby/issues/4244
    it 'contains no unexpected changes' do
      ENV['CI'] ||= 'true'

      require File.expand_path(File.join(__dir__, %w[.. manual contents]))
      s = prawn_manual_document.render

      hash = Digest::SHA512.hexdigest(s)

      expect(hash).to eq MANUAL_HASH
    end
  end
end
