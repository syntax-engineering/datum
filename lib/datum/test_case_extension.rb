
module Datum
  module TestCaseExtension
    
    #def self.datum_test meth, &block
    #end



    def setup
      puts "-- TCE Setup"
      tst_case = @test_case
      token = tst_case[(tst_case.index("_") + 1)..(tst_case.rindex("_")-1)]

      #puts "-- the testcase: #{@test_case}"
      #puts "-- the token: #{token}"

      #puts "## #{@local_blocks} ##"

      data = @local_blocks[token]

      unless data.nil?
        #puts "data"

        block = (data.pop)
        raw_hash = block.call unless block.nil?
        #puts "#{raw_hash}"
        @datum = build_datum raw_hash
        #@local_blocks[token].delete if data.count == 0
      else
        #puts "no data"
      end

    end
  end
end


      #puts "++ #{block}"
      #puts " in setup: #{simpsons_house.name}"
  #    raw_hash = block.yield unless block.nil?
  #    @datum = build_datum raw_hash
      #@@data_blocks["my_thing"].delete if data.count == 0