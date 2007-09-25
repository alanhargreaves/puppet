#!/usr/bin/env ruby
#
#  Created by Luke Kanies on 2007-9-23.
#  Copyright (c) 2007. All rights reserved.

require File.dirname(__FILE__) + '/../../../spec_helper'

require 'puppet/indirector/code/facts'

describe Puppet::Indirector::Code::Facts do
    it "should be a subclass of the Code terminus" do
        Puppet::Indirector::Code::Facts.superclass.should equal(Puppet::Indirector::Code)
    end

    it "should have documentation" do
        Puppet::Indirector::Code::Facts.doc.should_not be_nil
    end

    it "should be registered with the configuration store indirection" do
        indirection = Puppet::Indirector::Indirection.instance(:facts)
        Puppet::Indirector::Code::Facts.indirection.should equal(indirection)
    end

    it "should have its name set to :facts" do
        Puppet::Indirector::Code::Facts.name.should == :facts
    end
end

module TestingCodeFacts
    def setup
        @facter = Puppet::Indirector::Code::Facts.new
        Facter.stubs(:to_hash).returns({})
        @name = "me"
        @facts = @facter.find(@name)
    end
end

describe Puppet::Indirector::Code::Facts, " when finding facts" do
    include TestingCodeFacts

    it "should return a Facts instance" do
        @facts.should be_instance_of(Puppet::Node::Facts)
    end

    it "should return a Facts instance with the provided key as the name" do
        @facts.name.should == @name
    end

    it "should return the Facter facts as the values in the Facts instance" do
        Facter.expects(:to_hash).returns("one" => "two")
        facts = @facter.find(@name)
        facts.values["one"].should == "two"
    end
end

describe Puppet::Indirector::Code::Facts, " when saving facts" do
    include TestingCodeFacts

    it "should fail" do
        proc { @facter.save(@facts) }.should raise_error(Puppet::DevError)
    end
end

describe Puppet::Indirector::Code::Facts, " when destroying facts" do
    include TestingCodeFacts

    it "should fail" do
        proc { @facter.destroy(@facts) }.should raise_error(Puppet::DevError)
    end
end
