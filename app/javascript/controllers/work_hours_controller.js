import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="work-hours"
export default class extends Controller {
  static targets = ["totalHours"];
  connect() {
  }

  initialize() {
    // this.element.setAttribute('data-action', 'change->work-hours#setLoggingWorkHours');
  }

  // setLoggingWorkHours() {
  //   const selectedTaskType = this.element.options[this.element.selectedIndex].value;
  //   const hoursDropDown = document.getElementById('time_log_time_in_hours')
  //   if(selectedTaskType == 'Full Day') {
  //     hoursDropDown.selectedIndex = '32';
  //   } else if(selectedTaskType == '1st Half' || selectedTaskType == '2nd Half') {
  //     hoursDropDown.selectedIndex = '16';
  //   } else {
  //     hoursDropDown.selectedIndex = '0'
  //   }
  // }

  async filter(event) {
    const filterValue = event.target.value;
    const url = new URL(window.location.href);
    url.searchParams.set('filter', filterValue);

    try {
      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'text/html'
        }
      });
      
      if (response.ok) {
        const html = await response.text();
        this.updateTotalHours(html);
      } else {
        console.error('Failed to fetch filtered data');
      }
    } catch (error) {
      console.error('Error fetching filtered data:', error);
    }
  }

  updateTotalHours(html) {
    const parser = new DOMParser();
    const doc = parser.parseFromString(html, 'text/html');
    const newTotalHours = doc.querySelector('#total-hours');
    if (newTotalHours) {
      this.totalHoursTarget.innerHTML = newTotalHours.innerHTML;
    }
  }
}
