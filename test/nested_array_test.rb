gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/nested_array'

class NestedArrayTest < Minitest::Test
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

  def orders
    [
      { id: 1, products: [ { sku: 'c' } ] },
      { id: 2, products: [ { sku: 'b' } ] },
      { id: 3, products: [ { sku: 'a' } ] }
    ].extend(NestedArrayHelpers)
  end

  def test_without_sort_by
    expected = [1, 2, 3]
    assert_equal expected, orders.map{ |o| o[:id] }
  end

  def test_sort_by_sku
    expected = [3, 2, 1]
    assert_equal expected, orders.sort_by_nested_array(:products, :sku).map{ |o| o[:id] }
  end

  def multi_products_orders
    [
      { id: 1, products: [ { sku: 'c' }, { sku: 'c' } ] },
      { id: 2, products: [ { sku: 'b' }, { sku: 'b' } ] },
      { id: 3, products: [ { sku: 'a' }, { sku: 'a' } ] }
    ].extend(NestedArrayHelpers)
  end

  def test_multi_products_sort_by_sku
    expected = [3, 2, 1]
    assert_equal expected, multi_products_orders.sort_by_nested_array(:products, :sku).map{ |o| o[:id] }
  end

  def tricky_orders
    [
      { id: 1, products: [ { sku: 'c' }, { sku: 'a' }, { sku: 'c' } ] },
      { id: 2, products: [ { sku: 'a' }, { sku: 'c' }, { sku: 'a' } ] },
      { id: 3, products: [ { sku: 'b' }, { sku: 'b' }, { sku: 'b' } ] }
    ].extend(NestedArrayHelpers)
  end

  def test_tricky_orders_sort_by_sku
    expected = [2, 3, 1]
    assert_equal expected, tricky_orders.sort_by_nested_array(:products, :sku).map{ |o| o[:id] }
  end

  def book_orders
    [
      { id: 1, books: [ { isbn: 'c' }, { isbn: 'a' }, { isbn: 'c' } ] },
      { id: 2, books: [ { isbn: 'a' }, { isbn: 'c' }, { isbn: 'a' } ] },
      { id: 3, books: [ { isbn: 'b' }, { isbn: 'b' }, { isbn: 'b' } ] }
    ].extend(NestedArrayHelpers)
  end

  def test_another_array_sort_by_nested_array
    expected = [2, 3, 1]
    assert_equal expected, book_orders.sort_by_nested_array(:books, :isbn).map{ |o| o[:id] }
  end

  module Foobar
    def foo
      'foo'
    end

    def bar
      'bar'
    end
  end

  def test_array_extension
    arr = [3, 1, 2]
    arr.extend(Foobar)
    assert_equal 'foo', arr.foo
    arr.sort_by!{ |i| i }
    assert_equal [1, 2, 3], arr
    assert_equal 'bar', arr.bar
  end

  def test_nested_array_module
    orders = tricky_orders
    orders.extend(NestedArrayHelpers)
    orders.sort_nested_array(:products, :sku).sort_by_nested_array(:products, :sku)
  end

  def test_minitest_mock
    mock = Minitest::Mock.new
    mock.expect :sort_nested_array, true, [:products, :sku]

    NestedArray.stub :new, mock do
      arr = NestedArray.new [3, 1, 2]
      arr.sort_nested_array(:products, :sku)

      assert mock.verify
    end
  end
end
