module StepsHelper
  # Return an icon as HTML to be placed in a button or link
  # name: name of icon
  def html_icon(name)
    if name == 'edit'
      return '<span class="glyphicon glyphicon-pencil"></span>'.html_safe
    elsif name == 'remove'
      return '<span class="glyphicon glyphicon-trash"></span>'.html_safe
    elsif name == 'up'
      return '<span class="glyphicon glyphicon-triangle-top"></span>'.html_safe
    elsif name == 'down'
      return '<span class="glyphicon glyphicon-triangle-bottom"></span>'.html_safe
    elsif name == 'home'
      return '<span class="glyphicon glyphicon-home"></span>'.html_safe
    elsif name == 'all'
      return '<span class="glyphicon glyphicon-list"></span>'.html_safe
    elsif name == 'back'
      return '<span class="glyphicon glyphicon-menu-left"></span>'.html_safe
    elsif name == 'ok'
      return '<span class="glyphicon glyphicon-ok"></span>'.html_safe
    elsif name == 'tab-left'
      return '<span class="glyphicon glyphicon-arrow-left"></span>'.html_safe
    elsif name == 'tab-right'
      return '<span class="glyphicon glyphicon-arrow-right"></span>'.html_safe
    elsif name == 'info'
      return '<span class="glyphicon glyphicon-info-sign"></span>'.html_safe
    end

    return nil
  end
end
