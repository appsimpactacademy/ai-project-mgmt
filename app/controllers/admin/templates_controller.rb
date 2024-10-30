class Admin::TemplatesController < AdminController
	def index
    @templates = Template.all.with_attached_template_image
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(template_params)
    if @template.save
        # generate_image(@template.content)
        redirect_to admin_templates_path, notice: 'Template created successfully.'
      else
        render :new
      end
    end

    def edit
      @template = Template.find(params[:id])
    end

    def update
      @template = Template.find(params[:id])
      if @template.update(template_params)
        redirect_to admin_templates_path, notice: 'Template updated successfully.'
      else
        render :edit
      end
    end

    private

    def template_params
      params.require(:template).permit(:name, :template_image, :description)
    end

    def check_admin
      redirect_to root_path, alert: 'You are not authorized to perform this action.' unless current_user.admin?
    end
  end
