class SolrController < ApplicationController


	def search
	  	if params.has_key?(:query_term)
	  		query_term = URI::encode(params[:query_term].to_s)
	  		start = params[:start].to_i || 0
	  		@results = solr_connect(query_term ,start)
	  	end
  	end

  private
  
  def solr_connect(query_term, start)
  	h = Net::HTTP.new('localhost', 8983)
	http_response = h.get("/solr/haberler/select?q=#{query_term}&start=#{start}&wt=ruby")
	rsp = eval(http_response.body)	
  end

end
