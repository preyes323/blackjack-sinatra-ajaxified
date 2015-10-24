module ErrorHandler
  def add_error(err)
    session[:errors] ||= []
    session[:errors] << err
  end

  def clear_errors
    session[:errors] = nil
  end

  def errors
    session[:errors]
  end

  def error_count
    session[:errors].length
  end
end
