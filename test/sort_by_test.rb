gem 'minitest', '~> 5.4'
require 'minitest/autorun'

class SortByTest < Minitest::Test
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
    assert_equal expected, orders.sort_by{ |o| o[:products].map{ |p| p[:sku] } }.map{ |o| o[:id] }
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
    assert_equal expected, multi_products_orders.sort_by{ |o| o[:products].map{ |p| p[:sku] } }.map{ |o| o[:id] }
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
    assert_equal expected, tricky_orders.sort_by{ |o| o[:products].map{ |p| p[:sku] } }.map{ |o| o[:id] }
  end

  def test_tricky_orders_double_sort_by_sku
    expected= [
      { id: 2, products: [ { sku: 'a' }, { sku: 'a' }, { sku: 'c' } ] },
      { id: 1, products: [ { sku: 'a' }, { sku: 'c' }, { sku: 'c' } ] },
      { id: 3, products: [ { sku: 'b' }, { sku: 'b' }, { sku: 'b' } ] }
    ]

    orders = tricky_orders.map do |o|
      o[:products] = o[:products].sort_by{ |p| p[:sku] }
      o
    end

    assert_equal expected, orders.sort_by{ |o| o[:products].map{ |p| p[:sku] } }
  end

  def test_tricky_orders_double_sort_by_sku_v2
    expected= [
      { id: 2, products: [ { sku: 'a' }, { sku: 'a' }, { sku: 'c' } ] },
      { id: 1, products: [ { sku: 'a' }, { sku: 'c' }, { sku: 'c' } ] },
      { id: 3, products: [ { sku: 'b' }, { sku: 'b' }, { sku: 'b' } ] }
    ]

    orders = tricky_orders.sort_by do |o|
      o[:products] = o[:products].sort_by{ |p| p[:sku] }
      o[:products].map{ |p| p[:sku] }
    end

    assert_equal expected, orders
  end
end
