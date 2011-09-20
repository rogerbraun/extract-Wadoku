#encoding: utf-8
#myinsert dupliziert den Array

module Wadoku
  HW_regex = /(<HW.+?: )|(>)(?!\)|“)/
  Filter_regex = /(\[.+?\]|<Prior.+?>|<JLPT.+?>|<GENKI.+?>|<LangNiv.+?>|<Usage.+?>|<JWD.+?>|<Jap.+?>|<DaID.+?>|<Etym.+?>|\(<Ref.+?>\))/
  Tre_regex = /(?:<TrE:){1,}(.*?)(?=>>>|>;|>\. |>\ \/)/

  class Entry
    attr_accessor :da_id, :schreibung, :lesung, :deutsch
    def initialize(str)
      arr = str.split("\t")
      @da_id, @schreibung, @lesung, @deutsch = arr[0], arr[1],arr[3],arr[4]
      @schreibung = @schreibung.split(/[;]/).map(&:strip)
      @lesung = @lesung.split(/[;]/).map(&:strip)
    end

    def sub_entries
      @schreibung.product(@lesung).map{|schreibung, lesung| "#{@da_id}\t#{schreibung}\t#{lesung}"}.product(tres).map{|first_part, tre| "#{first_part}\t#{tre}"}
    end

    def tres
      @deutsch.gsub!(Filter_regex)
    
      tres = @deutsch.scan(Tre_regex).flatten
      # cleanup
      
      tres.map do |tre|
        tre.gsub(HW_regex,"").strip
      end
    end
  end

  #Datei extrahieren und in eine neue Datei schreiben
  def self.extract(wdk_raw, wdk_new)
    content = File.readlines(wdk_raw).drop(1)
    new_content = content.map{|entry| Wadoku::Entry.new(entry).sub_entries}.flatten.join("\n")
    file = File.new(wdk_new, "w")
    file.puts new_content
    file.close
  end

end

if ARGV.length < 2 then
  puts "Usage: wdk_method.rb input_file output_file"
else
  Wadoku.extract(ARGV[0],ARGV[1])
end
