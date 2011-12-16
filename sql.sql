-- Totals view
drop view totals;
CREATE VIEW totals as 
  select p1.zteam as zteam, 
  (select sum(points) from players as p2 where p2.zteam=p1.zteam and p2.zpos = 'BN') as bench , 
  (select sum(points) from players as p2 where p1.zteam = p2.zteam and p2.zpos <> 'BN') as played,
  (select sum(t1max) from games as s where p1.zteam = s.t1) as max,
  ((select sum(points) from players as p2 where p2.zteam=p1.zteam and p2.zpos = 'BN') + 
   (select sum(points) from players as p2 where p1.zteam = p2.zteam and p2.zpos <> 'BN')) as total
  from players as p1 group by p1.zteam;
  
-- Games

CREATE VIEW games as select week, t1, t2, t1pts, t2pts, t1max, t2max from schedule 
UNION select week, t2, t1, t2pts, t1pts, t2max, t1max from schedule;

create view roster as 
  select g.week, g.t1, g.t2, g.t1pts, g.t2pts,
  (select points from players p where g.week = p.week and g.t1 = p.zteam and zpos = 'QB') as t1qb,
  (select points from players p where g.week = p.week and g.t1 = p.zteam and zpos = 'WR') as t1wr,
  (select points from players p where g.week = p.week and g.t1 = p.zteam and zpos = 'RB') as t1rb,
  (select points from players p where g.week = p.week and g.t1 = p.zteam and zpos = 'TE') as t1te,
  (select points from players p where g.week = p.week and g.t1 = p.zteam and zpos = 'WRRB') as t1wrrb,
  (select points from players p where g.week = p.week and g.t1 = p.zteam and zpos = 'K') as t1k, 
  (select points from players p where g.week = p.week and g.t1 = p.zteam and zpos = 'DEF') as t1def,
  (select points from players p where g.week = p.week and g.t2 = p.zteam and zpos = 'QB') as t2qb,
  (select points from players p where g.week = p.week and g.t2 = p.zteam and zpos = 'WR') as t2wr,
  (select points from players p where g.week = p.week and g.t2 = p.zteam and zpos = 'RB') as t2rb,
  (select points from players p where g.week = p.week and g.t2 = p.zteam and zpos = 'TE') as t2te,
  (select points from players p where g.week = p.week and g.t2 = p.zteam and zpos = 'WRRB') as t2wrrb,
  (select points from players p where g.week = p.week and g.t2 = p.zteam and zpos = 'K') as t2k, 
  (select points from players p where g.week = p.week and g.t2 = p.zteam and zpos = 'DEF') as t2def
from games g;
  

create view rosterwins as 
  select * from roster where t1pts > t2pts;
  
  
-- Best manager
=================
-- pct of max points
select teams.name, '(' || round(t.played * 1.0 / t.max * 100) || '%)'   as pct from totals t, teams where teams.zteam = t.zteam
order by t.played * 1.0 / t.max desc;

-- Number of perfect games
select t.name, count(g.t1) as perfect_games from games g, teams t where t.zteam = g.t1 and g.t1pts = g.t1max group by t.name;

-- Teams Beat
create view teamsbeat as select g1.week as week, g1.t1 as zteam, count(g2.t1) teamsbeat from games g1, games g2
where g1.week = g2.week and g1.t1pts > g2.t1pts and g1.t1 <> g2.t1 
group by g1.week, g1.t1;

-- Extra losses for a perfect opponent
create view extralosses as select t1, count(t1) from games where t1pts > t2pts and t2max > t1pts group by t1;

-- Wins views
create view wins as select t1, count(*) as wins from games where t1pts > t2pts group by t1;
create view super as  select t1, count(*) as wins from games where t1max > t2pts group by t1;
create view perfect as  select t1, count(*) as wins from games where t1max > t2max group by t1;
create view fair as select zteam as t1, count(*) as fair from teamsbeat where teamsbeat > 6 group by zteam;

create view record as
  select w.t1 as zteam,
         teams.name,
         w.wins,
         (select fair.fair from fair where w.t1 = fair.t1) as fair,
         (select super.wins from super where w.t1 = super.t1) as yourbest,
         (select perfect.wins from perfect where w.t1 = perfect.t1) as perfectworld
  from teams, wins w
  where teams.zteam = w.t1
  group by teams.name;


-- wins vs fair wins
select name, wins as actual, count(*) as fair, count(*) - wins as luck from teamsbeat, teams, wins
where teamsbeat > 6 and teams.zteam = teamsbeat.zteam and teams.zteam = wins.t1 group by teamsbeat.zteam, wins.wins order by count(*) - wins desc;

-- Games you would have lost if your opponents had been perfect.
select name, count(t1) from games, teams where t1pts > t2pts and t2max > t1pts and t1=zteam group by t1;

-- Perfect world, orderd by games won then points

select p.perfectworld as wins, sum(g.t1max) as points, p.name as name from record p, games g 
where p.zteam = g.t1 
group by p.perfectworld, p.name 
order by p.perfectworld desc, sum(g.t1max) desc;

