import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="project-tasks"
export default class extends Controller {
  connect() {
  }

  initialize() {
    this.element.setAttribute('data-action', 'change->project-tasks#loadProjectTasks')
  }

  loadProjectTasks() {
    const selectedProject = this.element.options[this.element.selectedIndex].value
    this.url = `/employee/tasks/fetch_project_tasks?project_id=${selectedProject}`
    fetch(this.url, {
      headers: {
        Accept: "text/vnd-turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => Turbo.renderStreamMessage(html))
  }
}
