require 'test_helper'

class ChainingHelpersTest < Minitest::Test
  def tricky_orders
    [
      { id: 1, products: [ { sku: 'c' }, { sku: 'a' }, { sku: 'c' } ] },
      { id: 2, products: [ { sku: 'a' }, { sku: 'c' }, { sku: 'a' } ] },
      { id: 3, products: [ { sku: 'b' }, { sku: 'b' }, { sku: 'b' } ] }
    ].extend(NestedArrayHelpers)
  end

  def test_sort_nested_array_and_sort_by_nested_array
    expected= [
      { id: 2, products: [ { sku: 'a' }, { sku: 'a' }, { sku: 'c' } ] },
      { id: 1, products: [ { sku: 'a' }, { sku: 'c' }, { sku: 'c' } ] },
      { id: 3, products: [ { sku: 'b' }, { sku: 'b' }, { sku: 'b' } ] }
    ]

    assert_equal expected, tricky_orders.
      sort_nested_array(:products, :sku).
      sort_by_nested_array(:products, :sku)
  end
end
