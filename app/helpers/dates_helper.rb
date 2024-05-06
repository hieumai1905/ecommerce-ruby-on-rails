module DatesHelper
  def format_date date
    date.strftime "%Y-%m-%d" if date.present?
  end

  def format_date_time date
    date.strftime "%H:%M %d-%m-%Y" if date.present?
  end
end
