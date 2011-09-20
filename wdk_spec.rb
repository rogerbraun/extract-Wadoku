#encoding: utf-8
require "./wdk_method.rb"

describe Wadoku do

  describe "regexes" do 
    it "should parse <HW NAr: C>" do
    "<HW NAr: C>".gsub(Wadoku::HW_regex, "").should == "C"
    end
    it "should parse  <HW m: Vokal> „<Topic: a>“" do
    "<HW m: Vokal> „<Topic: a>“".gsub(Wadoku::HW_regex, "").should == "Vokal „<Topic: a>“"
    end
  end

  describe Wadoku::Entry do
    before(:each) do
      @entry = "6376215\t一視同仁\t\tいっしどうじん\t(<POS: N.>) <MGr: <TrE: <HW f: Bruderschaft> aller Menschen>; <TrE: <HW f: Gleichheit> ohne Diskriminierung>; <TrE: universale <HW f: Menschenliebe>>>."

      @gokuboso_str = "8720235	極細; ごく細	極細	ごくぼそ	(<POS: N.>) <MGr: <TrE: <HW f: Feinheit>>>.	名	0		HE					ごく[WaSep]ぼそ	"

      @gokuboso_entry = Wadoku::Entry.new(@gokuboso_str)

      @wdk_entry = Wadoku::Entry.new(@entry)

    end

    it "should initialize to a valid entry" do
      @wdk_entry.schreibung.should == ["一視同仁"]
      @wdk_entry.lesung.should == ["いっしどうじん"]
      @wdk_entry.deutsch.should == "(<POS: N.>) <MGr: <TrE: <HW f: Bruderschaft> aller Menschen>; <TrE: <HW f: Gleichheit> ohne Diskriminierung>; <TrE: universale <HW f: Menschenliebe>>>."

    end

    describe "#sub_entries" do
      it "should split entries into an Array of subentries" do
        @wdk_entry.sub_entries.should == ["6376215\t一視同仁\tいっしどうじん\tBruderschaft aller Menschen", "6376215\t一視同仁\tいっしどうじん\tGleichheit ohne Diskriminierung", "6376215\t一視同仁\tいっしどうじん\tuniversale Menschenliebe"] 

        @gokuboso_entry.sub_entries.should == ["8720235\t極細\tごくぼそ\tFeinheit","8720235\tごく細\tごくぼそ\tFeinheit"]
      end
    end

    describe "#tres" do
      it "should give you all translation equivalents, with all markup removed" do
        @wdk_entry.tres.should == ["Bruderschaft aller Menschen", "Gleichheit ohne Diskriminierung", "universale Menschenliebe"]
        @gokuboso_entry.tres.should == ["Feinheit"]

      end
    end
  end

end
