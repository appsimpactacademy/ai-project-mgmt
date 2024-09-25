class Admin::TemplatesController < AdminController
	def index
      @templates = Template.all
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
        # generate_image(@template.content)
        redirect_to admin_templates_path, notice: 'Template updated successfully.'
      else
        render :edit
      end
    end

    private

    def template_params
      params.require(:template).permit(:name, :template_image)
    end

    def check_admin
      redirect_to root_path, alert: 'You are not authorized to perform this action.' unless current_user.admin?
    end

    # def generate_image(html_content)
    #    # Use a library like MiniMagick or a command-line tool to generate the image
	#   # Here is an example using a command-line tool like `wkhtmltoimage`

	#   # Create a temporary file for the image
	#   temp_file = Tempfile.new(['template_image', '.png'])
	  
	#   # Generate the image from HTML (adjust command as necessary)
	#   system("wkhtmltoimage --quality 75 --width 800 --height 600 --disable-smart-width '#{html_content}' #{temp_file.path}")

	#   # Attach the generated image to the template
	#   @template.template_image.attach(io: File.open(temp_file.path), filename: "#{@template.name}.png", content_type: 'image/png')
	  
	#   # Clean up the temporary file
	#   temp_file.close
	#   temp_file.unlink
    # end
end
