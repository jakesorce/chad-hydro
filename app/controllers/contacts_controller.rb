class ContactsController < ApplicationController
  respond_to :html

  def index
    respond_with do |format|
        format.html { render :layout => false }
      end
  end

  def submit_request
  end

end
