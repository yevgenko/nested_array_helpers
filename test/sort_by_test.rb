gem 'minitest', '~> 5.4'
require 'minitest/autorun'
require_relative '../lib/array_hash'

class SortByTest < Minitest::Test
  def test_empty_array_hash
    assert_equal [], ArrayHash.new
  end

  def test_non_empty_array_hash
    assert_equal [{id: 1}], ArrayHash.new([{id: 1}])
  end

  def test_sort_node_by_sku
    expected = [
      { id: 1, products: [ { sku: 'a' }, { sku: 'b' }, { sku: 'c' } ] }
    ]
    a = ArrayHash.new [
      { id: 1, products: [ { sku: 'c' }, { sku: 'a' }, { sku: 'b' } ] }
    ]

    assert_equal expected, a.sort_node(:products, :sku)
  end

  def test_sort_node_by_title
    expected = [
      { id: 1, products: [ { title: 'a' }, { title: 'b' }, { title: 'c' } ] }
    ]
    a = ArrayHash.new [
      { id: 1, products: [ { title: 'c' }, { title: 'a' }, { title: 'b' } ] }
    ]

    assert_equal expected, a.sort_node(:products, :title)
  end

  def test_sort_another_node_by_title
    expected = [
      { id: 1, line_items: [ { title: 'a' }, { title: 'b' }, { title: 'c' } ] }
    ]
    a = ArrayHash.new [
      { id: 1, line_items: [ { title: 'c' }, { title: 'a' }, { title: 'b' } ] }
    ]

    assert_equal expected, a.sort_node(:line_items, :title)
  end

  def orders
    [
      { id: 1, products: [ { sku: 'c' } ] },
      { id: 2, products: [ { sku: 'b' } ] },
      { id: 3, products: [ { sku: 'a' } ] }
    ]
  end

  def test_without_sort_by
    expected = [1, 2, 3]
    assert_equal expected, orders.map{ |o| o[:id] }
  end

  def test_sort_by_sku
    expected = [3, 2, 1]
    assert_equal expected, ArrayHash.new(orders).sort_by_nested_array(:products, :sku).map{ |o| o[:id] }
  end

  def multi_products_orders
    [
      { id: 1, products: [ { sku: 'c' }, { sku: 'c' } ] },
      { id: 2, products: [ { sku: 'b' }, { sku: 'b' } ] },
      { id: 3, products: [ { sku: 'a' }, { sku: 'a' } ] }
    ]
  end

  def test_multi_products_sort_by_sku
    expected = [3, 2, 1]
    assert_equal expected, ArrayHash.new(multi_products_orders).sort_by_nested_array(:products, :sku).map{ |o| o[:id] }
  end

  def tricky_orders
    [
      { id: 1, products: [ { sku: 'c' }, { sku: 'a' }, { sku: 'c' } ] },
      { id: 2, products: [ { sku: 'a' }, { sku: 'c' }, { sku: 'a' } ] },
      { id: 3, products: [ { sku: 'b' }, { sku: 'b' }, { sku: 'b' } ] }
    ]
  end

  def test_tricky_orders_sort_by_sku
    expected = [2, 3, 1]
    assert_equal expected, ArrayHash.new(tricky_orders).sort_by_nested_array(:products, :sku).map{ |o| o[:id] }
  end

  def book_orders
    [
      { id: 1, books: [ { isbn: 'c' }, { isbn: 'a' }, { isbn: 'c' } ] },
      { id: 2, books: [ { isbn: 'a' }, { isbn: 'c' }, { isbn: 'a' } ] },
      { id: 3, books: [ { isbn: 'b' }, { isbn: 'b' }, { isbn: 'b' } ] }
    ]
  end

  def test_another_array_sort_by_nested_array
    expected = [2, 3, 1]
    assert_equal expected, ArrayHash.new(book_orders).sort_by_nested_array(:books, :isbn).map{ |o| o[:id] }
  end

  def test_tricky_orders_double_sort_by_sku
    expected= [
      { id: 2, products: [ { sku: 'a' }, { sku: 'a' }, { sku: 'c' } ] },
      { id: 1, products: [ { sku: 'a' }, { sku: 'c' }, { sku: 'c' } ] },
      { id: 3, products: [ { sku: 'b' }, { sku: 'b' }, { sku: 'b' } ] }
    ]

    assert_equal expected, ArrayHash.new(tricky_orders).
      sort_node(:products, :sku).
      sort_by_nested_array(:products, :sku)
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
end
