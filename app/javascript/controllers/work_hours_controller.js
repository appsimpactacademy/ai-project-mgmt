import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="work-hours"
export default class extends Controller {
  static targets = ["totalHours", "workHoursChart", "chart"];

  connect() {
    this.filter();
  }

  async filter(event) {
    const filterValue = event ? event.target.value : "past_7_days";
    const url = new URL(window.location.href);
    url.searchParams.set('filter', filterValue);

    try {
      const response = await fetch(url, {
        method: 'GET',
        headers: {
          'Accept': 'application/json'  // Expect JSON for chart data
        }
      });
      
      if (response.ok) {
        const data = await response.json();
        this.updateTotalHours(data.totalHours);
        this.updateChart(data.labels, data.data);
      } else {
        console.error('Failed to fetch filtered data');
      }
    } catch (error) {
      console.error('Error fetching filtered data:', error);
    }
  }

  updateTotalHours(totalHours) {
    this.totalHoursTarget.innerHTML = totalHours + ' hours';
  }

  updateChart(labels, data) {
    const ctx = this.chartTarget.getContext('2d');
    // Clear existing chart if any
    if (this.chart) {
      this.chart.destroy();
    }
    this.chart = new Chart(ctx, {
      type: 'bar',
      data: {
        labels: labels,
        datasets: [{
          label: 'Weekly Hours',
          data: data,
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          borderColor: 'rgba(75, 192, 192, 1)',
          borderWidth: 1
        }]
      },
      options: {
        scales: {
          x: { beginAtZero: true },
          y: { beginAtZero: true }
        }
      }
    });
  }
}
