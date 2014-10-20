namespace :xmls do
  desc "Gets xml files from BGG"
  task :get_from_api => :environment do
    `ls -la tmp/xmls/ | grep "    45" | awk '{print $9}' | xargs -I % rm tmp/xmls/%`
    existing_xmls = Dir.new("tmp/xmls").to_a

    (1..165000).step(500).each do |start_id|
      end_id = start_id + 499
      file_name = "#{'%06i' % start_id}-#{'%06i' % end_id}.xml"
      unless existing_xmls.include?(file_name)
        puts "Getting #{file_name}"
        curl_string = "curl \"http://www.boardgamegeek.com/xmlapi2/thing?type=boardgame&stats=1&id=#{(start_id..end_id).to_a.join(',')}\" -o tmp/xmls/#{file_name} --connect-timeout 500 --max-time 500"
        `#{curl_string}`
        puts "Got it"
      end
    end

    puts "OMG OMG OMG OMG IT'S DONE!!!"
  end

  desc "Read the xml files and put the objects into the database"
  task :put_in_db => :environment do
    BoardGame.delete_all
    Category.delete_all
    Mechanic.delete_all
    Family.delete_all
    Publisher.delete_all
    Artist.delete_all

    (1..165000).step(500).each do |start_id|
      end_id = start_id + 499
      file_name = "tmp/xmls/#{'%06i' % start_id}-#{'%06i' % end_id}.xml"

      puts "Reading #{file_name}"
      BoardGame.parse File.new(file_name, "rb").read
    end
  end
end
