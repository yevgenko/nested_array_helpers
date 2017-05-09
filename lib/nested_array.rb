module NestedArrayHelpers
  def sort_nested_array(node_key, nested_array_key)
    self.map { |item|
      item[node_key].sort_by! { |nested_item| nested_item[nested_array_key] }
      item
    }.extend(NestedArrayHelpers)
  end

  def sort_by_nested_array(node_key, nested_array_key)
    self.sort_by { |item|
      item[node_key].map{ |nested_item| nested_item[nested_array_key] }
    }.extend(NestedArrayHelpers)
  end
end
