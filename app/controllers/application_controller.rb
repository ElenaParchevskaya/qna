class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |_exception|
    head :forbidden
  end
end
