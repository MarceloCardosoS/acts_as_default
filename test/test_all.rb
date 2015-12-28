require 'rubygems'
require 'active_record'
require 'minitest/autorun'
require_relative '../lib/acts_as_default'
require_relative 'test_objects'
require 'coveralls'

Coveralls.wear!

class TestAll < Minitest::Unit::TestCase

  def setup
    setup_objects
  end

  def teardown
  end

  def test_simple
    Parent.delete_all

    3.times do
      p = Parent.new
      p.save!
    end

    assert_equal true, Parent.first.default_val
    assert_equal true, contains_one_default?(Parent.all)
  end

  def test_standard
    Son.delete_all
    Parent.delete_all

    2.times do
      p = Parent.new
      p.save!
      3.times do
        s = Son.new
        s.parent = p
        s.save!
      end
    end

    #check default
    assert_equal true, contains_one_default?(Parent.first.sons)
    assert_equal true, contains_one_default?(Parent.last.sons)

    #check default change to last
    Parent.first.sons.last.set_as_default!
    assert_equal true, Parent.first.sons.last.default_val
    assert_equal true, contains_one_default?(Parent.first.sons)
    assert_equal true, contains_one_default?(Parent.last.sons)

    #check default change back to first
    Parent.first.sons.first.set_as_default!
    assert_equal true, Parent.first.sons.first.default_val
    assert_equal true, contains_one_default?(Parent.first.sons)
    assert_equal true, contains_one_default?(Parent.last.sons)

    #check destroy of non default
    Parent.first.sons.last.destroy!
    assert_equal true, Parent.first.sons.first.default_val
    assert_equal true, contains_one_default?(Parent.first.sons)
    assert_equal true, contains_one_default?(Parent.last.sons)

    #check destroy of default
    Parent.first.sons.first.destroy!
    assert_equal true, Parent.first.sons.first.default_val
    assert_equal true, contains_one_default?(Parent.first.sons)
    assert_equal true, contains_one_default?(Parent.last.sons)
  end

  def contains_one_default?(collection)
    collection.where(default_val: true).size == 1
  end
end