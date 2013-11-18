# coding: utf-8
Redmine::WikiFormatting::Macros.register do
  desc "Links to resource page.\n_Example:_\n\n  {{bx_resource(3)}}"
  macro :bx_resource do |obj, args|
    resource_id = args.first
    resource = BxResourceNode.where(:id => resource_id).first
    if resource
      link_label = resource.code
      link_label << " : #{resource.summary}" if resource.summary.present?
      link_to(link_label, project_bx_resource_path(resource.project_id, resource))
    else
      ""
    end
  end
  desc "Links to table definition page.\n_Example:_\n\n  {{bx_table(3)}}"
  macro :bx_table do |obj, args|
    table_def_id = args.first
    table_def = BxTableDef.where(:id => table_def_id).first
    if table_def
      link_label = table_def.physical_name
      link_label << " : #{table_def.logical_name}" if table_def.logical_name.present?
      link_to(link_label, project_bx_table_def_path(table_def.project_id, table_def))
    else
      ""
    end
  end
end

