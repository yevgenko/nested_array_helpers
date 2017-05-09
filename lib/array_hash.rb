class ArrayHash < Array
  def sort_node(*args)
    self.map { |item|
      parent, child = args
      item[parent] = item[parent].sort_by { |p| p[child] }
      item
    }
  end

  def sort_by_nested_array(node, array_key)
    self.sort_by{ |o| o[node].map{ |p| p[array_key] } }
  end
end
