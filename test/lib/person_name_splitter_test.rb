require 'test_helper'

class PersonNameSplitterTest < ActiveSupport::TestCase

  test "blank names split into nils" do
    assert_equal [nil, nil], PersonNameSplitter.split(nil)
    assert_equal [nil, nil], PersonNameSplitter.split('')
    assert_equal [nil, nil], PersonNameSplitter.split('   ')
  end

  test "given family" do
    assert_equal ['Thomas', 'Herrmann'], PersonNameSplitter.split('Thomas Herrmann')
  end

  test "multi token given name" do
    assert_equal ['Anna Maria', 'Müller'], PersonNameSplitter.split('Anna Maria Müller')
  end

  test "family comma given" do
    assert_equal ['Thomas', 'Herrmann'], PersonNameSplitter.split('Herrmann, Thomas')
    assert_equal ['Anna Maria', 'Müller'], PersonNameSplitter.split('Müller,Anna Maria')
  end

  test "comma with missing part" do
    assert_equal [nil, 'Herrmann'], PersonNameSplitter.split('Herrmann,')
    assert_equal ['Thomas', nil], PersonNameSplitter.split(', Thomas')
  end

  test "single token becomes given name" do
    assert_equal ['Marius', nil], PersonNameSplitter.split('Marius')
  end

  test "surrounding and repeated whitespace is ignored" do
    assert_equal ['Thomas', 'Herrmann'], PersonNameSplitter.split("  Thomas \t Herrmann  ")
  end

  test "ambiguous detection" do
    assert PersonNameSplitter.ambiguous?('Marius')
    assert PersonNameSplitter.ambiguous?('Anna Maria von der Heide')
    assert_not PersonNameSplitter.ambiguous?('Thomas Herrmann')
    assert_not PersonNameSplitter.ambiguous?('Anna Maria Müller')
    assert_not PersonNameSplitter.ambiguous?('von der Heide, Anna Maria')
    assert_not PersonNameSplitter.ambiguous?(nil)
  end

end
