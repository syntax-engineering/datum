
class <%= class_name %> < ActiveRecord::Base
  establish_connection :datum
<%= "  set_table_name :#{table_name}\n" if table_name -%>
  attr_accessible <%= model_attributes.map { |a| ":#{a.name}" }.join(", ") %>
end
