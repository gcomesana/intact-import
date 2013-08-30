require "rspec"
require 'spec_helper'

describe "IntactDao class" do

	before :all do
		@dao = IntactDao.new('localhost', '5432', 'intact', 'intact', '1ntakt')
		@new_rs = Array.new
	end

	it "should fetch some rows" do
		@dao.should_not be_nil
		@dao.conn.should_not be_nil
		rs = @dao.fetch_interactions('O14777', 0.3)

		rs.should be_kind_of Integer
		rs.should be > 0
		@dao.result_set.should have_at_least(25).items
		@dao.result_set[0].should_not be equal? @dao.result_set[2]

		#To change this template use File | Settings | File Templates.
		true.should == true
	end


	it "should rebuild interactions" do
		numrows = @dao.fetch_interactions('O14777', 0.3)
		numrows.should be == 28

		@new_rs = @dao.rebuild_interactions(@dao.result_set, 5)
		@new_rs.should_not be_empty
		@new_rs.length.should == 5
		@new_rs[0].should be_kind_of Hash
		@new_rs[0][:info].should_not be_empty
		@new_rs[0][:info][0].should be_kind_of Hash

		count_links = 0
		@new_rs.each { |item|
			count_links += item[:info].length
		}

		count_links.should be <= numrows


	end


	it "all interactions the target of interest has" do
		numrows = @dao.fetch_interactions('O14777', 0.3)
		numrows.should be == 28

		@new_rs = @dao.rebuild_interactions(@dao.result_set, 5)
		the_selected = @new_rs.select { |elem|
			elem[:intr1] == 'O14777' || elem[:intr2] =='O14777'
		}

		the_selected.should_not be_empty
		the_selected.length.should == @new_rs.length
	end


	it "should get interactions for neighbours among themselves" do
		numrows = @dao.fetch_interactions('O14777', 0.3)
		numrows.should be == 28

#		target_interactions = InteractionsUtil.rebuild_interactions(@dao.result_set, 5)
		target_interactions = @dao.rebuild_interactions(@dao.result_set, 5)
		neighbours = @dao.get_neighbours(target_interactions, 'O14777')
		neighbours.should_not be_empty
		neighbours.should_not include('O14777')

		numrows = @dao.fetch_neighbours_interactions(neighbours, 0.3)
		numrows.should be > 0
		@dao.interaction_net.should_not be_empty
		@dao.interaction_net.length.should == 9

	end


	it "should convert the resultset into a array of hashes" do
		numrows = @dao.fetch_interactions('O14777', 0.3)

		target_interactions = @dao.rebuild_interactions(@dao.result_set, 5)
		neighbours = @dao.get_neighbours(target_interactions, 'O14777')

		numrows = @dao.fetch_neighbours_interactions(neighbours, 0.3)

		neigbour_interactions = @dao.rebuild_neighbour_interactions(@dao.interaction_net)
		neigbour_interactions.should_not be_empty
		neigbour_interactions.length.should == 3
		neigbour_interactions.length.should <= @dao.interaction_net.length
	end


	it "should get the whole graph in an array fashion" do
		target_interactions = @dao.rebuild_interactions(@dao.result_set, 5)
		neighbours = @dao.get_neighbours(target_interactions, 'O14777')

		numrows = @dao.fetch_neighbours_interactions(neighbours, 0.3)
		neigbour_interactions = @dao.rebuild_neighbour_interactions(@dao.interaction_net)

		fullnet = Array.new
		fullnet << target_interactions
		fullnet << neigbour_interactions
		fullnet.flatten!
		fullnet.length.should be == target_interactions.length + neigbour_interactions.length

		fullnet.each {|elem|
			puts "#{elem[:intr1]}-#{elem[:intr2]}"
			info = elem[:info]
			puts "#{info.length} interactions ("
			info.each {|intrinfo|
				puts "#{intrinfo[:conf_val]}"
			}
			puts "\n"
		}

	end


	after :all do
		@dao.close_conn
	end
end