# frozen_string_literal: true

control 'mongodb package' do
  title 'should be installed'

  pkg = 'mongodb-org'

  describe package(pkg) do
    it { should be_installed }
  end
end
