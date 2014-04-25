class AuthController < ApplicationController 
  before_filter :authenticate_user!, :except => [ :logout_callback ] #,:geoserver_logout]

  #def geoserver_logout
  #logger.debug"Avant test server cpr = #{@@cpt}"

  # if @@cpt==0
  #  @@cpt=1
  #  logger.debug"A cote Dans la boucle du server_logout avec cpt = #{@@cpt}"
  #  redirect_to '/geonetwork/srv/eng/user.logout'
  # else
  #  @@cpt=0
  #  logger.debug"A cotee Dans le ELSE de server logout cpt = #{@@cpt}"
  #  redirect_to '/geonetwork'
  # end
  #end
										 
end

