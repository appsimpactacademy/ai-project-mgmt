import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flatpickr"
import flatpickr from "flatpickr"
import "rangePlugin"

export default class extends Controller {
  async connect() {
    if(this.element.dataset.rangeSelect == 'true') {
      this.initializeFlatpickr();
    }else {
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
  }

  disconnect() {
    if (this.picker) {
      this.picker.destroy()
    }
  }

  initializeFlatpickr() {
    const fp = flatpickr(this.element, {
      mode: 'range',
      dateFormat: 'Y-m-d',
      onClose: (selectedDates, dateStr, instance) => {
        console.log(selectedDates);
        console.log(dateStr);
        const formattedStartDate = fp.formatDate(selectedDates[0], 'Y-m-d');
        const formattedEndDate = fp.formatDate(selectedDates[1], 'Y-m-d');
        this.element.value = `${formattedStartDate} to ${formattedEndDate}`;
      }
    });
    this.element._flatpickr = fp; // Store flatpickr instance for later use
    this.generateCustomButtons(fp);
  }
  generateCustomButtons(fp) {
    const customButtons = [
     {
        label: 'Last Week',
        range: () => {
          const today = new Date();
          const lastMonday = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay() - 6);
          const lastSunday = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay());
          return {
              from: fp.formatDate(lastMonday, 'Y-m-d'),
              to: fp.formatDate(lastSunday, 'Y-m-d')
          };
        }
      },
      {
        label: 'Current Week',
        range: function () {
          const today = new Date();
          const currentMonday = new Date(today.getFullYear(), today.getMonth(), today.getDate() - today.getDay() + 1);
          const currentSunday = new Date(today.getFullYear(), today.getMonth(), today.getDate() + (7 - today.getDay()));
          
          return {
              from: fp.formatDate(currentMonday, 'Y-m-d'),
              to: fp.formatDate(currentSunday, 'Y-m-d')
          };
        }
      },
      {
        label: 'Last Month',
        range: function () {
          const today = new Date();
          const firstDayLastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1);
          const lastDayLastMonth = new Date(today.getFullYear(), today.getMonth(), 0);
          
          return {
              from: fp.formatDate(firstDayLastMonth, 'Y-m-d'),
              to: fp.formatDate(lastDayLastMonth, 'Y-m-d')
          };
        }
      },
      {
        label: 'Current Month',
        range: function () {
          const today = new Date();
          const firstDayThisMonth = new Date(today.getFullYear(), today.getMonth(), 1);
          
          return {
              from: fp.formatDate(firstDayThisMonth, 'Y-m-d'),
              to: fp.formatDate(today, 'Y-m-d')
          };
        }
      }
    ];
    const buttonsContainer = document.createElement('div');
    buttonsContainer.className = 'flatpickr-buttons';

    customButtons.forEach(button => {
        const buttonElement = document.createElement('span');
        buttonElement.className = 'flatpickr-custom-button';
        buttonElement.textContent = button.label;
        buttonElement.addEventListener('click', () => {
            const range = button.range();
            fp.setDate([range.from, range.to]);
        });
        buttonsContainer.appendChild(buttonElement);
    });

    fp.calendarContainer.appendChild(buttonsContainer);
  }
}
