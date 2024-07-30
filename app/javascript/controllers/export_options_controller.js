// app/javascript/controllers/export_options_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["checkbox", "dateField", "form"];

  connect() {
    // Initialize listeners
    console.log('export controller connected');
    this.updateCheckboxes();
    this.clearDateField();
    this.element.addEventListener('show.bs.modal', this.setFormAction.bind(this));
  }

  updateCheckboxes() {
    this.checkboxTargets.forEach((checkbox) => {
      checkbox.addEventListener("change", () => {
        if (checkbox.checked) {
          this.checkboxTargets.forEach((otherCheckbox) => {
            if (otherCheckbox !== checkbox) {
              otherCheckbox.checked = false;
            }
          });
          this.dateFieldTarget.value = '';
        }
      });
    });
  }

  clearDateField() {
    this.dateFieldTarget.addEventListener("change", () => {
      if (this.dateFieldTarget.value) {
        this.checkboxTargets.forEach((checkbox) => {
          checkbox.checked = false;
        });
      }
    });
  }

  setFormAction(event) {
    const button = event.relatedTarget; // Button that triggered the modal
    const employeeProjectId = button.getAttribute('data-employee-project-id');
    if (employeeProjectId) {
      const form = this.formTarget;
      form.action = form.action.replace('PLACEHOLDER', employeeProjectId);
    }
  }
}
