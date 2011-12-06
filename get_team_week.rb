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

__END__
teams.each do |team|
  url = "http://football.fantasysports.yahoo.com/f1/302646/?lhst=sched&sctype=team&scmid=#{team}"
  agent.get(url).save("#{team}_schedule.html")
  (1..14).each do |week|
    url =" http://football.fantasysports.yahoo.com/f1/302646/#{team}?week=#{week}"
    agent.get(url).save(("%s_week_%02d" % [team, week]) + '.html')
  end
end


 => 0 
ruby-1.9.2-p180 :040 > trs[0].css('td player').to_s
 => "" 
ruby-1.9.2-p180 :041 > trs[1].css('td player').to_s
 => "" 
ruby-1.9.2-p180 :042 > trs[1].css('td.player').each do |td|
ruby-1.9.2-p180 :043 >     end
 => 0 
ruby-1.9.2-p180 :044 > trs[0].css('td.player').to_s
 => "" 
ruby-1.9.2-p180 :045 > trs[1].css('td.player').to_s
 => "<td class=\"player\">\n<div nowrap>\n<a href=\"http://sports.yahoo.com/nfl/players/6760\" target=\"sports\" class=\"name\">Eli Manning</a> </div> <div class=\"detail\">\n<span>(NYG - QB)</span>   <a href=\"http://sports.yahoo.com/nfl/players/6760/news\" target=\"sports\" class=\"playernote\" data-ys-playerid=\"6760\" data-ys-playernote-view=\"notes\" id=\"playernote-6760\"><img class=\"playernote-icon\" src=\"http://l.yimg.com/a/i/us/sp/fn/default/full/p_notes.png\" width=\"11\" height=\"9\" border=\"0\" alt=\"Player notes\"></a> </div>\n</td>" 
ruby-1.9.2-p180 :046 > trs[1].css('td.player div.name').text
 => "" 
ruby-1.9.2-p180 :047 > trs[1].css('td.player a.name').to_s
 => "<a href=\"http://sports.yahoo.com/nfl/players/6760\" target=\"sports\" class=\"name\">Eli Manning</a>" 
ruby-1.9.2-p180 :048 > trs[1].css('td.player a.name').text
 => "Eli Manning" 
ruby-1.9.2-p180 :049 > trs[1].css('td.player span').text
 => "(NYG - QB)" 
ruby-1.9.2-p180 :050 > trs[1].css('td.pos').text
 => "QB" 
ruby-1.9.2-p180 :051 > trs[1].css('td.pts').text