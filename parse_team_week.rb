require 'nokogiri'


weeks = 1..13
teams = (1..13).to_a.push(15)


weeks.each do |week|
  teams.each do |team|
    file = "teamweeks/#{team}_#{week}.html"
    n = Nokogiri.HTML(File.open(file))

    [0,1,2].each do |i|
      t0 = n.css("#statTable#{i}")
      t0.css('tr').each do |tr|
        next unless tr.css('td.pos').text =~ /\S/
        name = tr.css('td.player a.name').text
        (pteam, ppos) = tr.css('td.player span').text.gsub(/[() ]/, '').split('-')
        points = tr.css('td.pts').text.to_i
        pos = tr.css('td.pos').text
        pos = 'WRRB' if pos == 'W/R'
        puts [team,week,pos, ppos, pteam, name, points].join("|")
      end
    end
  end
end


