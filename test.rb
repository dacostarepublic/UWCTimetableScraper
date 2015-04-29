require 'nokogiri'
require 'mechanize'

def scrapeTimetable (year,number,term)
	browser = Mechanize.new { |b| b.user_agent_alias="Linux Firefox"}
	page = browser.get "http://e-workver6.uwc.ac.za/applctns_timetable/default.aspx?year=" + year.to_s + "&number=" + number.to_s + "&style=studentportal&view=timetable&term=" + term.to_s
	@timetable = []
	page.links.each do |l|
		if l.href.include?("view=timetableentry")
			day = l.href.split('&')[4].delete "day="
			period = l.href.split('&')[5].delete "period="
			data = browser.get "http://e-workver6.uwc.ac.za/applctns_timetable/" + l.href
			temp = Nokogiri::HTML(data.body)
			entry = {:subject => l.text,:day => day.to_i, :period => period.to_i, :activity => temp.css('tr')[2].text.sub("Activity","").strip, :building => temp.css('tr')[4].text.sub("Building","").strip, :room => temp.css('tr')[5].text.sub("Room","").strip!}
			@timetable << entry
		end
	end
	@timetable
end
puts scrapeTimetable(2013,3033228,4).sort_by {|d| [d[:day],d[:period]]}
	
