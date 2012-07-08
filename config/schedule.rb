env :PATH, '$PATH:/usr/bin:/bin:/usr/local/bin'
set :output, "/var/cron/log"

every 1.hour do
  runner "Session.sweep"
end

every :day, :at => '1:00 am' do
  runner "Character.reclue"
end