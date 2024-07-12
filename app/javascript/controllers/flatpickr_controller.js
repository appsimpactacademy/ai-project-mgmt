import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flatpickr"
import flatpickr from "flatpickr"

export default class extends Controller {
  async connect() {
    this.employeeId = this.element.getAttribute('data-employee-id')
    this.url = `/employee/time_logs/fetch_logged_dates.json?employee_id=${this.employeeId}`
    try {
      const response = await fetch(this.url, {
        headers: {
          Accept: "application/json"
        }
      });
      const disabledDates = await response.json();
      this.picker = flatpickr(this.element, {
        dateFormat: "d-m-Y",
        disable: disabledDates
      })
    } catch(error) {
      console.error('Error in fetching logged dates: ', error)
    }
  }

  disconnect() {
    if (this.picker) {
      this.picker.destroy()
    }
  }
}
