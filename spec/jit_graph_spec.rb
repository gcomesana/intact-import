require "rspec"
require 'spec_helper'

describe "JitGraph behaviour" do

	MAX_NEIGHBOURS = 6
	CONF_VAL = 0.3
	before :all do
#		@dao = IntactDao.new 'localhost', '5432', 'intact', 'intact', '1ntakt'
		@graph_jit = JitGraph.new
#		@uniprot_acc_test = 'P33755'
#		@uniprot_acc_test = 'Q04477'
		@uniprot_acc_test = 'Q14596'
		@interact_rs = nil
	end


	it 'should be created and a connection to db set' do
		@graph_jit.should_not be_nil
		@graph_jit.set_db_params('localhost', '5432', 'intact', 'intact', '1ntakt')

		@graph_jit.dao.should_not be_nil
		@graph_jit.dao.conn.should_not be_nil
	end


	it 'should get a result set of interactions from database' do
		@interact_rs = @graph_jit.get_interactions(@uniprot_acc_test, CONF_VAL, MAX_NEIGHBOURS)
		@graph_jit.uniprot_acc.should == @uniprot_acc_test
		@interact_rs.should_not be_nil
		@interact_rs.should be_kind_of Array
#		@interact_rs.should_not be_empty
		@interact_rs.empty?.should be_false
	end


	it 'should get resultset of interactions for a target' do
		@interact_rs = @graph_jit.get_interactions(@uniprot_acc_test, CONF_VAL, MAX_NEIGHBOURS)
		@interact_rs.should_not be_nil

		target_interactions = @graph_jit.get_interactions4node(@interact_rs, @uniprot_acc_test)
#		target_interactions.should_not be_empty
		target_interactions.should have_at_least(1).items
		target_interactions[0].should be_kind_of Hash
		target_interactions.length.should <= @interact_rs.length

	end


	it 'should get a set of nodes (nodeset) out of a interactions set' do
		@interact_rs = @graph_jit.get_interactions(@uniprot_acc_test, CONF_VAL, MAX_NEIGHBOURS)
		@interact_rs.should_not be_nil
		target_interactions = @graph_jit.get_interactions4node(@interact_rs, @uniprot_acc_test)

		nodeset = @graph_jit.yield_interactors(target_interactions)
		nodeset.should_not be_nil
#		nodeset.should_not be_empty
		nodeset.should have_at_most(MAX_NEIGHBOURS+1).items
	end


	it 'should yield a graph structure based on ruby hashes and arrays' do
		graph = @graph_jit.yield_graph(@uniprot_acc_test, CONF_VAL, MAX_NEIGHBOURS)
		graph.should be_kind_of Array
		graph.should have_at_least(1).item
		graph[0].should be_kind_of Hash

		graph[0].length.should == 4
		graph[0][:adjacencies].should be_kind_of Array

puts "#{graph.to_json}\n"
	end



	after :all do
		@graph_jit.dao.close_conn
	end
end