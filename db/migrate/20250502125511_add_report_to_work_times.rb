class AddReportToWorkTimes < ActiveRecord::Migration[7.1]
  def change
    add_column :work_times, :report, :text
  end
end
