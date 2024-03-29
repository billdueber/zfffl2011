require 'mechanize'


loginname = ARGV[0]
password =  ARGV[1]


teams = (1..13).to_a.push(15)


agent = Mechanize::Mechanize.new

# Login
lform = agent.get('https://login.yahoo.com/config/login').form('login_form')
lform.login    = loginname
lform.passwd  = password
agent.submit(lform, lform.buttons.first)

teams.each do |team|
  (1..13).each do |week|
    url = "http://football.fantasysports.yahoo.com/f1/370852/#{team}?week=#{week}"
    agent.get(url).save("teamweeks/#{team}_#{week}.html")
  end
end

