# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
    def observe_fields(fields, options={})
#		fields = []
    with = ''
    fields.each do |field_id|
      with += " + '&' + " unless with == ''
      with += "Form.Element.serialize('#{field_id}')"
      end
    options[:with] ||= with
    js = ''
    fields.each do |field_id|
      js += observe_field(field_id, options)
    end

    js
  end
  def set_focus(id)
       javascript_tag("$(\"#{id}\").focus()")
  end
end
