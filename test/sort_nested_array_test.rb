require 'test_helper'

class SortNestedArrayTest < Minitest::Test
  def test_sort_node_by_sku
    expected = [
      { id: 1, products: [ { sku: 'a' }, { sku: 'b' }, { sku: 'c' } ] }
    ]
    a = [
      { id: 1, products: [ { sku: 'c' }, { sku: 'a' }, { sku: 'b' } ] }
    ]
    a.extend(NestedArrayHelpers)

    assert_equal expected, a.sort_nested_array(:products, :sku)
  end

  def test_sort_node_by_title
    expected = [
      { id: 1, products: [ { title: 'a' }, { title: 'b' }, { title: 'c' } ] }
    ]
    a = [
      { id: 1, products: [ { title: 'c' }, { title: 'a' }, { title: 'b' } ] }
    ]
    a.extend(NestedArrayHelpers)

    assert_equal expected, a.sort_nested_array(:products, :title)
  end

  def test_sort_another_node_by_title
    expected = [
      { id: 1, line_items: [ { title: 'a' }, { title: 'b' }, { title: 'c' } ] }
    ]
    a = [
      { id: 1, line_items: [ { title: 'c' }, { title: 'a' }, { title: 'b' } ] }
    ]
    a.extend(NestedArrayHelpers)

    assert_equal expected, a.sort_nested_array(:line_items, :title)
  end
end
