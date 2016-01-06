class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy,
                                     :introduce]

  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
    @users = User.order('first_name ASC')
  end

  # GET /contacts/1/edit
  def edit
    @users = User.order('first_name ASC')
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)
    @user = User.find(params[:user_id][:id])
    @user.contacts << @contact

    if @contact.save
      flash[:success] = 'Contact was successfully created.'
      redirect_to @contact
    else
      flash[:error] = 'Whoops, that didn\'t work!'
      render 'new'
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    @user = User.find(params[:user_id][:id])
    @user.contacts << @contact

    if @contact.update(contact_params)
      flash[:success] = 'Contact was successfully updated.'
      redirect_to @contact
    else
      flash[:error] = 'Whoops, that didn\'t work!'
      render 'edit'
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    flash[:success] = 'Contact was successfully deleted.'
    redirect_to contacts_url
  end

  def introduce
    if @contact.user
      ContactsMailer.introduce(@contact, @current_user).deliver_now
      flash[:success] = "You just asked #{@contact.user.name} to contact #{@contact.first_name}!"
      redirect_to root_url
    else
      flash[:error] = "That didn't work!"
      redirect_to root_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :company, :role,
                                      :email, :phone_number,
                                      :relationship_strength, :involvement,
                                      :open_asks, :core_alumni,
                                      :columbia_alumni, :photo_url)
    end
end
