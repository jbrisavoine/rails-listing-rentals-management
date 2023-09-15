class MissionsController < ApplicationController
  before_action :set_mission, only: %i[show update destroy]

  def index
    @missions = Mission.all
    render json: { missions: @missions }
  end

  def create
    @mission = Mission.new(mission_params)
    calculate_mission_price(@mission) # Calculate mission price
    if @mission.save
      render json: @mission, status: :created
    else
      render json: @mission.errors, status: :unprocessable_entity
    end
  end

  def update
    if @mission.update(mission_params)
      calculate_mission_price(@mission) # Recalculate mission price
      render json: @mission
    else
      render json: @mission.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @mission.destroy
    head :no_content
  end

  private

  def calculate_mission_price(mission)
    listing = mission.listing
    num_rooms = listing.num_rooms

    case mission.mission_type
    when 'first_checkin', 'checkout_checkin'
      mission.price = num_rooms * 10
    when 'last_checkout'
      mission.price = num_rooms * 5
    else
      mission.errors.add(:mission_type, 'Invalid mission type')
    end
  end

  def set_mission
    @mission = Mission.find(params[:id])
  end

  def mission_params
    params.require(:mission).permit(:listing_id, :mission_type, :date, :price)
  end
end
