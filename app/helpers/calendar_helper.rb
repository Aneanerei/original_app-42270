module CalendarHelper
  def custom_month_calendar(events:, start_date:, &block)
    calendar = SimpleCalendar::MonthCalendar.new(self, events, start_date: start_date)
    render partial: "shared/custom_month_calendar", locals: {
      start_date: start_date,
      date_range: calendar.date_range,
      calendar: calendar,
      passed_block: block
    }
  end
end
