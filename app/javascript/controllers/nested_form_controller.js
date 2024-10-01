import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="nested-form"
export default class extends Controller {
  static targets = ['educationRecords', 'workExperienceRecords', 'endYear', 'endDate']

  connect() {
    this.educationIndex = this.educationRecordsTargets.length;
    this.workIndex = this.workExperienceRecordsTargets.length;
  }

  addEducation(event) {
    event.preventDefault();
    const template = document.querySelector('#education_template').innerHTML.replace(/NEW_RECORD/g, this.educationIndex);
    document.querySelector('#education_records-list').insertAdjacentHTML('beforeend', template);
    this.educationIndex++;
  }

  removeEducation(event) {
    event.preventDefault();
    const item = event.target.closest('.education-record');
    item.querySelector("input[name*='_destroy']").value = '1';
    item.style.display = "none"; // Mark for deletion instead of removing
  }

  addWork(event) {
    event.preventDefault();
    const template = document.querySelector('#work_template').innerHTML.replace(/NEW_RECORD/g, this.workIndex);
    document.querySelector('#work_experiences-list').insertAdjacentHTML('beforeend', template);
    this.workIndex++;
  }

  removeWork(event) {
    event.preventDefault();
    const item = event.target.closest('.work-experience');
    item.querySelector("input[name*='_destroy']").value = '1';
    item.style.display = 'none'; // Mark for deletion instead of removing
  }
  isPursuingCheked(event){
    if (event.target.checked) {
      this.endYearTarget.style.display = 'none';
    } else {
      this.endYearTarget.style.display = 'block';
    }
  }
  isWorkingChecked(event) {
    if (event.target.checked) {
      this.endDateTarget.style.display = 'none';
    } else {
      this.endDateTarget.style.display = 'block';
    }
  }
}
