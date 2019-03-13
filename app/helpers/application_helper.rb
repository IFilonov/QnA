module ApplicationHelper

  def flash_messages
    flash.map do |type, message|
      content_tag :div, message
    end.join("\n").html_safe
  end
end
