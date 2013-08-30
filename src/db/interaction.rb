
# It just is a model for a interaction
class Interaction

	attr_reader :intr_a, :intr_b, :interaction_id, :interaction_type,
							:interaction_conf_val, :interactoin_detect_meth, :interation_pubmed

	def initialize (*args)

		if args.size == 1 # suppossed a hash as parameter
			@intr_a_id = an_intr[:a][:ids1]
			@intr_a_alt = an_intr[:a][:altIds]
			@intr_a_alias = an_intr[:a][:aliases] 
			@intr_a_taxid = an_intr[:a][:taxId]
			@intr_a = {:id => @intr_a_id, :altIds => @intr_a_alt, :alias => @intr_a_alias, :tax => @intr_a_taxid}
			
			@intr_b_id = an_intr[:b][:ids2] 
			@intr_b_alt = an_intr[:b][:altIds]
			@intr_b_alias = an_intr[:b][:aliases]
			@intr_b_taxid = an_intr[:b][:taxId]
			@intr_b = {:id => @intr_b_id, :altIds => @intr_b_alt, :alias => @intr_b_alias, :tax => @intr_b_taxid}

			@interaction_id = an_intr[:edge][:edgeid]
			@interaction_type = an_intr[:edge][:type]
			@interaction_conf_val = an_intr[:edge][:confVal]
			@interactoin_detect_meth = an_intr[:edge][:detect]
			@interation_pubmed = an_intr[:edge][:pubmed]
		end
		
	end



end