class ArrayHash < Array
  def sort_node(parent, child)
    self.class.new self.map { |item|
      item[parent] = item[parent].sort_by { |p| p[child] }
      item
    }
  end

  def sort_by_nested_array(node, array_key)
    self.class.new self.sort_by { |o| o[node].map{ |p| p[array_key] } }
  end
end
