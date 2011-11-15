require 'spec_helper'

describe Worker::Factory do
  let(:factory) { Worker::Factory.new('worker-name') }
  let(:worker)  { factory.worker }

  before(:each) { Amqp.stubs(:connection).returns(stub('amqp')) }

  describe 'worker' do
    it 'returns a worker' do
      worker.should be_a(Worker::Worker)
    end

    it 'has a vm' do
      worker.vm.should be_a(VirtualMachine::VirtualBox)
    end

    describe 'queue' do
      it 'is an amqp queue' do
        worker.queue.should be_a(Amqp::Consumer)
      end

      it 'has the reporting key "builds"' do
        worker.queue.name.should == 'builds.ruby'
      end
    end

    describe 'reporter' do
      it 'is a Reporter' do
        worker.reporter.should be_a(Reporter)
      end

      it 'has a reporting exchange' do
        worker.reporter.exchange.should be_a(Amqp::Publisher)
      end

      it 'has the reporting key "reporting.jobs"' do
        worker.reporter.exchange.routing_key.should == 'reporting.jobs'
      end
    end
  end
end