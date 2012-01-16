#encoding: utf-8

categories = Settings.categories.to_hash

categories.each do |parent_category_name, children_category_names|
  parent_category_name = parent_category_name.to_s
  puts "create #{parent_category_name} parent_category..."
  parent_category = Category.find_or_initialize_by_name(parent_category_name.to_s, :code => parent_category_name.to_url)
  parent_category.save!
  children_category_names.each do |child_category_name|
    child_category_name = child_category_name.to_s
    puts "create #{child_category_name} child_category..."
    child_category = Category.find_or_initialize_by_name(child_category_name.to_s, :code => child_category_name.to_url)
    child_category.parent = parent_category
    child_category.save!
  end
end