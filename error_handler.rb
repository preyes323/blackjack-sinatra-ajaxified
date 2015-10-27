module ErrorHandler
  def add_error(err)
    @errors ||= []
    @errors << err
  end

  def errors_count
    @errors.length || 0
  end
end
