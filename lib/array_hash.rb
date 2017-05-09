class ArrayHash < Array
  def sort_node(*args)
    self.map { |item|
      parent, child = args
      item[parent] = item[parent].sort_by { |p| p[child] }
      item
    }
  end
end
