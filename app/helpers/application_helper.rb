module ApplicationHelper
  def accessible_courses
    if can? :manage, Course
      active_courses
    else
      current_user.courses
    end
  end

  def link_to_course(course)
    if can?(:manage, course) and !current_user.courses.include?(course)
      link_to course.title, course_enrollments_path(course), method: :post
    else
      link_to course.title, course
    end
  end

  def current_if(*args)
    args.any?{ |arg| currently_in?(arg) } ? "current" : ""
  end

  def currently_in?(arg)
    if arg.is_a? Regexp
      arg =~ request.fullpath
    else
      params[:controller] == arg
    end
  end
end
