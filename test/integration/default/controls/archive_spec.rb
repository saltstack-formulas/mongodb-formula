# frozen_string_literal: true

control 'mongodb components' do
  title 'should be installed'

  # describe package('unzip') do
  #   it { should be_installed }
  # end
  # describe group('mongodb') do
  #   it { should exist }
  # end
  # describe user('mongodb') do
  #   it { should exist }
  # end
  describe group('mongos') do
    it { should exist }
  end
  # describe user('mongos') do
  #   it { should exist }
  # end
  describe directory('/var/lib/mongodb') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  # describe directory('/usr/local/mongodb/dbtools-100.0.1') do
  #   it { should exist }
  #   its('group') { should eq 'root' }
  # end
  # describe file('/usr/local/mongodb/dbtools-100.0.1/bin/mongodump') do
  #   it { should exist }
  #   its('group') { should eq 'root' }
  # end
  # describe file('/usr/local/mongodb/dbtools-100.0.1/bin/bsondump') do
  #   it { should exist }
  #   its('group') { should eq 'root' }
  # end
  describe directory('/tmp/downloads') do
    it { should exist }
  end
  describe directory('/usr/local/mongodb/mongod-4.2.6') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/usr/local/mongodb/mongod-4.2.6/bin/mongod') do
    it { should exist }
  end
  describe file('/usr/local/mongodb/mongod-4.2.6/bin/mongos') do
    it { should exist }
  end
  describe directory('/var/lib/mongodb/mongod') do
    it { should exist }
  end
  describe file('/usr/lib/systemd/system/mongod.service') do
    it { should exist }
    its('group') { should eq 'root' }
    its('mode') { should cmp '0644' }
  end
  describe directory('/usr/local/mongodb/robo3t-1.3.1') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe file('/usr/local/mongodb/robo3t-1.3.1/bin/robo3t') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe directory('/usr/local/mongodb/robo3t-1.3.1/include') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  describe directory('/usr/local/mongodb/kafka-1.1.0') do
    it { should exist }
    its('group') { should eq 'root' }
  end
  # describe file('/usr/lib/mongodb/kafka-1.1.0/lib/mongo-kafka-1.1.0-all.jar') do
  #   it { should exist }
  #   its('group') { should eq 'root' }
  #   its('mode') { should cmp '0644' }
  # end
  describe file('/etc/init.d/disable-transparent-hugepages') do
    it { should exist }
    its('mode') { should cmp '0755' }
  end
  describe file('/sys/kernel/mm/transparent_hugepage/enabled') do
    it { should exist }
    its('group') { should eq 'root' }
    # its('content') { should eq 'always madvise [never]' }
  end
  describe file('/etc/mongodb') do
    it { should exist }
    its('owner') { should eq 'root' }
    its('group') { should eq 'root' }
  end
  describe file('/etc/mongodb/mongod.conf') do
    it { should exist }
    its('mode') { should cmp '0644' }
    # its('owner') { should eq 'mongodb' }
    # its('group') { should eq 'mongodb' }
  end
  describe file('/etc/mongodb/mongos.conf') do
    it { should exist }
    its('mode') { should cmp '0644' }
    its('owner') { should eq 'mongos' }
    its('group') { should eq 'mongos' }
  end
  describe file('/etc/default/mongod.sh') do
    it { should exist }
    its('mode') { should cmp '0640' }
  end
end
