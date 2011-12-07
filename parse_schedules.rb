require 'nokogiri'
require 'sqlite3'

dbh = SQLite3::Database.new('2011.db')
begin
  dbh.execute("drop table teams")
rescue
end
dbh.execute('create table teams (zteam int, name string)')


begin
  dbh.execute('drop table schedule')
rescue
end
dbh.execute('create table schedule (week int, t1 int, t2 int, t1pts int, t2pts int, t1max int, t2max int)')



n = Nokogiri.HTML(File.open('schedules/13.html'))
sth = dbh.prepare('insert into teams values (?, ?)')
n.css('#scheduletable td.team a').each do |t|
  name = t.text
  num = t.attr('href').split('/')[-1].to_i
  sth.execute(num, name)
end

sth = dbh.prepare('insert into schedule values (:week, :t1, :t2, :t1pts, :t2pts, 0, 0)')
(1..13).each do |week|
  n = Nokogiri.HTML(File.open("schedules/#{week}.html"))
  t = n.css('#scheduletable')
  games = t.css('table table tr').each_slice(2)
  games.each do |g|
    first, second = *g
    t1 = first.css('td.team a')[0]
    t1num = t1.attr('href').split('/')[-1]
    t1name = t1.text

    t2 = second.css('td.team a')[0]
    t2num = t2.attr('href').split('/')[-1]
    t2name = t2.text

    t1pts = first.css('td.score').text
    t2pts = second.css('td.score').text
    
    sth.execute('week'=>week, "t1"=>t1num, "t2"=>t2num, "t1pts" => t1pts, "t2pts"=>t2pts)
  end
end

