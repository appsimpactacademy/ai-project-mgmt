class Admin::SkillsController < AdminController
  before_action :set_skill, only: %i[edit update destroy]
  def index
    @skills = Skill.order(created_at: :desc)
  end

  def edit; end

  def new
    @skill = Skill.new
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      render_turbo_stream(
        'prepend',
        'skill-list',
        'admin/skills/skill',
        { skill: @skill }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        {
          form_partial: 'admin/skills/form',
          modal_title: 'Add New skill'
        }
      )
    end
  end

  def update
    if @skill.update(skill_params)
      render_turbo_stream(
        'replace',
        "skill-item-#{@skill.id}",
        'admin/skills/skill',
        { skill: @skill }
      )
    else
      render_turbo_stream(
        'replace',
        'remote_modal',
        'shared/turbo_modal',
        { 
          form_partial: 'admin/skills/form', 
          modal_title: 'Edit skill' 
        }
      )
    end
  end

  def destroy
    @skill.destroy
    render_turbo_stream(
      'remove',
      "skill-item-#{@skill.id}"
    )
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:name)
  end
end
