source 'https://supermarket.chef.io'

Dir.glob('./cookbooks/*').each do |path|
  cookbook File.basename(path), :path => path
end
