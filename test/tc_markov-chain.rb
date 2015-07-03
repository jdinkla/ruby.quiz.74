#
# (c) 2006 Joern Dinkla, www.dinkla.com
#
require 'test/unit'
require 'markov-chain'

# extend the class for testing
class MarkovChain
  attr_reader :absolute, :relative, :sum_edges, :dirty
end

#
class TestMarkovChain < Test::Unit::TestCase

  def setup()
    @mc1 = MarkovChain.new()
    @mc2 = MarkovChain.new()
    @mc2.add(1,2) 
    @mc3 = MarkovChain.new()
    @mc3.add(1,2) 
    @mc3.add(3,4)
    @mc3.recalc(3)
    @mc4 = MarkovChain.new()
    @mc4.add(1,2) 
    @mc4.add(3,4)
    @mc4.add(1,3)
    @mc4.add(1,4)
    @mc4.add(1,3)
    @mc4.recalc_all()
  end
  
  def test_initialize()
    sub_test_sizes(@mc1, 0, 0, 0, 0)
  end

  #
  def test_add_mc2()
    sub_test_sizes(@mc2, 1, 0, 1, 1)
  end

  #
  def test_add_mc3()
    sub_test_sizes(@mc3, 2, 1, 2, 1)
  end

  #
  def test_add_mc4()
    sub_test_sizes(@mc4, 2, 2, 2, 0)
  end
  
  def test_absolute()
    assert_equal({}, @mc1.absolute)
    assert_equal({1=>{2=>1}}, @mc2.absolute)
    assert_equal({1=>{2=>1}, 3=>{4=>1}}, @mc3.absolute)
    assert_equal({1=>{2=>1,3=>2, 4=>1}, 3=>{4=>1}}, @mc4.absolute)
  end

  def test_relative()
    assert_equal({}, @mc1.relative)
    assert_equal({}, @mc2.relative)
    assert_equal({3=>{4=>1}}, @mc3.relative)
    assert_equal({1=>{2=>0.25,3=>0.75, 4=>1.0}, 3=>{4=>1}}, @mc4.relative)
  end
  
  def test_dirty()
    assert_equal({}, @mc1.dirty)
    assert_equal({1=>true}, @mc2.dirty)
    assert_equal({1=>true}, @mc3.dirty)
    assert_equal({}, @mc4.dirty)
  end
  
  def test_sum_edges()
    assert_equal({}, @mc1.sum_edges)
    assert_equal({1 => 1}, @mc2.sum_edges)
    assert_equal({1 => 1, 3=>1}, @mc3.sum_edges)
    assert_equal({1 => 4, 3=>1}, @mc4.sum_edges)
  end

  #
  def test_rand()
    n = 10
    1.upto(n) { assert_nil(@mc1.rand(nil)) }
    1.upto(n) { assert_nil(@mc1.rand("x")) }
    1.upto(n) { assert_equal(2, @mc2.rand(1)) }
    1.upto(n) { assert_equal(2, @mc3.rand(1)) }
    1.upto(n) { assert_equal(4, @mc3.rand(3)) }
    1.upto(n*n) { assert_not_nil([2,3,4].index(@mc4.rand(1))) }
    1.upto(n) { assert_nil(@mc4.rand(2)) }
    1.upto(n) { assert_equal(4, @mc4.rand(3)) }
    1.upto(n) { assert_nil(@mc2.rand(4)) }
  end
    
  #
  def sub_test_sizes(mc, a, b, c, d)
    assert_equal(a, mc.absolute.length())
    assert_equal(b, mc.relative.length())
    assert_equal(c, mc.sum_edges.length())
    assert_equal(d, mc.dirty.length())
  end
  
end

