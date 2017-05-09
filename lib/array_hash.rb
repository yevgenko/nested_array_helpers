class ArrayHash < Array
  def sort_nested_array(node_key, nested_array_key)
    self.class.new self.map { |item|
      item[node_key].sort_by! { |nested_item| nested_item[nested_array_key] }
      item
    }
  end

  def sort_by_nested_array(node, array_key)
    self.class.new self.sort_by { |o| o[node].map{ |p| p[array_key] } }
  end
end
