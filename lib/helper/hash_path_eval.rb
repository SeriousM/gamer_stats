class Hash
  # Returns the element at the end of the defined path
  #
  #   the path should be in format of "a/:b/c", symbols treated as symbols
  #   then a string interpreation expression is build like
  #   "self['a'][:b][c]"
  #
  #   known issue: path segments with slashes are not supported
  def path(hashPath)
    return self if hashPath.nil? or hashPath.empty?

    hashPath = hashPath.split('/').map{ |v| v.start_with?(":") ? "[#{v}]" : "['#{v}']" }.join
    hashPath = "self#{hashPath}"
    
    eval hashPath
  rescue
    nil
  end
end