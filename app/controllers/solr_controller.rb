class SolrController < ApplicationController

	def search
	  	if params.has_key?(:query_term)
	  		query_term = URI::encode(params[:query_term].to_s)
	  		start = params[:start].to_i || 0
	  		facet_category =(params[:facet_category]) || 'no_category'
	  		@results = solr_connect(query_term ,start ,facet_category)
	  	end
  	end

  private
  def solr_connect(query_term, start, facet_category)
	begin
		h = Net::HTTP.new('localhost', 8983)

		if facet_category == 'no_category'
			http_response = h.get("/solr/haberler/select?q=#{query_term}&start=#{start}&wt=ruby&facet=true&facet.field=category")
		else
			facet_query = "fq=category%3A#{facet_category}"
			http_response = h.get("/solr/haberler/select?q=#{query_term}&start=#{start}&wt=ruby&#{facet_query}&facet=true&facet.field=category")	
		end

		rsp = eval(http_response.body)

	rescue Exception => e
			redirect_to root_path, alert: "Please check your Solr server status ! Error message : \"#{e}\""	
	end
end

end
