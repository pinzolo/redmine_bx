# coding: utf-8
def link_to_bx_resource(resource_id)
  resource = BxResourceNode.where(:id => resource_id).first
  if resource
    link_label = resource.path
    link_label << " [#{resource.summary}]" if resource.summary.present?
    link_to(link_label, project_bx_resource_path(resource.project_id, resource))
  else
    ""
  end
end

def link_to_bx_table_def(table_def_id)
  table_def = BxTableDef.where(:id => table_def_id).first
  if table_def
    link_label = table_def.physical_name
    link_label << " [#{table_def.logical_name}]" if table_def.logical_name.present?
    link_to(link_label, project_bx_table_def_path(table_def.project_id, table_def))
  else
    ""
  end
end

Redmine::WikiFormatting::Macros.register do
  desc "Links to resource page.\n_Example:_\n\n  {{bx_resource(3)}}"
  macro :bx_resource do |obj, args|
    link_to_bx_resource(args.first)
  end
  desc "Shortcut of bx_resource macro."
  macro :bx_r do |obj, args|
    link_to_bx_resource(args.first)
  end
  desc "Links to table definition page.\n_Example:_\n\n  {{bx_table(3)}}"
  macro :bx_table do |obj, args|
    link_to_bx_table_def(args.first)
  end
  desc "Shortcut of bx_table macro."
  macro :bx_t do |obj, args|
    link_to_bx_table_def(args.first)
  end
end

