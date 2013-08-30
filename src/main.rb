#!/usr/local/bin/ruby

# This script performs an import from a psimi-tab file from IntAct into a
# postgres 8.x or later database
# Arguments:
# filename (-f), the psimitab to read and insert into db
# dbserver (-s), the database server name
# dbport (-p), the database server port
# dbname (-d), the database name
# dbuser (-u), the database username
# dbpasswd (-pw), the password



require_relative "db/intact_dao"
require_relative "util/interactions_util"

def process_param (cmd_switch, cmd_args)

	switch_index = cmd_args.index(cmd_switch)
	if switch_index.nil?
		print "#{cmd_switch} not found\n"
		nil
	else
		cmd_args[switch_index+1]
	end
end


# Process the arguments from the command line.
# @params [Array] args the ARGV array of arguments
# @return [Hash] a hash with the following keys: :filename, :dbserver, :dbport,
# :dbname, :dbuser, :dbpasswd
def process_cmd_line (args)
	params = Hash.new
	cmd_switches = {'-f' => :filename, '-s' => :dbserver, '-p' => :dbport, '-d' => :dbname, '-u' => :dbuser, '-pw' => :dbpass}

	if args.size < 5
		print "\tNo enough arguments.\n"
		print "\tUse 'ruby main.rb -f <filename> -s <dbserver> -p <dbport>\n"
		print "\t\t-d <dbname> -u <dbuser> -pw <dbpasswd>'\n"
		nil
	else
		cmd_switches.each_key { |switch|
			val = process_param(switch, args)
			if !val.nil?
				params[cmd_switches[switch]] = val
			end
		}
	end

	params
end




############################################################################
cmd_params = process_cmd_line(ARGV)
cmd_params.each_pair { |k, v|
	puts "#{k} => #{v}\n"
}

if cmd_params.has_key?(:filename)
# Create DAO object
# Open connection
#	dao = IntactDao.new('localhost','5432', 'intact','intact','1ntakt')
	dao = IntactDao.new(cmd_params[:dbserver], cmd_params[:dbport],
											cmd_params[:dbname], cmd_params[:dbuser], cmd_params[:dbpass])
#	puts "dao.conn: #{dao.conn.inspect}\n"

	File.open(cmd_params[:filename]) do |file|
		counter = 1
		first = true
		while line = file.gets
			if first
				first = !first
				next
			end
			fields = line.split("\t")
#			row_hash = buildup_interaction(fields)
			dao.insert_interaction(fields)
			print '#'

#			if counter < 25
#				puts "##{counter} -> #{row_hash[:a][:ids1]} - #{row_hash[:b][:ids2]}:	#{row_hash[:edge][:edgeid]} (#{row_hash[:edge][:confVal]})\n"
#			end
			counter += 1
		end
	end
	puts "\n"
# Fetch interactions based on uniprot acc, confidence value and number of neighgours
#	rs = dao.fetch_interactions('O14777', 0.6)
#	new_rs = InteractionsUtil.rebuild_interactions(rs)

	dao.close_conn

end



