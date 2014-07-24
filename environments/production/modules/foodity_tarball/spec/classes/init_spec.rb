require 'spec_helper'
describe 'tarball' do

  context 'with defaults for all parameters' do
    it { should contain_class('tarball') }
  end
end
