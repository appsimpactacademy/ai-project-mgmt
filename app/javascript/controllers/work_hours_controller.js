import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="work-hours"
export default class extends Controller {
  connect() {
  }

  initialize() {
    this.element.setAttribute('data-action', 'change->work-hours#setLoggingWorkHours');
  }

  setLoggingWorkHours() {
    const selectedTaskType = this.element.options[this.element.selectedIndex].value;
    const hoursDropDown = document.getElementById('time_log_time_in_hours')
    if(selectedTaskType == 'Full Day') {
      hoursDropDown.selectedIndex = '32';
    } else if(selectedTaskType == '1st Half' || selectedTaskType == '2nd Half') {
      hoursDropDown.selectedIndex = '16';
    } else {
      hoursDropDown.selectedIndex = '0'
    }
  }
}
