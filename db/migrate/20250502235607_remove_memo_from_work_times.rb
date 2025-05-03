class RemoveMemoFromWorkTimes < ActiveRecord::Migration[7.1]
  def change
    remove_column :work_times, :memo, :string
  end
end
