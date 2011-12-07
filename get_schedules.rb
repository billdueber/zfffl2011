require 'mechanize'


loginname = ARGV[0]
password =  ARGV[1]




agent = Mechanize::Mechanize.new

# Login
lform = agent.get('https://login.yahoo.com/config/login').form('login_form')
lform.login    = loginname
lform.passwd  = password
agent.submit(lform, lform.buttons.first)

(1..13).each do |week|
  url = "http://football.fantasysports.yahoo.com/f1/370852/?lhst=sched&sctype=week&scweek=#{week}"
  agent.get(url).save("schedules/#{week}.html")
end


