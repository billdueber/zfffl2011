require 'sqlite3'
require 'pp'

dbh = SQLite3::Database.new('2011.db')
weeks = 1..13

@getgames = dbh.prepare('select * from schedule where week = ?')
@getplayers = dbh.prepare('select ppos, name, points from players where week=? and zteam = ?')
@setmax = dbh.prepare('update schedule set t1max = ?, t2max = ? where week = ? AND t1 = ?')

class Player
  attr_accessor :ppos, :name, :pts, :available
  def initialize (ppos, name, pts)
    @ppos = ppos
    @name = name
    @pts = pts.to_i
    @available = true
  end
end

def maxpoints week, zteam
  roster = @getplayers.execute(week, zteam).map{|row| Player.new(*row)}.sort{|a,b| b.pts <=> a.pts}
  max = 0
  [/QB/, /WR/, /RB/, /RB|WR/, /TE/, /K/, /DEF/].each do |pos|
    roster.each do |p|
      next unless p.ppos =~ pos and p.available
      max += p.pts
      p.available = false
      break
    end
  end
  return max
end

weeks.each do |week|
  @getgames.execute(week).each do |row|
    t1 = row[1]
    t2 = row[2]
    @setmax.execute(maxpoints(week, t1), maxpoints(week, t2), week, t1)
  end
end

