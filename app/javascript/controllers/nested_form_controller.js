import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="nested-form"
export default class extends Controller {
  static targets = ['educationRecords', 'workExperienceRecords', 'endYear', 'endDate', 'isPursuingCheckbox', 'isCurrentlyWorkingCheckbox']

  connect() {
    this.educationIndex = this.educationRecordsTargets.length;
    this.workIndex = this.workExperienceRecordsTargets.length;
  }

  addEducation(event) {
    event.preventDefault();
    const template = document.querySelector('#education_template').innerHTML.replace(/NEW_RECORD/g, this.educationIndex);
    document.querySelector('#education_records-list').insertAdjacentHTML('beforeend', template);
    this.educationIndex++;
    document.querySelector('.alert-education').classList.add('d-none');
  }

  removeEducation(event) {
    event.preventDefault();
    const item = event.target.closest('.education-record');
    item.querySelector("input[name*='_destroy']").value = '1';
    item.style.display = "none"; // Mark for deletion instead of removing
    document.querySelector('.alert-education').classList.remove('d-none');
  }

  addWork(event) {
    event.preventDefault();
    const template = document.querySelector('#work_template').innerHTML.replace(/NEW_RECORD/g, this.workIndex);
    document.querySelector('#work_experiences-list').insertAdjacentHTML('beforeend', template);
    this.workIndex++;
    document.querySelector('.alert-work').classList.add('d-none');
  }

  removeWork(event) {
    event.preventDefault();
    const item = event.target.closest('.work-experience');
    item.querySelector("input[name*='_destroy']").value = '1';
    item.style.display = 'none'; // Mark for deletion instead of removing
    document.querySelector('.alert-work').classList.remove('d-none');
  }


  isPursuingChecked(event) {
    const selectedCheckbox = event.target; // The checkbox that was just checked
    const record = event.target.closest('.education-record'); // Target the specific form being interacted with

    // Check if this checkbox is being checked
    if (selectedCheckbox.checked) {
      // Check if any other checkbox is already checked
      const otherCheckedCheckbox = this.isPursuingCheckboxTargets.find(checkbox => checkbox !== selectedCheckbox && checkbox.checked);
      if (otherCheckedCheckbox) {
        // Show alert and uncheck the selected checkbox
        Swal.fire({
          title: 'Alert!',
          text: 'Please uncheck the previous form field before selecting this.',
          icon: 'warning',
          confirmButtonText: 'OK'
        });
        // alert("Please uncheck the previously selected 'is pursuing' field before selecting it here.");
        selectedCheckbox.checked = false; // Uncheck the current checkbox
        return; // Exit the function
      }

      // Disable the end year input if checked
      const endYearTarget = record.querySelector('[data-nested-form-target="endYear"]');
      endYearTarget.children[1].setAttribute("disabled", true); // Disable end year input
      endYearTarget.children[1].value = null;
    } else {
      // If unchecked, enable the end year input
      const endYearTarget = record.querySelector('[data-nested-form-target="endYear"]');
      endYearTarget.children[1].removeAttribute('disabled');
    }
  }

  isWorkingChecked(event) {
    const selectedCheckbox = event.target; // The checkbox that was just checked
    const record = event.target.closest('.work-experience'); // Target the specific form being interacted with

    // Check if this checkbox is being checked
    if (selectedCheckbox.checked) {
      // Check if any other checkbox is already checked
      const otherCheckedCheckbox = this.isCurrentlyWorkingCheckboxTargets.find(checkbox => checkbox !== selectedCheckbox && checkbox.checked);
      if (otherCheckedCheckbox) {
        // Show alert and uncheck the selected checkbox
        Swal.fire({
          title: 'Alert!',
          text: 'Please uncheck the previous form field before selecting this.',
          icon: 'warning',
          confirmButtonText: 'OK'
        });
        selectedCheckbox.checked = false; // Uncheck the current checkbox
        return; // Exit the function
      }

      // Disable the end date input if checked
      const endDateTarget = record.querySelector('[data-nested-form-target="endDate"]');
      endDateTarget.setAttribute("disabled", true); // Disable end date input
      endDateTarget.value = null; // Clear value
    } else {
      // If unchecked, enable the end date input
      const endDateTarget = record.querySelector('[data-nested-form-target="endDate"]');
      endDateTarget.removeAttribute("disabled");
      endDateTarget.setAttribute("max", new Date().toISOString().split("T")[0]); // Set max date
    }
  }
}
