require "active_support/core_ext/integer/time"

every 1.day, at: "4:30 am" do
  command "cd Backup && bundle exec backup perform -t mopio"
end
